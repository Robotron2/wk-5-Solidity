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

        balanceOf[msg.sender] = balanceOf[msg.sender] - amount;
        balanceOf[to] = balanceOf[to] + amount;

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

        allowance[from][msg.sender] = allowance[from][msg.sender] - amount;
        balanceOf[from] = balanceOf[from] - amount;
        balanceOf[to] = balanceOf[to] + amount;

        emit Transfer(from, to, amount);
        return true;
    }

    function buySCHToken() external payable {
        require(msg.value > 0, "Send ETH");

        uint256 amountToBuy = (msg.value * (10 ** decimals)) / tokenPrice;

        require(balanceOf[address(this)] >= amountToBuy, "Not enough supply");

        balanceOf[address(this)] = balanceOf[address(this)] - amountToBuy;

        balanceOf[msg.sender] = balanceOf[msg.sender] - amountToBuy;

        emit Transfer(address(this), msg.sender, amountToBuy);
    }

    function sellSCHToken(uint256 tokenAmount) external {
        require(tokenAmount > 0, "Zero amount");

        require(balanceOf[msg.sender] >= tokenAmount, "Not enough token");

        uint256 ethAmount = (tokenAmount * tokenPrice) / (10 ** decimals);

        require(address(this).balance >= ethAmount, "Not enough ETH in contract");

        balanceOf[msg.sender] = balanceOf[msg.sender] - tokenAmount;

        balanceOf[address(this)] = balanceOf[address(this)] + tokenAmount;

        emit Transfer(msg.sender, address(this), tokenAmount);

        (bool success,) = payable(msg.sender).call{value: ethAmount}("");
    }

    // ================= SCHOOL MANAGEMENT =================

    struct Student {
        uint256 id;
        string name;
        uint256 level;
        uint256 feePaid;
        bool isPaid;
        uint256 paymentTimestamp;
    }

    struct Staff {
        uint256 id;
        string name;
        address staffAddress;
        uint256 salaryPaid;
        uint256 paymentTimestamp;
    }

    uint256 public studentCount;
    uint256 public staffCount;

    mapping(uint256 => Student) public students;
    mapping(uint256 => Staff) public staffs;

    mapping(uint256 => uint256) public levelFee;

    function setLevelFee(uint256 level, uint256 fee) external onlyOwner {
        require(level >= 100 && level <= 400, "Invalid level");
        levelFee[level] = fee;
    }

    function registerStudent(string memory _name, uint256 _level) external {
        uint256 fee = levelFee[_level];
        require(fee > 0, "Fee not set");

        // Contract pulls fee from student
        transferFrom(msg.sender, owner, fee);

        studentCount++;

        students[studentCount] = Student({
            id: studentCount, name: _name, level: _level, feePaid: fee, isPaid: true, paymentTimestamp: block.timestamp
        });
    }

    function registerStaff(string memory _name, address _staffAddress) external onlyOwner {
        staffCount++;

        staffs[staffCount] =
            Staff({id: staffCount, name: _name, staffAddress: _staffAddress, salaryPaid: 0, paymentTimestamp: 0});
    }

    // Pay Staff with SCH TOKEN
    function payStaffToken(uint256 _staffId, uint256 amount) external onlyOwner {
        Staff storage staff = staffs[_staffId];

        require(balanceOf[owner] >= amount, "Not enough token");

        balanceOf[owner] = balanceOf[owner] - amount;
        balanceOf[staff.staffAddress] = balanceOf[staff.staffAddress] + amount;

        emit Transfer(owner, staff.staffAddress, amount);

        staff.salaryPaid = staff.salaryPaid + amount;
        staff.paymentTimestamp = block.timestamp;
    }
}
