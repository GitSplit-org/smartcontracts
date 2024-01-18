// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract MultiWallet {
    address public owner;
    address public temporaryAddress; // Temporary address to store funds if wallet is not assigned
    mapping(string => address) public usernameToAddress;
    mapping(address => mapping(string => uint256)) public balances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the owner can perform this operation"
        );
        _;
    }

    function assignAddressToUsername(
        string memory username,
        address walletAddress
    ) public onlyOwner {
        usernameToAddress[username] = walletAddress;
    }

    function deposit(
        string[] memory usernames,
        uint256[] memory amounts
    ) public payable onlyOwner {
        require(
            usernames.length == amounts.length,
            "Arrays must have the same length"
        );

        for (uint256 i = 0; i < usernames.length; i++) {
            string memory username = usernames[i];
            uint256 amount = amounts[i];

            address receiver = usernameToAddress[username];

            if (receiver == address(0)) {
                // Wallet address not assigned, store funds to temporary address
                temporaryAddress = address(this);
                balances[temporaryAddress][username] += amount;
            } else {
                // Wallet address assigned, transfer funds directly
                require(
                    amount == msg.value,
                    "Sent value must match the specified amount"
                );
                balances[receiver][username] += amount;
                payable(receiver).transfer(amount);
            }
        }
    }

    function withdraw(string memory username, uint256 amount) public {
        address receiver = usernameToAddress[username];
        require(
            receiver == msg.sender,
            "You can only withdraw funds for your assigned username"
        );
        require(balances[receiver][username] >= amount, "Insufficient balance");
        balances[receiver][username] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getBalance(string memory username) public view returns (uint256) {
        address receiver = usernameToAddress[username];
        if (receiver == address(0)) {
            return balances[temporaryAddress][username];
        } else {
            return balances[receiver][username];
        }
    }
}
