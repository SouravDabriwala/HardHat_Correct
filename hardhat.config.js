const { version } = require("chai")
const { UnmanagedSubscriber } = require("ethers")

require("@nomicfoundation/hardhat-toolbox")
require("@nomiclabs/hardhat-solhint")
require("hardhat-deploy")
require("@nomiclabs/hardhat-ethers")
require("hardhat-gas-reporter")
require("dotenv").config()
// require('hardhat-deploy-ethers');
/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
    // solidity: "0.8.19",
    solidity: {
        compilers: [{ version: "0.8.8" }, { version: "0.6.6" }],
    },
    networks: {
        sepolia: {
            url: process.env.SEPOLIA_URL,
            accounts: [process.env.PRIVATE_KEY1, process.env.PRIVATE_KEY2],
            chainId: 11155111,
            blockConfirmations: 6,
        },
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
        user: {
            default: 1,
        },
    },
    etherscan: {
        apiKey: process.env.ETHERSCAN_API_KEY,
    },
    gasReporter: {
        enabled: false,
        outputFile: "gas-report.txt",
        noColors: true,
        currency: "USD",
        coinmarketcap: process.env.COINMARKET_API_KEY,
        token: "ETH",
    },
}
