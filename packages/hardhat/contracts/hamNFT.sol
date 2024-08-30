// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HamNFT is ERC721, Ownable {
    uint256 public goldPrice = 1 ether;
    uint256 public silverPrice = 0.5 ether;
    uint256 public bronzePrice = 0.1 ether;

    uint256 public goldSupply = 10;
    uint256 public silverSupply = 20;
    uint256 public bronzeSupply = 30;

    uint256 private goldMinted = 0;
    uint256 private silverMinted = 0;
    uint256 private bronzeMinted = 0;

    constructor() ERC721("HamNFT", "HAM") {}

    function mintGoldNFT() external payable {
        require(msg.value >= goldPrice, "Insufficient funds for Gold NFT");
        require(goldMinted < goldSupply, "Gold NFTs are sold out");

        goldMinted++;
        _safeMint(msg.sender, totalSupply() + 1);
    }

    function mintSilverNFT() external payable {
        require(msg.value >= silverPrice, "Insufficient funds for Silver NFT");
        require(silverMinted < silverSupply, "Silver NFTs are sold out");

        silverMinted++;
        _safeMint(msg.sender, totalSupply() + 1);
    }

    function mintBronzeNFT() external payable {
        require(msg.value >= bronzePrice, "Insufficient funds for Bronze NFT");
        require(bronzeMinted < bronzeSupply, "Bronze NFTs are sold out");

        bronzeMinted++;
        _safeMint(msg.sender, totalSupply() + 1);
    }

    function withdrawFunds() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function totalSupply() public view returns (uint256) {
        return goldMinted + silverMinted + bronzeMinted;
    }
}
