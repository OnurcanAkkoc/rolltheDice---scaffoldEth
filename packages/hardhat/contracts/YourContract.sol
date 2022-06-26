pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

// import "@openzeppelin/contracts/access/Ownable.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract {
    event DiceRoll(address indexed sender, uint256 rollValue, uint256 payout);

    address public owner = 0xa0dF841F449FD8B7082605b5643BF69b0260de1f;
    uint256 public price = 0.025 ether;
    address public beneficiary = 0x97843608a00e2bbc75ab0C1911387E002565DEDE;

    constructor() payable {
        // what should we do on deploy?
    }

    function diceRoll() public payable {
        require(msg.value == price, "didn't pay enough!!");
        bytes32 decentRandom = keccak256(
            abi.encodePacked(block.difficulty, msg.sender, address(this))
        );

        uint8 roll = uint8(decentRandom[0]) % 6;
        console.log(roll);

        uint256 payout = 0;

        if (roll == 5) {
            // you get the pot
            payout = (address(this).balance * 90) / 100;
            (bool sent, ) = msg.sender.call{value: payout}("");
            require(sent, "Failed to send Ether");
            emit DiceRoll(msg.sender, roll, payout);
        } else if (roll >= 4) {
            // you get a small prize
            payout = price;
            (bool sent, ) = msg.sender.call{value: price}(""); // you'll get your money back
            require(sent, "Failed to send Ether");
            (sent, ) = msg.sender.call{value: price}("");
            if (sent) {
                payout += price;
            }
            // you'll get a small price if contract has enough budget!!
        } else {
            // y lose -- small portion will go to some charity!
            (bool sent, ) = beneficiary.call{value: 0.005 ether}("");
            require(sent, "Failed to send Ether");
        }
        emit DiceRoll(msg.sender, roll, payout);
    }

    // to support receiving ETH by default
    receive() external payable {}

    fallback() external payable {}
}
