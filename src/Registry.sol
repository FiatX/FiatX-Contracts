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
        uint256 remainingCollateral;
        Status status;
    }

    struct OfferData {
        uint256 id;
        address user;
        uint256 amount;
        string symbol;
        uint256 fiatAmount;
        bool on_ramp;
    }

    mapping(address => MerchantData) merchants;
    mapping(uint256 => OfferData) offerData;
    uint256 public offerId = 0;

    event Registered(address indexed user, uint256 collateral);
    event OfferPosted(address indexed user, uint256 indexed id, uint256 collateral);

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
        require(token.balanceOf(user) >= newCollateral, "Not enough USDT");

        //Transfer the funds to the vault
        token.transferFrom(user, vault, newCollateral);

        //now register the user
        MerchantData memory merchant = MerchantData(user, newCollateral, collateral, Status.ACTIVE);

        //set the new registered merchant
        merchants[user] = merchant;

        //emit the event
        emit Registered(user, collateral);
    }

    function postOffer(address user, uint256 amount, bool on_ramp, string memory symbol, uint256 fiatAmount) external {
        if (on_ramp == true) {
            require(merchants[user].user == user, "Not the user itself");
            // uint256 actualCollateral = (merchants[user].collateral.mul(5)).div(100) - amount;
            // require(merchants[user].collateral <= actualCollateral, "This is above the current collateral");
            require(merchants[user].remainingCollateral - amount <= 0, "Not enough collateral");
            offerId += 1;
            OfferData memory offer = OfferData(offerId, user, amount, symbol, fiatAmount, on_ramp);
            offerData[offerId] = offer;
            //reduce the remaining collateral
            merchants[user].remainingCollateral -= amount;
            emit OfferPosted(user, offerId, amount);
        } else {
            require(merchants[user].user == user, "Not the user itself");
            offerId += 1;
            OfferData memory offer = OfferData(offerId, user, amount, symbol, fiatAmount, on_ramp);
            offerData[offerId] = offer;
            emit OfferPosted(user, offerId, amount);
        }
    }

    function setStatus(address user, Status status) internal {
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

    function checkMerchant(address user) public view returns (bool) {
        require(merchants[user].user == user, "No such user exist");
        require(merchants[user].status == Status.ACTIVE, "User is not active");
        return true;
    }

    function getMerchantPost(address user, uint256 id) public view returns (uint256) {
        require(offerData[id].user == user, "No such user exist");
        return offerData[id].amount;
    }

    function getOfferPostStatus(uint256 id) public view returns (bool) {
        return offerData[id].on_ramp;
    }

    function getMerchantData(address user) public view returns (MerchantData memory) {
        return merchants[user];
    }
}
