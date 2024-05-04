// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IRouter} from "../src/interface/IRouter.sol";
import {IGovernanceDispute} from "./interface/IGovernance.sol";
import {console} from "forge-std/Test.sol";

//this contract will be the one that is generated specifically for one
contract EscrowContract {
    //This will be immutable so that nobody could change it after deployed
    address public immutable adjudicator1;
    address public immutable adjudicator2;
    address public immutable adjudicator3;
    address public immutable adjudicator4;
    address public immutable adjudicator5;
    address public immutable merchant;
    address public immutable user;
    uint256 public immutable amount;
    uint256 public immutable timelock;

    bool public immutable on_ramp;

    struct TransactionData {
        address user;
        uint256 amount;
    }

    IERC20 public token;
    IRouter public router;
    IGovernanceDispute public governance;

    mapping(address => TransactionData) transactions;

    event Settled(address indexed merchant, address indexed user, bool on_ramp);
    event FundsUnlocked(address indexed reciever, uint256 amount);
    event RollBackState(address indexed reciever, uint256 amount);
    event DisputeMade(address indexed escrow, address indexed merchant, address indexed user);

    constructor(
        address _merchant,
        address _user,
        uint256 _amount,
        address _adjudicator1,
        address _adjudicator2,
        address _adjudicator3,
        address _adjudicator4,
        address _adjudicator5,
        bool _on_ramp,
        address _token,
        uint256 _timelock,
        address _governance
    ) {
        adjudicator1 = _adjudicator1;
        adjudicator2 = _adjudicator2;
        adjudicator3 = _adjudicator3;
        adjudicator4 = _adjudicator4;
        adjudicator5 = _adjudicator5;
        merchant = _merchant;
        user = _user;
        amount = _amount;
        on_ramp = _on_ramp;
        token = IERC20(_token);
        //the msg.sender here is the router contract
        router = IRouter(msg.sender);
        timelock = _timelock;
        governance = IGovernanceDispute(_governance);
    }

    //function to settle the order
    function settle() external {
        require(timelock > block.timestamp, "Timelock has finish");
        if (on_ramp == true) {
            //it will check if its settled ? if not yet in the mapping it means there hasnt been any transaction on ramp
            require(transactions[merchant].user != merchant, "Settlement is made");
            require(msg.sender == merchant, "Not the merchant");
            //if its the merchant
            token.transferFrom(merchant, address(this), amount);
            TransactionData memory transaction = TransactionData(merchant, amount);
            transactions[merchant] = transaction;
        } else {
            //it will check if its settled ? if not yet in the mapping it means there hasnt been any transaction onff ramp
            require(transactions[user].user != user, "Settlement is made");
            console.logAddress(msg.sender);
            require(msg.sender == user, "Not the user");
            token.transferFrom(user, address(this), amount);
            TransactionData memory transaction = TransactionData(user, amount);
            transactions[user] = transaction;
        }
        emit Settled(merchant, user, on_ramp);
    }

    function unlock_funds() external {
        require(timelock > block.timestamp, "Timelock has finish");
        if (on_ramp == true) {
            require(transactions[merchant].user == merchant, "There is no transaction made");
            require(router.get_status_of_transaction(address(this)) == false, "Transaction is done");
            require(msg.sender == merchant, "Caller is not the merchant");
            token.transfer(user, amount);
            emit FundsUnlocked(user, amount);
        } else {
            require(transactions[user].user == user, "There is no transaction made");
            require(router.get_status_of_transaction(address(this)) == false, "Transaction is done");
            require(msg.sender == user, "Caller is not the merchant");
            token.transfer(merchant, amount);
            emit FundsUnlocked(merchant, amount);
        }
    }

    function dispute() external {
        require(timelock > block.timestamp, "Timelock has finish");
        if (on_ramp == true) {
            require(msg.sender == merchant);
            governance.add_vote_dispute(address(this));
        } else {
            require(msg.sender == user);
            governance.add_vote_dispute(address(this));
        }
        emit DisputeMade(address(this), merchant, user);
    }

    function rollback_prestate() external {
        require(timelock < block.timestamp, "Timelock has not finish");
        //check if the funds is inside
        if (on_ramp == true) {
            token.transfer(merchant, amount);
            emit RollBackState(merchant, amount);
        } else {
            token.transfer(user, amount);
            emit RollBackState(user, amount);
        }
    }

    function check_user_has_settled(address user, address merchant) public view returns (address) {
        if (on_ramp == true) {
            //if address is not return then it doesnt exist
            return transactions[merchant].user;
        } else {
            //if address is not return then it doesnt exist
            return transactions[user].user;
        }
    }
}
