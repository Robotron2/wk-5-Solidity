// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SchoolToken {
    // ================= ERC20 =================

    string public name = "SchoolToken";
    string public symbol = "SCH";
    uint8 public decimals = 18;

    uint256 public totalSupply;
    address public owner;

    uint256 public tokenPrice = 0.001 ether; // 1 token = 0.001 ETH

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(uint256 _initialSupply) {
        owner = msg.sender;

        uint256 supply = _initialSupply * (10 ** decimals);
        totalSupply = supply;
        balanceOf[address(this)] = supply; // Contract holds initial supply

        emit Transfer(address(0), address(this), supply);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(allowance[from][msg.sender] >= amount, "No allowance");

        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }
}
