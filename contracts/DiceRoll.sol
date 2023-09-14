// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
contract DiceRoll is VRFConsumerBaseV2 {
    // event CoinFlipRequest(uint requestId);
    // event CoinFlipResult(uint requestId, bool didWin);  
    VRFCoordinatorV2Interface immutable vrfCoordinatorV2;
     event DiceRolled(uint256 requestId, uint32 numWords);
    event DiceResult(uint256 requestId, uint256[] randomWords);
    
    bytes32 immutable keyHash;
    uint64 immutable subcriptionId ;
    uint32 constant callBackGasLimit = 1_000_000;
    uint32 constant numWords = 1;
    uint16 constant requestConfirmations = 2;
    uint constant  diceSides = 6;
    uint public randomResult;
    address _VRFCoordinator =  0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;
  
   
    //VRF Coordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D
    //LINK TOKEN = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB

  
    constructor( uint64 _subscriptionId ) payable VRFConsumerBaseV2( _VRFCoordinator){
    vrfCoordinatorV2 = VRFCoordinatorV2Interface(_VRFCoordinator);
    keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;
    subcriptionId = _subscriptionId;
    
   
    }
    function rollDice() external   returns (uint256 requestId){
      //submit VRF request 
      requestId = vrfCoordinatorV2.requestRandomWords(
        //price per gas
        keyHash,
        subcriptionId,
        requestConfirmations,
        //max gas amount
        callBackGasLimit,
        numWords);
    
 
    
    // emit CoinFlipRequest(requestId);
    // return requestId;
    }
  function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal   override {
        // require(statuses[requestId].fees > 0, "LINK tokens not enough");
       randomResult  =( randomWords[0] % diceSides) + 1;
       emit DiceResult(requestId, randomWords);

}
function    diceResult() public view returns(uint){
return randomResult;
}
 }