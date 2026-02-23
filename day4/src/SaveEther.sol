// SPDX-License-Identifier:MIT

pragma solidity ^0.8.30;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 _amount) external returns (bool);

    // function allowance() external view returns (uint256);

    function approve(address spender, uint256 _amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 _amount) external returns (bool);

    event Transfer(address indexed from, address to, uint256 indexed _amount);

    event Approval(address indexed owner, address spender, uint256 indexed _amount);
}

abstract contract Robotron20 is IERC20 {
    uint256 public totalSupply; //total coin available mint = +ve, burn + burn

    address public owner;

    // {address1 : balance1, address2 : balance2}
    // const balanceOf = {
    //     address: balance,
    //     address: balance,
    //     address: balance,
    //     address: balance,
    //     address: balance,
    //     address: balance,
    //     address: balance,
    // }
    // mapping(address  => uint256 ) public balanceOf;
    mapping(address _owner => uint256 balance) public balanceOf;

    // {addressOwner:{addressSpender : balance}}

    // const allowance = {
    //     addressOwner:{
    //         addressSpender: balance
    //     }
    // }
    // mapping(address => mapping(address => uint256)) allowance;
    mapping(address _owner => mapping(address _spender => uint256 _amount)) allowance;

    string public name = "Robotron";
    string public symbol = "RBNNT";
    uint8 public decimal = 18;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(uint256 _initialSupply) {
        owner = msg.sender;

        uint256 supply = _initialSupply * (10 ** decimal);
        balanceOf[msg.sender] = supply;
        totalSupply = supply;
        emit Transfer(address(0), msg.sender, supply);
    }

    function transfer(address recipient, uint256 _amount) external returns (bool) {
        require(balanceOf[msg.sender] >= _amount, "Insufficient funds");

        balanceOf[msg.sender] = balanceOf[msg.sender] - _amount;

        require(recipient != address(0), "Address zero detected");

        balanceOf[recipient] = balanceOf[recipient] + _amount;

        emit Transfer(msg.sender, recipient, _amount);

        return true;
    }

    function approve(address spender, uint256 _amount) external returns (bool) {
        allowance[msg.sender][spender] = _amount;

        emit Approval(msg.sender, spender, _amount);

        return true;
    }

    // const allowance = {
    //     addressOwner:{
    //         addressSpender: balance
    //     }
    // }

    function transferFrom(address sender, address recipient, uint256 _amount) external returns (bool) {
        require(allowance[sender][msg.sender] > 0, "Zero allowance");

        require(allowance[sender][msg.sender] >= _amount, "Insufficient spender funds");

        require(balanceOf[sender] >= _amount, "Insufficient owner funds");

        allowance[sender][msg.sender] = allowance[sender][msg.sender] - _amount;

        balanceOf[sender] = balanceOf[sender] - _amount;

        balanceOf[recipient] = balanceOf[recipient] + _amount;

        emit Transfer(sender, recipient, _amount);

        return true;
    }

    function mint(uint256 _amount) external onlyOwner {
        balanceOf[msg.sender] = balanceOf[msg.sender] + _amount;

        totalSupply = totalSupply + _amount;

        emit Transfer(address(0), msg.sender, _amount);
    }

    function burn(uint256 _amount) external {
        balanceOf[msg.sender] = balanceOf[msg.sender] - _amount;

        totalSupply = totalSupply - _amount;

        emit Transfer(msg.sender, address(0), _amount);
    }
}
