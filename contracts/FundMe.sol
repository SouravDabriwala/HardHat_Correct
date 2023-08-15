// SPDX-License-Identifier: MIT
pragma solidity >0.8.0 <0.9.0;

//Get funds from users
//WIthdraw Funds
//Set a min finding value in USD

import "./PriceConverter.sol";

error FundMe__NotOwner();

/**
 * @title A contract for crowd funding
 * @author Sourav Dabriwala
 * @notice This contract is to demo a sample funding contract
 * @dev This implements price feeds as our library
 */

contract FundMe {
    using PriceConverter for uint256;

    uint public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint) public addressToAmountFunded;
    address public immutable i_owner;
    AggregatorV3Interface public priceFeed;

    modifier onlyOwner() {
        //   require(msg.sender == i_owner,"Sender is not Owner!");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();
    }

    //msg.sender = whatever address the function is calling

    //msg.value has 18 decimal places(as it is in terms of WEI)
    //msg.value is uint256
    /**
     * @notice This function funds the contract
     * @dev THis implements price feeds as our library
     *
     */
    function fund() public payable {
        require(
            msg.value.getConversionRate(priceFeed) >= MINIMUM_USD,
            "Didn't send enough"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

     function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getAccountBalance(address account) external view returns (uint256){
        return account.balance;
    }

    function withdraw() public payable onlyOwner {
        //Make the balance 0
        for (uint i = 0; i < funders.length; i++) {
            addressToAmountFunded[funders[i]] = 0;
        }

        //Reset the funders array
        funders = new address[](0); //completely blank new Array

        //Actually withdraw the funds

        //     //1.transfer
        //              // payable(msg.sender) -> payable address
        //    payable(msg.sender).transfer(address(this).balance);

        //     //2.send
        //     bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //     require(sendSuccess,"Send Failed");

        //3.call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");

        //receive function
    }

    function cheaperWithdraw() public payable onlyOwner{
         address[] memory localfunders = funders;
         for(uint256 i =0;i<localfunders.length;i++){
            addressToAmountFunded[localfunders[i]] =0;
         }

         funders = new address[](0);
         (bool success,) = i_owner.call{value:address(this).balance}("");
         require(success);
    }

}
