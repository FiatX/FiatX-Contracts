// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IRegistryMerchants} from "./interface/IRegistryMerchants.sol";
import {EscrowContract} from "./Escrow.sol";


contract RouterContract {

    IRegistryMerchants public registry;

    
    constructor(address _registry) {
        registry = IRegistryMerchants(_registry);
    }

    function registerMerchant(uint256 collateral) external {
        //first deposit the collateral to the vault 
        //second register it on the registry contract
        registry.registerMerchant(msg.sender,collateral);
    }

    //deploy an escrow contract for merchant
    function on_ramp() external {
        
    }

    //deploy an escrow contract for user
    function off_ramp() external {

    }

    function get_state_of_merchant(address user) internal view returns (bool) {
        //Get the state of the merchant on registry
        bool result = registry.getStatus(user);
        return result;
    }
}