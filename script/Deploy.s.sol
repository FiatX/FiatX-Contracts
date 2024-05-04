// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {RegistryMerchants} from "../src/Registry.sol";
import {RouterContract} from "../src/Router.sol";
import {VaultCollateral} from "../src/Vault.sol";
import {EscrowContract} from "../src/Escrow.sol";
import {GovernanceDispute} from "../src/Governance.sol";
import {StableCoin} from "../src/USDT.sol";

contract DeploymentScript is Script {
    StableCoin coin;
    VaultCollateral vault;
    RegistryMerchants registry;
    RouterContract router;
    EscrowContract escrow;
    GovernanceDispute governance;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        address adjudicator1 = address(0x33d887177e8C87858BE496A60DC19747B55707Bf);
        address adjudicator2 = address(0x05);
        address adjudicator3 = address(0x06);
        address adjudicator4 = address(0x07);
        address adjudicator5 = address(0x08);
        coin = new StableCoin("USDT", "USDT");
        registry = new RegistryMerchants(address(coin));
        router = new RouterContract(address(registry), address(coin));
        governance =
            new GovernanceDispute(adjudicator1, adjudicator2, adjudicator3, adjudicator4, adjudicator5, address(router));
        router.set_governance(address(governance));
        vm.stopBroadcast();
    }
}
