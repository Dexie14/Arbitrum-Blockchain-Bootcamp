// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleThriftContract {
    address public owner;
    mapping(address => uint256) public balances;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed withdrawer, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        emit Withdrawal(msg.sender, amount);
    }

    // View function to check the balance of a specific address
    function getBalance(address account) public view returns (uint256) {
        return balances[account];
    }

    // View function to check the contract's total balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
