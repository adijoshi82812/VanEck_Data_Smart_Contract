// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract Test is ChainlinkClient {
    using Chainlink for Chainlink.Request;
    address private immutable owner;

    struct VanEck {
        uint id;
        string holdingName;
        string ticker;
        string ISIN;
    }

    VanEck[] public data;

    uint256 private constant ORACLE_PAYMENT = (1 * LINK_DIVISIBILITY) / 10;
    uint private counter = 0;

    constructor() {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        owner = msg.sender;
    }

    function requestData(address _oracle, string memory _jobId, string memory _id) external {
        require(msg.sender == owner, "Only callable by owner");

        requestTicker(_oracle, _jobId, _id);
        requestISIN(_oracle, _jobId, _id);
        requestHoldingName(_oracle, _jobId, _id);

        counter += 1;
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
        req.add("path", "data,Holding Name");
        sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
    }

    function fulfillTicker(bytes32 _requestID, string memory _ticker) external recordChainlinkFulfillment(_requestID) {
        data[counter - 1].ticker = _ticker;
    }

    function fulfillISIN(bytes32 _requestID, string memory _ISIN) external recordChainlinkFulfillment(_requestID) {
        data[counter - 1].ISIN = _ISIN;
    }

    function fulfillHoldingName(bytes32 _requestID, string memory _holdingName) external
        recordChainlinkFulfillment(_requestID) {
            data[counter - 1].holdingName = _holdingName;
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