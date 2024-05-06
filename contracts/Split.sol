// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract MultiWallet {
    address public owner;
    address public temporaryAddress; // Temporary address to store funds if wallet is not assigned
    mapping(string => address) public usernameToAddress;
    mapping(address => mapping(string => uint256)) public balances;

    event AddressAssigned(string indexed username, address walletAddress);
    event FundsDeposited(
        address indexed receiver,
        string indexed username,
        uint256 amount
    );
    event FundsWithdrawn(
        address indexed receiver,
        string indexed username,
        uint256 amount
    );

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
        require(
            usernameToAddress[username] == address(0),
            "Username already has an assigned address"
        );

        usernameToAddress[username] = walletAddress;
        emit AddressAssigned(username, walletAddress);

        // Transfer funds from temporary address to the assigned wallet address
        uint256 amount = balances[temporaryAddress][username];
        if (amount > 0) {
            balances[temporaryAddress][username] = 0; // Clear the balance from the temporary address
            balances[walletAddress][username] += amount; // Add the balance to the assigned wallet address
            emit FundsDeposited(walletAddress, username, amount);
        }
    }

    function getAddressForUsername(
        string memory username
    ) public view returns (address) {
        return usernameToAddress[username];
    }

    function deposit(
        string[] memory usernames,
        uint256[] memory amountsInEther
    ) public payable {
        require(
            usernames.length == amountsInEther.length,
            "Arrays must have the same length"
        );

        uint256 totalAmount = 0;

        for (uint256 i = 0; i < usernames.length; i++) {
            string memory username = usernames[i];
            uint256 amount = amountsInEther[i];
            totalAmount += amount;

            address receiver = usernameToAddress[username];

            if (receiver == address(0)) {
                // Wallet address not assigned, store funds in the contract against the username
                temporaryAddress = address(this);
                balances[temporaryAddress][username] += amount;
            } else {
                // Wallet address assigned, transfer funds directly
                balances[receiver][username] += amount;
                emit FundsDeposited(receiver, username, amount);
            }
        }

        require(
            msg.value == totalAmount,
            "Sent value must match the sum of specified amounts"
        );

        // Transfer funds to assigned wallet addresses
        for (uint256 i = 0; i < usernames.length; i++) {
            string memory username = usernames[i];
            uint256 amount = amountsInEther[i];

            address receiver = usernameToAddress[username];

            if (receiver != address(0)) {
                payable(receiver).transfer(amount);
            }
        }
    }

    function withdraw(string memory username, uint256 amountInWei) public {
        address receiver = usernameToAddress[username];
        require(
            receiver == msg.sender,
            "You can only withdraw funds for your assigned username"
        );
        require(
            balances[receiver][username] >= amountInWei,
            "Insufficient balance"
        );
        balances[receiver][username] -= amountInWei;
        payable(msg.sender).transfer(amountInWei);
        emit FundsWithdrawn(receiver, username, amountInWei);
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
