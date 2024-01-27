// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ERC721Token {
    string public name;
    string public symbol;
    uint256 public totalSupply;

    mapping(uint256 => address) private owners;
    mapping(address => uint256) private balances;
    mapping(uint256 => address) private tokenApprovals;

    event Transfer(address indexed from, address indexed to, uint256 tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 tokenId);

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        return owners[_tokenId];
    }

    function approve(address _approved, uint256 _tokenId) public {
        require(msg.sender == owners[_tokenId], "Not the owner");
        tokenApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(tokenApprovals[_tokenId] == msg.sender, "Not approved");
        address previousOwner = owners[_tokenId];
        owners[_tokenId] = msg.sender;
        balances[previousOwner]--;
        balances[msg.sender]++;
        emit Transfer(previousOwner, msg.sender, _tokenId);
        emit Approval(previousOwner, address(0), _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public {
        require(msg.sender == owners[_tokenId], "Not the owner");
        require(_to != address(0), "Invalid address");
        owners[_tokenId] = _to;
        balances[msg.sender]--;
        balances[_to]++;
        emit Transfer(msg.sender, _to, _tokenId);
        emit Approval(msg.sender, address(0), _tokenId);
    }
}
