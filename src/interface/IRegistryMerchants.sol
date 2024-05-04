// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IRegistryMerchants {
    function registerMerchant(address user, uint256 collateral) external;
    function postOffer(address user, uint256 amount, bool on_ramp, string memory symbol, uint256 fiatAmount) external;
    function getStatus(address user) external view returns (bool);
    function checkMerchant(address user) external view returns (bool);
    function getMerchantPost(address user, uint256 id) external view returns (uint256);
    function getOfferPostStatus(uint256 id) external view returns (bool);
}
