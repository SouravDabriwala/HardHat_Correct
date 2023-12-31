const { network } = require("hardhat")
const {
    developmentChains,
    INITIAL_ANSWER,
    DECIMALS,
} = require("../helper-hardhat-config")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    if (developmentChains.includes(network.name)) {
        log("Local network detected! Deploying mocks...")
        await deploy("MockV3Aggregator", {
            from: deployer,
            contract: "MockV3Aggregator",
            log: true,
            args: [DECIMALS, INITIAL_ANSWER],
        })
        log("Mocks deployed.....")
        log("------------------------------")
    }
}

module.exports.tags = ["all", "mocks"]
