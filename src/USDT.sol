// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable2Step, Ownable} from "../../lib/openzeppelin-contracts/contracts/access/Ownable2Step.sol";

contract StableCoin is ERC20, Ownable2Step {
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) Ownable(msg.sender) {
        _mint(msg.sender, 1000e18);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
