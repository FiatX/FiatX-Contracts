// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeMath} from "./lib/SafeMath.sol";
import {console} from "forge-std/Test.sol";

contract RegistryMerchants {
    using SafeMath for uint256;

    IERC20 public token;
    address public vault;

    enum Status {
        ACTIVE,
        NONACTIVE
    }

    struct MerchantData {
        address user;
        uint256 collateral;
        Status status;
    }

    mapping(address => MerchantData) merchants;

    event Registered(address indexed user, uint256 collateral);

    constructor(address _token, address _vault) {
        token = IERC20(_token);
        vault = _vault;
    }

    function registerMerchant(address user, uint256 collateral) external {
        //it needs to be 5% of the collateral
        uint256 newCollateral = (collateral.mul(5)).div(100) + collateral;

        console.logAddress(msg.sender);    

        //it will check if the user existed on the merchant registry
        require(merchants[user].user != user, "The merchant is registered");
        require(token.balanceOf(user) >= collateral, "Not enough USDT");

        //Transfer the funds to the vault
        token.transferFrom(user, vault, collateral);

        //now register the user
        MerchantData memory merchant = MerchantData(user, collateral, Status.ACTIVE);

        //set the new registered merchant
        merchants[user] = merchant;

        //emit the event
        emit Registered(user, collateral);
    }

    function setStatus(address user, Status status) external {
        //check if the merchant exist
        require(merchants[user].user == user, "User is not found");

        //return the merchant status
        merchants[user].status = status;
    }

    function getStatus(address user) public view returns (bool) {
        if (merchants[user].status == Status.ACTIVE) {
            return true;
        } else {
            return false;
        }
    }

    function getMerchantData(address user) public view returns (MerchantData memory) {
        return merchants[user];
    }
}
