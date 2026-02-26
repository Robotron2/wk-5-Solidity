// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract OurModifier {
    error NOT_OWNER();
    string name;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner() {
        if (owner != msg.sender) {
            revert NOT_OWNER();
        }
        _;
    }

    function setName(string memory _name) external OnlyOwner {
        name = _name;
    }

    function getName() external view returns (string memory) {
        return name;
    }

    function getOwner() external view returns (address) {
        return owner;
    }
}
