// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LotteryContract {
    address public Manager;

    address payable[] public palyer;

    constructor() {
        Manager = msg.sender;
    }

    function alreadyEntered() private view returns (bool) {
        for (uint256 i = 0; i < palyer.length; i++) {
            if (msg.sender == palyer[i]) {
                return true;
            }
        }
        return false;
    }

    function EnterPlayer() public payable {
        require(
            msg.sender != Manager,
            "Manager is not Authorozed to Participate"
        );

        require(alreadyEntered() == false, "Player already Entered");

        require(msg.value >= 1 ether, "Minimum About required to participate");

        palyer.push(payable(msg.sender));
    }

    function RandomnumberGenerator() private view returns (uint256) {
        return
            uint256(
                sha256(abi.encodePacked(block.difficulty, block.number, palyer))
            );
    }

    function PickWinnerInLottery() public {
        require(msg.sender == Manager, "Only mananger can pickup the winner");
        uint256 index = RandomnumberGenerator() % palyer.length;
        address contractAddress = address(this);
        palyer[index].transfer(contractAddress.balance);
        palyer = new address payable[](0);
    }

    function getPlayer() public view returns (address payable[] memory) {
        return palyer;
    }
}
