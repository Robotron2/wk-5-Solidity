// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract PropertyManagement is AccessControl, ReentrancyGuard {
    // Errors
    error PropertyManagement__NotPropertyOwner();
    error PropertyManagement__NotContractOwner();
    error PropertyManagement__NotValidPrice();

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    IERC20 public RobotronToken;

    uint256 private propertyCounter;

    struct Property {
        uint256 id;
        string name;
        string location;
        string description;
        uint256 price;
        address propertyOwner;
        bool isForSale;
        bool exists;
    }

    event PropertyCreated(uint256 indexed id, string name, uint256 price);
    event PropertyRemoved(uint256 indexed id);
    event PropertyPurchased(uint256 indexed id, address buyer);

    //mapping
    mapping(uint256 => Property) properties;

    //Constructor
    constructor(address _tokenAddress) {
        RobotronToken = IERC20(_tokenAddress);

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MANAGER_ROLE, msg.sender);
    }

    // modifiers
    modifier isPropertyOwner(uint256 _propertyId) {
        Property memory property = properties[_propertyId];
        if (property.propertyOwner != msg.sender) {
            revert PropertyManagement__NotPropertyOwner();
        }
        _;
    }

    // ============================
    // CREATE PROPERTY
    // ============================
    function createProperty(string memory _name, string memory _location, string memory _description, uint256 _price)
        external
        isPropertyOwner
    {
        if (_price < 0) {
            revert PropertyManagement__NotValidPrice();
        }

        propertyCounter++;

        Property newProperty = Property({
            id: propertyCounter,
            name: _name,
            location: _location,
            description: _description,
            price: _price,
            owner: msg.sender,
            isForSale: true,
            exists: true
        });

        properties[propertyCounter] = newProperty;

        allProperties.push(newProperty);

        emit PropertyCreated(propertyCounter, _name, _price);
    }

    // remove property

    // Getters
}

