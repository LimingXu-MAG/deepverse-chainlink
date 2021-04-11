// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "https://raw.githubusercontent.com/smartcontractkit/chainlink/master/evm-contracts/src/v0.6/ChainlinkClient.sol";

contract APIData is ChainlinkClient {
  
    uint256 public data;
    
    bytes32 public str;
    
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
    string constant public BASE_URL = "https://api.wolframalpha.com/v2/query?input=";
    string constant public FORMAT_URL = "&format=plaintext&output=JSON";
    
    /**
     * Network: Kovan
     * Chainlink - 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e
     * Chainlink - 29fa9aa13bf1468788b7cc4a500a45b8
     * Fee: 0.1 LINK
     */
    constructor() public {
        setPublicChainlinkToken();
        oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;
        jobId = "29fa9aa13bf1468788b7cc4a500a45b8";
        fee = 0.1 * 10 ** 18; // 0.1 LINK
    }
    
    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function requestData() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        request.add("get", "https://api.wolframalpha.com/v2/query?input=the+distance+between+New+York+and+Shanghai&format=plaintext&output=JSON&appid=DEMO");
        request.add("path", "queryresult.parseidserver");
        
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
    function fulfill(bytes32 _requestId, uint256 _data) public recordChainlinkFulfillment(_requestId)
    {
        data = _data;
    }
    
    
    function dummyrequest() public returns (bytes32 requestId)
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        request.add("get", "https://api.wolframalpha.com/v2/query?input=are+cat+and+fox+the+same&format=plaintext&output=JSON&appid=DEMO");
        request.add("path", "queryresult.numpods");
        
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }        
    
    
    function concatenate(string calldata a, string calldata b) external pure returns (string memory)
    {
        string memory query = string(abi.encodePacked("Are ", a, " and ", b, " the same?"));
        return query; 
    }
    

    function concatenate_result(string calldata c) external returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        string memory query = string(abi.encodePacked(c));
        string memory query2 = string(abi.encodePacked(BASE_URL, query, FORMAT_URL));

        request.add("get", query2);
        request.add("path", "queryresult");
        
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }        
    /**
     * Withdraw LINK from this contract
     * 
     * NOTE: DO NOT USE THIS IN PRODUCTION AS IT CAN BE CALLED BY ANY ADDRESS.
     * THIS IS PURELY FOR EXAMPLE PURPOSES ONLY.
     */
    function withdrawLink() external {
        LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());
        require(linkToken.transfer(msg.sender, linkToken.balanceOf(address(this))), "Unable to transfer");
    }
}