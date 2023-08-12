// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.17;

import './Owned.sol';

contract Whitelist is Owned {
    mapping(address => bool) whitelist;

    function addWhitelist(address account)
    onlyAdmin public {
        string memory ermsg = "Whitelisted already";
        require(!whitelist[account], ermsg);
        whitelist[account] = true;
    }

    function isWhitelist(address account)
    public view returns(bool) {
        return whitelist[account];
    }

    function removeWhiteListed(address account) onlyAdmin public {
        require(account != address(0) && whitelist[account]);
        whitelist[account] = false;
    }
}