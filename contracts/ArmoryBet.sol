/** This example code is designed to quickly deploy an example contract using Remix.
 *  If you have never used Remix, try our example walkthrough: https://docs.chain.link/docs/example-walkthrough
 *  You will need testnet ETH and LINK.
 *     - Kovan ETH faucet: https://faucet.kovan.network/
 *     - Kovan LINK faucet: https://kovan.chain.link/
 */

pragma solidity ^0.6.12;

import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";


contract ArmoryBet is VRFConsumerBase {
    
    bytes32 internal keyHash;
    uint256 internal fee;
    
    uint256  public randomResult;
    
    enum CoinFace{ TAIL, HEAD }
    
    // bet states
    mapping(bytes32 => address) private players;
    mapping(bytes32 => CoinFace) private bets;
    mapping(bytes32 => bool) private locks;
    mapping(bytes32 => uint256) private randomResults;
    
    // event: invoker submit bet with requestId. 
    event BetSubmit(address invoker, CoinFace bet, bytes32 requestId);
    
    // Event: invoker flip the coin, bet the head or tail, then the coin is flipped, and he is winner or loser.
    event FlipCoin(address invoker, CoinFace bet, CoinFace result, bool isWin, uint256 prob, bytes32 requestId);
    
    
    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Kovan
     * Chainlink VRF Coordinator address: 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * Key Hash: 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     */
    constructor() 
        VRFConsumerBase(
            0xa555fC018435bef5A13C6c6870a9d4C11DEC329C, // VRF Coordinator
            0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06  // LINK Token
        ) public
    {
        keyHash = 0xcaf3c3727e033261d383b315559476f48034c13b18f8cafed4d871abe5049186;
        fee = 0.1 * 10 ** 18; // 0.1 LINK
    }
    
    /** 
     * Requests randomness 
     */
    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) > fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResults[requestId] = randomness;
        uint256 prob = randomResults[requestId] % 100;     // use last 2 digit to estimate prob
        // if prob > 50 then head 
        CoinFace result;
        if (prob > 50) {
            result = CoinFace.HEAD;
        } else {
            result = CoinFace.TAIL;
        }
        
        bool isWin = result == bets[requestId];
        emit FlipCoin(players[requestId], bets[requestId], result, isWin, prob, requestId);
    }
    
    /**
     * Withdraw LINK from this contract
     * 
     * DO NOT USE THIS IN PRODUCTION AS IT CAN BE CALLED BY ANY ADDRESS.
     * THIS IS PURELY FOR EXAMPLE PURPOSES.
     */
    function withdrawLink() external {
        require(LINK.transfer(msg.sender, LINK.balanceOf(address(this))), "Unable to transfer");
    }
    
    function betCoin(CoinFace bet) public payable returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) > fee, "Not enough LINK - fill contract with faucet");
        requestId = requestRandomness(keyHash, fee);
        if (locks[requestId] == true){
            locks[requestId] = true;
            emit BetSubmit(msg.sender, bet, requestId);
        }
        return requestId;
    }
    
    function getPlayers(bytes32 requestId) public view returns (address) {
        return players[requestId];
    }
    
    function getBets(bytes32 requestId) public view returns (CoinFace) {
        return bets[requestId];
    }
    
    function getLocks(bytes32 requestId) public view returns (bool) {
        return locks[requestId];
    }
    
    function getRandomResults(bytes32 requestId) public view returns (uint256) {
        return randomResults[requestId];
    }
}