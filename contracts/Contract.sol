// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Test is ChainlinkClient {
    using Chainlink for Chainlink.Request;
    address private immutable owner;

    struct VanEck {
        uint id;
        string HoldingName;
        string Ticker;
        string ISIN;
        string Shares;
        string MarketValue;
        string PerOfNetAssets;
    }

    VanEck[] private data;

    uint256 private constant ORACLE_PAYMENT = (1 * LINK_DIVISIBILITY) / 10;
    uint public counter = 0;

    constructor() {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        owner = msg.sender;
    }

    function getDataOf(uint _id) external view returns(
        uint id,
        string memory Holding_Name,
        string memory Ticker,
        string memory ISIN,
        string memory Shares,
        string memory MarketValue,
        string memory PerOfNetAssets
    ){
        require(_id <= counter, "Enter a valid id");
        VanEck memory _data = data[_id - 1];

        return(
            id = _data.id,
            Holding_Name = _data.HoldingName,
            Ticker = _data.Ticker,
            ISIN = _data.ISIN,
            Shares = _data.Shares,
            MarketValue = _data.MarketValue,
            PerOfNetAssets = _data.PerOfNetAssets
        );
    }

    function requestData(address _oracle, string memory _jobId) external {
        require(msg.sender == owner, "Only callable by owner");
        
        counter += 1;
        string memory id = Strings.toString(counter);

        requestTicker(_oracle, _jobId, id);
        requestISIN(_oracle, _jobId, id);
        requestHoldingName(_oracle, _jobId, id);
        requestShares(_oracle, _jobId, id);
        requestMarketValue(_oracle, _jobId, id);
        requestPerOfNetAssets(_oracle, _jobId, id);

        VanEck memory _data = VanEck(counter, "", "", "", "", "", "");

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

    function requestShares(address _oracle, string memory _jobId, string memory _id) internal {
        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(_jobId), 
            address(this),
            this.fulfillShares.selector
        );

        req.add("id", _id);
        req.add("runid", _id);
        req.add("path", "data,Shares");
        sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
    }

    function requestMarketValue(address _oracle, string memory _jobId, string memory _id) internal {
        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(_jobId),
            address(this),
            this.fulfillMarketValue.selector
        );

        req.add("id", _id);
        req.add("runid", _id);
        req.add("path", "data,Market Value");
        sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
    }

    function requestPerOfNetAssets(address _oracle, string memory _jobId, string memory _id) internal {
        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(_jobId),
            address(this),
            this.fulfillPerOfNetAssets.selector
        );

        req.add("id", _id);
        req.add("runid", _id);
        req.add("path", "data,% of Net Assets");
        sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
    }

    function fulfillTicker(bytes32 _requestID, string memory _ticker, uint _id) external recordChainlinkFulfillment(_requestID) {
        data[_id - 1].Ticker = _ticker;
    }

    function fulfillISIN(bytes32 _requestID, string memory _ISIN, uint _id) external recordChainlinkFulfillment(_requestID) {
        data[_id - 1].ISIN = _ISIN;
    }

    function fulfillHoldingName(bytes32 _requestID, string memory _holdingName, uint _id) external
        recordChainlinkFulfillment(_requestID) {
            data[_id - 1].HoldingName = _holdingName;
    }

    function fulfillShares(bytes32 _requestID, string memory _shares, uint _id) external recordChainlinkFulfillment(_requestID) {
        data[_id - 1].Shares = _shares;
    }

    function fulfillMarketValue(bytes32 _requestID, string memory _marketValue, uint _id) external recordChainlinkFulfillment(_requestID) {
        data[_id - 1].MarketValue = _marketValue;
    }

    function fulfillPerOfNetAssets(bytes32 _requestID, string memory _perOfNetAssets, uint _id) external recordChainlinkFulfillment(_requestID) {
        data[_id - 1].PerOfNetAssets = _perOfNetAssets;
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