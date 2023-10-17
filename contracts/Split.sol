// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract MultiWallet {
    address public owner;
    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this operation");
        _;
    }

    function deposit(address[] memory receivers, uint256[] memory amounts) payable public onlyOwner {
        require(receivers.length == amounts.length, "Receiver and amount arrays must have the same length");
        uint256 amt = 0;
        for (uint256 index = 0; index < amounts.length; index++) {
            amt += amounts[index];
        }
        require(amt == msg.value , "insufficient value");
        for (uint256 i = 0; i < receivers.length; i++) {
            address receiver = receivers[i];
            uint256 amount = amounts[i];
            balances[receiver] += amount;
        }
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getBalance(address account) public view returns (uint256) {
        return balances[account];
    }
}