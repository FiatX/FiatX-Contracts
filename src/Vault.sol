// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Ownable2Step, Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol";

contract VaultCollateral is Ownable2Step {
    IERC20 public token;

    struct CollateralData {
        address user;
        uint256 collateral;
    }

    mapping(address => CollateralData) collateralData;

    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }

    function deposit(uint256 collateral) external {
        token.transferFrom(msg.sender, address(this), collateral);
        CollateralData memory _collateral = CollateralData(msg.sender, collateral);
        collateralData[msg.sender] = _collateral;
    }

    function withrdaw() external {
        require(collateralData[msg.sender].user == msg.sender);
    }
}
