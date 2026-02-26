// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract PropertyManagement is AccessControl, ReentrancyGuard {
    // ============ ERRORS ============
    error PropertyManagement__NotPropertyOwner();
    error PropertyManagement__NotValidPrice();
    error PropertyManagement__NotValidProperty();
    error PropertyManagement__NotValidBuyer();
    error PropertyManagement__NotForsale();

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    IERC20 public immutable robotronToken;

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

    mapping(uint256 => Property) private properties;

    event PropertyCreated(uint256 indexed id, string name, uint256 price);
    event PropertyRemoved(uint256 indexed id);
    event PropertyPurchased(uint256 indexed id, address buyer);

    constructor(address _tokenAddress) {
        robotronToken = IERC20(_tokenAddress);

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MANAGER_ROLE, msg.sender);
    }

    // ============================
    // MODIFIER
    // ============================

    modifier onlyPropertyOwner(uint256 _propertyId) {
        if (!properties[_propertyId].exists) {
            revert PropertyManagement__NotValidProperty();
        }

        if (properties[_propertyId].propertyOwner != msg.sender) {
            revert PropertyManagement__NotPropertyOwner();
        }

        _;
    }

    // ============================
    // CREATE PROPERTY
    // ============================

    function createProperty(string memory _name, string memory _location, string memory _description, uint256 _price)
        external
        onlyRole(MANAGER_ROLE)
    {
        if (_price == 0) {
            revert PropertyManagement__NotValidPrice();
        }

        propertyCounter++;

        properties[propertyCounter] = Property({
            id: propertyCounter,
            name: _name,
            location: _location,
            description: _description,
            price: _price,
            propertyOwner: msg.sender,
            isForSale: true,
            exists: true
        });

        emit PropertyCreated(propertyCounter, _name, _price);
    }

    // ============================
    // REMOVE PROPERTY
    // ============================

    function removeProperty(uint256 _propertyId) external onlyPropertyOwner(_propertyId) {
        delete properties[_propertyId];

        emit PropertyRemoved(_propertyId);
    }

    // ============================
    // BUY PROPERTY
    // ============================

    function buyProperty(uint256 _propertyId) external nonReentrant {
        Property storage property = properties[_propertyId];

        if (!property.exists) {
            revert PropertyManagement__NotValidProperty();
        }

        if (!property.isForSale) {
            revert PropertyManagement__NotForsale();
        }

        if (property.propertyOwner == msg.sender) {
            revert PropertyManagement__NotValidBuyer();
        }

        uint256 price = property.price;
        address seller = property.propertyOwner;

        bool success = robotronToken.transferFrom(msg.sender, seller, price);

        require(success, "Payment failed");

        property.propertyOwner = msg.sender;
        property.isForSale = false;

        emit PropertyPurchased(_propertyId, msg.sender);
    }

    // ============================
    // SET PROPERTY FOR SALE
    // ============================

    function setForSale(uint256 _propertyId, uint256 _newPrice) external onlyPropertyOwner(_propertyId) {
        if (_newPrice == 0) {
            revert PropertyManagement__NotValidPrice();
        }

        Property storage property = properties[_propertyId];

        property.price = _newPrice;
        property.isForSale = true;
    }

    // ============================
    // GETTERS
    // ============================

    function getProperty(uint256 _propertyId) external view returns (Property memory) {
        if (!properties[_propertyId].exists) {
            revert PropertyManagement__NotValidProperty();
        }

        return properties[_propertyId];
    }

    function getAllProperties() external view returns (Property[] memory) {
        uint256 total = propertyCounter;
        uint256 validCount;

        // First pass: count existing properties
        for (uint256 i = 1; i <= total; i++) {
            if (properties[i].exists) {
                validCount++;
            }
        }

        // Allocate exact memory size
        Property[] memory allProperties = new Property[](validCount);

        uint256 index;

        // Second pass: populate array
        for (uint256 i = 1; i <= total; i++) {
            if (properties[i].exists) {
                allProperties[index] = properties[i];
                index++;
            }
        }

        return allProperties;
    }

    function getPropertiesForSale() external view returns (Property[] memory) {
        uint256 total = propertyCounter;
        uint256 saleCount;

        // Count properties for sale
        for (uint256 i = 1; i <= total; i++) {
            if (properties[i].exists && properties[i].isForSale) {
                saleCount++;
            }
        }

        Property[] memory propertiesForSale = new Property[](saleCount);

        uint256 index;

        for (uint256 i = 1; i <= total; i++) {
            if (properties[i].exists && properties[i].isForSale) {
                propertiesForSale[index] = properties[i];
                index++;
            }
        }

        return propertiesForSale;
    }
}
