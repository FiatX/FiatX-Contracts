// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {RegistryMerchants} from "../src/Registry.sol";
import {RouterContract} from "../src/Router.sol";
import {VaultCollateral} from "../src/Vault.sol";
import {TestCoin} from "./MockERC20/ERC20.sol";

contract OnRamp is Test {
    TestCoin coin;
    VaultCollateral vault;
    RegistryMerchants registry;
    RouterContract router;

    address alice = address(0x01);
    address bob = address(0x02);

    function setUp() public {
        vm.startPrank(alice);
        coin = new TestCoin("TestCoin","TC");
        vault = new VaultCollateral(address(coin));
        registry = new RegistryMerchants(address(coin), address(vault));
        router = new RouterContract(address(registry));
        vm.stopPrank();
    }

    //TEST: Register the merchant to the registry (DONE)
    function test_register_merchant() public {
        vm.prank(alice);
        coin.transfer(bob, 100e18);
        vm.startPrank(bob);
        assertEq(coin.balanceOf(bob), 100e18);
        //aprove the registry contract because it will be the one that execute the transfer from
        coin.approve(address(registry), 100e18);
        router.registerMerchant(10e18);
        vm.stopPrank();
    }
}
