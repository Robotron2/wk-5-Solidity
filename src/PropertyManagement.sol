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
    error PropertyManagement__NotValidProperty();
    error PropertyManagement__NotForsale();
    error PropertyManagement__NotValidBuyer();

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

    // ============================
    // REMOVE PROPERTY
    // ============================
    function removeProperty(uint256 _propertyId) external isPropertyOwner(_propertyId) {
        require(properties[_propertyId].exists, "Property does not exist");
        if (!properties[_propertyId].exists) {
            revert PropertyManagement__NotValidProperty();
        }

        delete properties[_propertyId];

        for (uint8 i; i < allProperties.length; i++) {
            if (allProperties[i].id == _id) {
                allProperties[i] = allProperties[allProperties.length - 1];
                allProperties.pop();
            }
        }

        emit PropertyRemoved(_propertyId);
    }

    // ============================
    // BUY PROPERTY
    // ============================
    function buyProperty(uint256 _propertyId) external nonReentrant {
        Property memory property = properties[_propertyId];

        require(property.exists, "Property does not exist");
        if (!property.exists) revert PropertyManagement__NotValidProperty();
        if (!property.isForSale) revert PropertyManagement__NotForsale();
        if (property.owner == msg.sender) revert PropertyManagement__NotForsale();

        uint256 price = property.price;
        address seller = property.owner;

        // Transfer tokens from buyer to seller - buyer should approve allowances.
        require(RobotronToken.transferFrom(msg.sender, seller, price), "Payment failed");

        property.owner = msg.sender;
        property.isForSale = false;

        emit PropertyPurchased(_propertyId, msg.sender);
    }

    // ============================
    // SET PROPERTY FOR SALE
    // ============================
    function setForSale(uint256 _propertyId, uint256 _newPrice) external {
        Property storage property = properties[_propertyId];

        require(property.exists, "Property does not exist");
        require(property.owner == msg.sender, "Not property owner");
        require(_newPrice > 0, "Invalid price");

        property.price = _newPrice;
        property.isForSale = true;
    }

    // ============================
    // GETTERS
    // ============================
    function getAllProperties() external view returns (Property[] memory) {
        Property[] memory allProperties = new Property[](propertyCounter);

        for (uint256 i = 1; i <= propertyCounter; i++) {
            allProperties[i - 1] = properties[i];
        }

        return allProperties;
    }

    function getPropertiesForSale() external view returns (Property[] memory) {
        Property[] memory allPropertiesForsale;

        for (uint256 i = 1; i <= propertyCounter; i++) {
            if (properties[i].isForSale) {
                allPropertiesForsale.push(properties[i]);
            }
        }

        return allPropertiesForsale;
    }
}

