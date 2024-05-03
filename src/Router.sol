// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IRegistryMerchants} from "./interface/IRegistryMerchants.sol";
import {EscrowContract} from "./Escrow.sol";

contract RouterContract {
    IRegistryMerchants public registry;
    address public token;

    struct EscrowData {
        address escrow;
        address adjudicator1;
        address adjudicator2;
        address adjudicator3;
        address adjudicator4;
        address adjudicator5;
        address merchant;
        address user;
        uint256 amount;
        bool on_ramp;
        bool done;
    }

    mapping(address => EscrowData) escrowMap;

    event OnRampCreated(address indexed escrow, address indexed merchant, address indexed user, uint256 amount);

    constructor(address _registry, address _token) {
        registry = IRegistryMerchants(_registry);
        token = _token;
    }

    function registerMerchant(uint256 collateral) external {
        //first deposit the collateral to the vault
        //second register it on the registry contract
        registry.registerMerchant(msg.sender, collateral);
    }

    function post_offer(uint256 amount) external {
        registry.postOffer(msg.sender, amount);
    }

    //deploy an escrow contract for merchant
    function on_ramp(
        address merchant,
        address adjudicator1,
        address adjudicator2,
        address adjudicator3,
        address adjudicator4,
        address adjudicator5,
        uint256 id
    ) external {
        require(registry.checkMerchant(merchant) == true, "Check failed");
        uint256 amount = registry.getMerchantPost(merchant, id);
        //deploy a escrow contract
        EscrowContract escrow = new EscrowContract(
            merchant,
            msg.sender,
            amount,
            adjudicator1,
            adjudicator2,
            adjudicator3,
            adjudicator4,
            adjudicator5,
            true,
            token
        );

        EscrowData memory escrowData = EscrowData(
            address(escrow),
            adjudicator1,
            adjudicator2,
            adjudicator3,
            adjudicator4,
            adjudicator5,
            merchant,
            msg.sender,
            amount,
            true,
            false
        );
        escrowMap[address(escrow)] = escrowData;
        emit OnRampCreated(address(escrow), merchant, msg.sender, amount);
    }

    //deploy an escrow contract for user
    function off_ramp() external {}

    function change_status_of_transaction(address escrow, address user) external {
        //The one who can change is base on is it on ramp or off ramp
        require(escrowMap[escrow].escrow == escrow, "Escrow doesnt exist");
        if(escrowMap[escrow].on_ramp == true){
            require(escrowMap[escrow].done != true, "Transaction is done");
            //Transaction is being done
            require(escrowMap[escrow].user == user, "Its not the user");
            escrowMap[escrow].done = true;
        }else {
            require(escrowMap[escrow].done != true, "Transaction is done");
            //Transaction is being done
            require(escrowMap[escrow].user == user, "Its not the merchant");
            escrowMap[escrow].done = true;
        }
    }

    function get_state_of_merchant(address user) internal view returns (bool) {
        //Get the state of the merchant on registry
        bool result = registry.getStatus(user);
        return result;
    }

    function get_status_of_transaction(address escrow) public view returns(bool){
        return escrowMap[escrow].done;
    }
}
