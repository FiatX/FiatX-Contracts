// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

//this contract will be the one that is generated specifically for one
contract EscrowContract {
    //The transaction data
    struct TransactionData {
        address payer;
        address reciever;
        uint256 amount;
    }

    constructor(address merchant, address user, uint256 amount) {}

    //function to create the order
    function create_order() external {}
}
