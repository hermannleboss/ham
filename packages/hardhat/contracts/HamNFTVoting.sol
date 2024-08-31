// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./hamNFT.sol"; // Import the HamNFT contract

contract HamNFTVoting is Ownable {
    HamNFT public hamNFT;

    struct Proposal {
        uint256 id;
        address creator;
        string description;
        uint256 deadline;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 abstainVotes;
        mapping(uint256 => bool) votes; // Tracks if an NFT has voted on this proposal
    }

    Proposal[] public proposals;
    uint256 public proposalCount = 0;

    constructor(address _hamNFTAddress) {
        hamNFT = HamNFT(_hamNFTAddress);
    }

    function createProposal(string memory description, uint256 duration) external {
        uint256 nftCount = hamNFT.balanceOf(msg.sender);
        require(nftCount > 0, "You must own an NFT to create a proposal");

        Proposal storage newProposal = proposals.push();
        newProposal.id = proposalCount++;
        newProposal.creator = msg.sender;
        newProposal.description = description;
        newProposal.deadline = block.timestamp + duration;
    }

    function voteOnProposal(uint256 proposalId, uint256 tokenId, uint8 voteType) external {
        require(proposalId < proposalCount, "Invalid proposal ID");
        require(hamNFT.ownerOf(tokenId) == msg.sender, "You do not own this NFT");
        require(block.timestamp < proposals[proposalId].deadline, "Voting period has ended");

        Proposal storage proposal = proposals[proposalId];
        require(!proposal.votes[tokenId], "This NFT has already been used to vote on this proposal");

        proposal.votes[tokenId] = true;

        if (voteType == 1) {
            proposal.forVotes++;
        } else if (voteType == 2) {
            proposal.againstVotes++;
        } else if (voteType == 3) {
            proposal.abstainVotes++;
        } else {
            revert("Invalid vote type");
        }
    }

    function getProposal(uint256 proposalId) external view returns (
        string memory description,
        address creator,
        uint256 deadline,
        uint256 forVotes,
        uint256 againstVotes,
        uint256 abstainVotes
    ) {
        require(proposalId < proposalCount, "Invalid proposal ID");

        Proposal storage proposal = proposals[proposalId];
        return (
            proposal.description,
            proposal.creator,
            proposal.deadline,
            proposal.forVotes,
            proposal.againstVotes,
            proposal.abstainVotes
        );
    }
}
