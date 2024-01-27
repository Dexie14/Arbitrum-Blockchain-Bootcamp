// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Donation {
    uint256 public immutable goal;
    address payable public owner;
    uint256 public progress;
    

    // Constructor to set the fundraising goal and initialize the owner
    constructor(uint256 goal_) {
        require(goal_ > 0, "Goal must be greater than 0");
        goal = goal_;
        owner = payable(msg.sender);
    }

    // Function to allow users to donate Ether
    function donate() public payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        require(progress + msg.value <= goal, "Goal exceeded. Please donate a lower amount.");

        progress += msg.value;
    }

    // Function to allow the owner to withdraw collected funds
    function withdrawFunds() external {
        require(msg.sender == owner, "Only the owner can withdraw funds");
        require(progress > 0, "Insufficient funds to withdraw");

        uint256 amountToWithdraw = progress;
        progress = 0;

        // Transfer funds to the owner
        payable(owner).transfer(amountToWithdraw);
    }

    // View function to get current progress and goal
    function getProgress() public view returns (uint256, uint256) {
        return (progress, goal);
    }
}
