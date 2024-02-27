// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarketplace is ERC721, Ownable {
    struct NFT {
        uint256 id;
        address payable owner;
        uint256 price;
        bool forSale;
    }

    uint256 public nextTokenId;
    mapping(uint256 => NFT) public nfts;

    constructor() ERC721("NFT Marketplace", "NFTM") {}

    function mint(uint256 price) public onlyOwner {
        uint256 newTokenId = nextTokenId;
        _mint(msg.sender, newTokenId);
        nfts[newTokenId] = NFT(newTokenId, payable(msg.sender), price, true);
        nextTokenId++;
    }

    function buy(uint256 tokenId) public payable {
        require(msg.value >= nfts[tokenId].price, "Not enough ETH to buy this NFT");
        require(nfts[tokenId].forSale, "This NFT is not for sale");

        nfts[tokenId].owner.transfer(msg.value);
        _transfer(nfts[tokenId].owner, msg.sender, tokenId);
        nfts[tokenId].owner = payable(msg.sender);
        nfts[tokenId].forSale = false;
    }

    function toggleForSale(uint256 tokenId) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Caller is not owner nor approved");
        nfts[tokenId].forSale = !nfts[tokenId].forSale;
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owner[tokenId] != address(0);
    }
}
