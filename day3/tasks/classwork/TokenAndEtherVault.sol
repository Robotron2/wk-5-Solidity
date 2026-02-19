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

contract Robotron20 is IERC20 {
    uint256 public totalSupply; //total coin available mint = +ve, burn + burn

    address public owner;
    // ERC-20
    mapping(address _owner => uint256 balance) public balanceOf;
    mapping(address _owner => mapping(address _spender => uint256 _amount)) allowance;
    // Vault
    mapping(address => uint256) public etherBalance;
    mapping(address => mapping(address => uint256)) public tokenBalance;

    string public name = "Robotron";
    string public symbol = "RBNNT";
    uint8 public decimal = 18;

    event EtherDeposit(address indexed recipient, uint256 indexed _amount);
    event TokenDeposit(address indexed recipient, uint256 indexed _amount);

    event EtherWithdrawal(address indexed recipient, uint256 indexed _amount);
    event TokenWithdrawal(address indexed recipient, uint256 indexed _amount);

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

    // Store Ether
    function depositEther() external payable {
        require(msg.value > 0, "Cannot deposit zero ether");

        etherBalance[msg.sender] = etherBalance[msg.sender] + msg.value;

        emit EtherDeposit(msg.sender, msg.value);
    }

    // Withdraw Ether
    function withdrawEther(uint256 _amount) external {
        require(etherBalance[msg.sender] >= _amount, "Insufficient Ether");

        etherBalance[msg.sender] = etherBalance[msg.sender] - _amount;

        (bool success,) = payable(msg.sender).call{value: _amount}("");

        require(success, "Withdrawal unsuccessful");

        emit EtherWithdrawal(msg.sender, _amount);
    }

    // Store ERC20 Token
    function depositToken(address token, uint256 _amount) external {
        IERC20(token).transferFrom(msg.sender, address(this), _amount);

        tokenBalance[msg.sender][token] = tokenBalance[msg.sender][token] + _amount;

        emit TokenDeposit(msg.sender, _amount);
    }

    // Withdraw ERC20 Token
    function withdrawToken(address token, uint256 _amount) external {
        require(tokenBalance[msg.sender][token] >= _amount, "Insufficient Token");
        tokenBalance[msg.sender][token] = tokenBalance[msg.sender][token] - _amount;
        IERC20(token).transfer(msg.sender, _amount);
        emit TokenWithdrawal(msg.sender, _amount);
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
