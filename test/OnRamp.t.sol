// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {RegistryMerchants} from "../src/Registry.sol";
import {RouterContract} from "../src/Router.sol";
import {VaultCollateral} from "../src/Vault.sol";
import {EscrowContract} from "../src/Escrow.sol";
import {GovernanceDispute} from "../src/Governance.sol";
import {TestCoin} from "./MockERC20/ERC20.sol";

contract OnRamp is Test {
    TestCoin coin;
    VaultCollateral vault;
    RegistryMerchants registry;
    RouterContract router;
    EscrowContract escrow;
    GovernanceDispute governance;

    address alice = address(0x01);
    address bob = address(0x02);
    address admin = address(0x03);
    address adjudicator1 = address(0x04);
    address adjudicator2 = address(0x05);
    address adjudicator3 = address(0x06);
    address adjudicator4 = address(0x07);
    address adjudicator5 = address(0x08);

    event OfferPosted(address indexed user, uint256 indexed id, uint256 collateral);
    event OnRampCreated(address indexed escrow, address indexed merchant, address indexed user, uint256 amount);
    event Settled(address indexed merchant, address indexed user, bool on_ramp);
    event FundsUnlocked(address indexed reciever, uint256 amount);

    function setUp() public {
        vm.startPrank(alice);
        coin = new TestCoin("TestCoin", "TC");
        registry = new RegistryMerchants(address(coin));
        router = new RouterContract(address(registry), address(coin));
        governance =
            new GovernanceDispute(adjudicator1, adjudicator2, adjudicator3, adjudicator4, adjudicator5, address(router));
        router.set_governance(address(governance));
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
        router.registerMerchant();
        vm.stopPrank();
    }

    function test_post_offer() public {
        test_register_merchant();
        vm.startPrank(bob);
        vm.expectEmit(address(registry));
        emit OfferPosted(bob, 1, 10e18);
        router.postOffer(10e18, true, "RP", 16000);
    }

    function test_on_ramp() public {
        test_post_offer();
        vm.startPrank(alice);
        vm.expectEmit(address(router));
        emit OnRampCreated(address(0xfE2f43e66C38ab1d9d3026300698fb2E4a39a6b6), bob, alice, 10e18);
        router.on_ramp(bob, adjudicator1, adjudicator2, adjudicator3, adjudicator4, adjudicator5, 1);
    }

    function test_settle() public {
        test_on_ramp();
        vm.startPrank(bob);
        escrow = EscrowContract(0xfE2f43e66C38ab1d9d3026300698fb2E4a39a6b6);
        coin.approve(address(escrow), 10e18);
        vm.expectEmit(address(escrow));
        emit Settled(bob, alice, true);
        escrow.settle();
        assertEq(coin.balanceOf(address(escrow)), 10e18);
    }

    function test_unlock_funds() public {
        test_settle();
        vm.startPrank(bob);
        escrow = EscrowContract(0xfE2f43e66C38ab1d9d3026300698fb2E4a39a6b6);
        uint256 beforeBalance = coin.balanceOf(alice);
        vm.expectEmit(address(escrow));
        emit FundsUnlocked(alice, 10e18);
        escrow.unlock_funds();
        assertEq(coin.balanceOf(alice) - beforeBalance, 10e18);
    }
}
