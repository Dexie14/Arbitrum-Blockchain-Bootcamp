// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface INFT {
    function ownerOf(uint256 tokenId) external view returns (address);
    function transferFrom(address from, address to, uint256 tokenId) external;
}

interface INFTMarketplace {
    function listNFT(uint256 tokenId, uint256 price) external;
    function buyNFT(uint256 tokenId) external payable;
    function getNFTPrice(uint256 tokenId) external view returns (uint256);
    function upgrade(address newImplementation) external;
}

contract NFTMarketplace is INFTMarketplace {
    address private _implementation;
    mapping(uint256 => uint256) private _tokenPrices;
    mapping(uint256 => address) private _tokenOwners;
    INFT private _nftContract;

    constructor(address nftAddress) {
        _nftContract = INFT(nftAddress);
        _implementation = address(this);
    }

    function listNFT(uint256 tokenId, uint256 price) external override {
        require(_nftContract.ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT");
        _tokenPrices[tokenId] = price;
        _tokenOwners[tokenId] = msg.sender;
    }

    function buyNFT(uint256 tokenId) external payable override {
        uint256 price = _tokenPrices[tokenId];
        require(price > 0, "This NFT is not for sale");
        require(msg.value >= price, "Insufficient funds sent");

        address owner = _tokenOwners[tokenId];
        address buyer = msg.sender;

        _tokenOwners[tokenId] = address(0);
        _nftContract.transferFrom(owner, buyer, tokenId);
        
        if (msg.value > price) {
            payable(buyer).transfer(msg.value - price); // Refund excess payment
        }
    }

    function getNFTPrice(uint256 tokenId) external view override returns (uint256) {
        return _tokenPrices[tokenId];
    }

    function upgrade(address newImplementation) external override {
        require(msg.sender == _implementation, "Only the current implementation can upgrade the contract");
        _implementation = newImplementation;
    }
}