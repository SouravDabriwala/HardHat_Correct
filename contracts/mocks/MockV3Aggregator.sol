// SPDX-License-Identifier : MIT

pragma solidity ^0.6.0;


import "@chainlink/contracts/src/v0.6/tests/MockV3Aggregator.sol";


//MockV3Aggregator is returning a price feed address for the local host or hardhat env.
//using that we can deploy the fundme smart contract when we are working locally.