// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Test is ChainlinkClient {
    using Chainlink for Chainlink.Request;
    // address private immutable owner;

    struct VanEck {
        uint id;
        string holdingName;
        string ticker;
        string ISIN;
    }

    VanEck[] private data;

    uint256 private constant ORACLE_PAYMENT = (1 * LINK_DIVISIBILITY) / 10;
    uint private counter = 0;

    constructor() {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        // owner = msg.sender;
    }

    function getDataOf(uint _id) external view returns(
        uint id,
        string memory Holding_Name,
        string memory Ticker,
        string memory ISIN
    ){
        require(_id <= counter, "Enter a valid id");
        VanEck memory _data = data[_id - 1];

        return(
            id = _data.id,
            Holding_Name = _data.holdingName,
            Ticker = _data.ticker,
            ISIN = _data.ISIN
        );
    }

    function requestData(address _oracle, string memory _jobId) external {
        // require(msg.sender == owner, "Only callable by owner");
        
        counter += 1;
        string memory id = Strings.toString(counter);

        requestTicker(_oracle, _jobId, id);
        requestISIN(_oracle, _jobId, id);
        requestHoldingName(_oracle, _jobId, id);

        VanEck memory _data = VanEck(counter, "", "", "");

        data.push(_data);
    }

    function requestTicker(address _oracle, string memory _jobId, string memory _id) internal {
        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(_jobId),
            address(this),
            this.fulfillTicker.selector
        );

        req.add("id", _id);
        req.add("runid", _id);
        req.add("path", "data,Ticker");
        sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
    }

    function requestISIN(address _oracle, string memory _jobId, string memory _id) internal {
        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(_jobId),
            address(this),
            this.fulfillISIN.selector
        );

        req.add("id", _id);
        req.add("runid", _id);
        req.add("path", "data,ISIN");
        sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
    }

    function requestHoldingName(address _oracle, string memory _jobId, string memory _id) internal {
        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(_jobId),
            address(this),
            this.fulfillHoldingName.selector
        );

        req.add("id", _id);
        req.add("runid", _id);
        req.add("path", "data,Holding Name");
        sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
    }

    function fulfillTicker(bytes32 _requestID, string memory _ticker, uint _id) external recordChainlinkFulfillment(_requestID) {
        data[_id - 1].ticker = _ticker;
    }

    function fulfillISIN(bytes32 _requestID, string memory _ISIN, uint _id) external recordChainlinkFulfillment(_requestID) {
        data[_id - 1].ISIN = _ISIN;
    }

    function fulfillHoldingName(bytes32 _requestID, string memory _holdingName, uint _id) external
        recordChainlinkFulfillment(_requestID) {
            data[_id - 1].holdingName = _holdingName;
    }

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            // solhint-disable-line no-inline-assembly
            result := mload(add(source, 32))
        }
    }
}