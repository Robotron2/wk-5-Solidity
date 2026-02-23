// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "day4/interfaces/IERC20.sol";

contract SchoolManagement {
    address public owner;
    uint256 tokenPrice;

    IERC20 public SCHTOKEN;

    constructor(address _tokenAddress) {
        SCHTOKEN = IERC20(_tokenAddress);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    struct Student {
        string name;
        address studentAddress;
        uint32 level;
        bool hasPaid;
        uint256 feePaid;
        uint256 paymentTimestamp;
    }

    struct Staff {
        string name;
        address studentAddress;
        uint256 salaryPaid;
        uint256 paymentTimestamp;
    }

    // enum TradeType {
    //     buy,
    //     sell
    // }
    // TradeType tradeType;

    // mappings
    mapping(address _studentAddress => Student) students;
    mapping(address _staffAddress => Staff) staffs;

    //arrays
    Student[] public allStudents;
    Staff[] public allStaffs;

    // Converters
    function getEthSCHConversion(uint256 _ethSent) public view returns (uint256) {
        uint256 amountReturned = (_ethSent * 10e18) / tokenPrice;
        return amountReturned;
    }

    function getSCHEthConversion(uint256 _schAmount) public view returns (uint256) {
        uint256 amountReturned = (_schAmount * tokenPrice) / 10e18;
        return amountReturned;
    }

    // function buySCHToken() external payable {
    //     require(msg.value > 0, "Send ETH");

    //     uint256 amountToBuy = getEthSCHConversion(msg.value);

    //     require(SCHTOKEN.balanceOf(address(this)) >= amountToBuy, "Not enough supply");

    //     SCHTOKEN.balanceOf(address(this)) = SCHTOKEN.balanceOf(address(this)) - amountToBuy;

    //     SCHTOKEN.balanceOf(msg.sender) = SCHTOKEN.balanceOf(msg.sender) + amountToBuy;

    //     emit SCHTOKEN.Transfer(address(this), msg.sender, amountToBuy);
    // }

    function buySCHToken() external payable {
        require(msg.value > 0, "Send ETH");

        uint256 amountToBuy = getEthSCHConversion(msg.value);

        require(SCHTOKEN.balanceOf(address(this)) >= amountToBuy, "Not enough supply");

        bool success = SCHTOKEN.transfer(msg.sender, amountToBuy);

        require(success, "Transfer failed");
    }

    
    

    function sellSCHToken(uint256 schAmount) external {
        uint256 etherToReceive = getSCHEthConversion(schAmount);

        //SCHTOKEN.balanceOf(msg.sender)
        // (bool success,) = payable(address(this)).call{value: etherToReceive}("");//send eth to address this.
        (bool success,) = payable(address(this)).call{value: etherToReceive}(""); //send eth to address this.
        require(success, "");
    }

    // function sellSCHToken(uint256 tokenAmount) external {
    //     require(tokenAmount > 0, "Zero amount");

    //     require(balanceOf[msg.sender] >= tokenAmount, "Not enough token");

    //     uint256 ethAmount = (tokenAmount * tokenPrice) / (10 ** decimals);

    //     require(address(this).balance >= ethAmount, "Not enough ETH in contract");

    //     balanceOf[msg.sender] = balanceOf[msg.sender] - tokenAmount;

    //     balanceOf[address(this)] = balanceOf[address(this)] + tokenAmount;

    //     emit Transfer(msg.sender, address(this), tokenAmount);

    //     (bool success,) = payable(msg.sender).call{value: ethAmount}("");
    // }

    // ================= SCHOOL MANAGEMENT =================

    // ================= GETTER FUNCTIONS =================
    // function getStudentById(uint256 _studentId) public view returns (Student memory) {
    //     return students[_studentId];
    // }

    // function getAllStudents() public view returns (Student[] memory) {
    //     return allStudents;
    // }

    // function getStaffById(uint256 _staffId) public view returns (Staff memory) {
    //     return staffs[_staffId];
    // }

    // function getAllStaffs() public view returns (Staff[] memory) {
    //     return allStaffs;
    // }

    // ================= FALLBACK FUNCTIONS =================
    receive() external payable {}

    fallback() external payable {}
}
