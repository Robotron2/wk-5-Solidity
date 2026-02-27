// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {OurModifier} from "./mod.sol";

contract ModFactory {
    address[] childInstances; //store all child instances.abi//
    //keep track of those child instances -> using their owner
    mapping(address _childAddress => address _childAddressOwner) public childContractAddressOwners;

    function createChild(address _owner) external {
        OurModifier ourModifier = new OurModifier(_owner);
        // pussh those child instances into an array.
        childInstances.push(address(ourModifier));
        childContractAddressOwners[address(ourModifier)] = msg.sender;
    }
}
