//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract FourInvestors {
    // we have 4 investors
    // which should donate need sum of money
    // and ONLY then i can get this money
    uint64 constant private final_price = 4000000000000000000;
    address public owner;
    struct Sender {
        address account;
        uint sum;
        uint timestamp;
    }
    Sender[4] public senders;
    uint8 public count;
    constructor() {
        owner = msg.sender;
    }

    modifier checkSum(uint64 _sum) {
        require(msg.value == _sum, "Incorrect sum");
        _;
    }
    modifier isOwner() {
        require(msg.sender == owner, "You are not owner");
        _;
    }
    modifier isNotOwner() {
        require(msg.sender != owner, "You are owner");
        _;
    }
    modifier sumEnought() {
        require(address(this).balance <= final_price, "Sum is enought");
        _;
    }
    modifier sumNotEnought() {
        require(address(this).balance == final_price, "Sum is NOT enought");
        _;
    }
    modifier alreadyPayed() {
       for(uint8 i; i < senders.length; i++) {
            require(senders[i].account != msg.sender, "You already payed :)");
        }
        _;
    }

    function send() public checkSum(1000000000000000000) isNotOwner alreadyPayed sumEnought payable {
        if (count <= 3) {
            senders[count] = Sender(msg.sender, msg.value, block.timestamp);
            count++;
        } else {
            count = 0;
        }
    }
    function checkBalance() public view returns(uint) {
        return address(this).balance;
    }
    function getMoney(address payable _to) public isOwner sumNotEnought {
        _to.transfer(final_price);
    }
}

