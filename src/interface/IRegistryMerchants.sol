// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IRegistryMerchants {
    function registerMerchant(address user, uint256 collateral) external;
    function getStatus(address user) external view returns (bool);
}
