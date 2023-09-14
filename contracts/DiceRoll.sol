// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract DiceRoll is VRFConsumerBaseV2 {
    // event CoinFlipRequest(uint requestId);
    // event CoinFlipResult(uint requestId, bool didWin);
    VRFCoordinatorV2Interface immutable vrfCoordinatorV2;
   
    event RandomWords(uint256 requestId, uint256[] randomWords);
    event DiceResult(uint256 requestId, uint256[] randomWords);

    bytes32 immutable keyHash;
    uint64 immutable subcriptionId;
    uint32 constant callBackGasLimit = 1_000_000;
    uint32 constant numWords = 1;
    uint16 constant requestConfirmations = 3;
    uint constant diceSides = 6;
    uint public randomResult;
    address _VRFCoordinator = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;

    constructor(uint64 _subscriptionId) VRFConsumerBaseV2(_VRFCoordinator) {
        vrfCoordinatorV2 = VRFCoordinatorV2Interface(_VRFCoordinator);
        keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;
        subcriptionId = _subscriptionId;
    }

    function rollDice() external returns (uint256 requestId) {
        //submit VRF request
        requestId = vrfCoordinatorV2.requestRandomWords(
            keyHash,
            subcriptionId,
            requestConfirmations,
            //max gas amount
            callBackGasLimit,
            numWords
        );
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        randomResult = (randomWords[0] % diceSides) + 1;
        emit RandomWords(requestId, randomWords);
    }

    function diceResult() public view returns (uint) {
        return randomResult;
    }
}
