// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract Test is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    uint256 private constant ORACLE_PAYMENT = (1 * LINK_DIVISIBILITY) / 10;
    string public Ticker;
    string public ISIN;

    constructor(address _linkAddress) {
        setChainlinkToken(_linkAddress);
    }

    function requestTicker
    (
        address _oracle,
        string memory _jobId,
        string memory _id
    ) public {
        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(_jobId),
            address(this),
            this.fulfillTicker.selector
        );

        req.add("id", _id);
        req.add("path", "data,Ticker");
        sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
    }

    function requestISIN
    (
        address _oracle,
        string memory _jobId,
        string memory _id
    ) public {
        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(_jobId),
            address(this),
            this.fulfillISIN.selector
        );

        req.add("id", _id);
        req.add("path", "data,ISIN");
        sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
    }

    function fulfillTicker
    (
        bytes32 _requestID,
        string memory _ticker
    ) public recordChainlinkFulfillment(_requestID)
    {
        Ticker = _ticker;
    }

    function fulfillISIN
    (
        bytes32 _requestID,
        string memory _ISIN
    ) public recordChainlinkFulfillment(_requestID)
    {
        ISIN = _ISIN;
    }

    function stringToBytes32(
        string memory source
    ) private pure returns (bytes32 result) {
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