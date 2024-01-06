// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract Auction {
    address public beneficiary;
    uint auctionEndTime;
    uint highestBid;
    address highestBidder;

    mapping (address => uint) pendingBids;

    event highestBidIncreased (address bidder, uint amount);

    event BidWithdrawal (address bidder, uint amount);

    event AuctionEnded (address bidder, uint amount);

    constructor (address payable beneficiaryAddress, uint biddingTime) {
        beneficiary = beneficiaryAddress;
        auctionEndTime = block.timestamp + biddingTime;
    }

    function bid () external payable {
        require (block.timestamp < auctionEndTime, "You can no longer participate in this auction");
        
        require (msg.value > highestBid, "Not enough Bid");

        highestBid !=0;
        pendingBids[highestBidder] = pendingBids[highestBidder] + highestBid;

        emit highestBidIncreased(highestBidder, highestBid);
    }
    function withdraw () external returns (bool) {
        uint amount = pendingBids[msg.sender];
        if (amount > 0) {
            pendingBids[msg.sender]=0;
         }

        if (payable(msg.sender).send(amount)) {
            pendingBids[msg.sender] = amount;

            emit BidWithdrawal(msg.sender, amount);

            return true;
        }
        return false;


    }

    function endAuction () external  {
        require (block.timestamp >= auctionEndTime, "Sorry! Auction Time Has Not Yet Ended.");

        require (block.timestamp < auctionEndTime, "Sorry! Auction Has Already Ended.");

        emit AuctionEnded(highestBidder, highestBid);


    }

}    
