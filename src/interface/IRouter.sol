// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IRouter {
    function change_status_of_transaction(address escrow, address user) external;
    get_status_of_transaction(address escrow) external view returns(bool)
}