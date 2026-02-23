// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);
    function balanceOf(address _account) external view returns (uint256);

    function transfer(address _recipient, uint256 _amount) external returns (bool);
    function transferFrom(address _sender, address _recipient, uint256 _amount) external returns (bool);

    function approve(address _spender, uint256 _amount) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
}

