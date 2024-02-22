// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GaslessTokenTransfer {
    mapping(address => uint256) public balances;
    mapping(address => mapping(bytes32 => bool)) public signatures;

    function transfer(address to, uint256 amount, bytes32 signature) payable external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(!signatures[msg.sender][signature], "Signature already used");

        balances[msg.sender] -= amount;
        balances[to] += amount;
        signatures[msg.sender][signature] = true;
    }

    function withdraw() external {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "No balance to withdraw");

        balances[msg.sender] = 0;
        msg.sender.transfer(balance); // Vulnerable to reentrancy
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }
}
