const { ethers, getNamedAccounts, network } = require("hardhat")
// const { developmentChains } = require("../../helper-hardhat-config")
const { assert } = require("chai")

//Staging test are only gonna run on test network

// developmentChains.includes(network.name) ? describe.skip :
describe("FundMe", function () {
    let fundMe
    let deployer
    const sendValue = ethers.parseEther("0.1")
    beforeEach(async function () {
        deployer = (await getNamedAccounts()).deployer
        fundMe = await ethers.getContract("FundMe", deployer)
    })

    it("allows people to fund and withdraw", async function () {
        await fundMe.fund({ value: sendValue })
        await fundMe.withdraw()
        const endingContractBalance = await fundMe.getBalance()
        assert.equal(endingContractBalance.toString(), "0")
    })
})
