// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.17;

contract Owned {
    address public owner;
    mapping(address => bool) admins;

    modifier onlyOwner() { require(msg.sender == owner, "Not an owner");  _; }

    modifier onlyAdmin() { require(admins[msg.sender] == true, "Not an admin"); _; }

    function transferOwnership (address newOwner)
    onlyOwner public {
        owner = newOwner;
    }

    function isAdmin(address account)
    onlyOwner public view returns(bool) {
        return admins[account];
    }

    function addAdmin(address account)
    onlyOwner public {
        require(account != address(0) && !admins[account]);
        admins[account] = true;
    }

    function removeAdmin(address account)
    onlyOwner public {
        require(account != address(0) && !admins[account]);
        admins[account] = false;
    }

}