// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import './Owned.sol';

contract Pausable is Owned {
    event PauseEvt(address account);
    event UnpauseEvt(address account);

    bool private paused;

    constructor() {
        paused = false;
    }

    modifier whenPaused { require(paused); _; }

    modifier whenNotPaused { require(!paused); _; }

    function pause() onlyAdmin whenNotPaused public {
        paused = true; emit PauseEvt(msg.sender);
    }

    function unpause() onlyAdmin whenPaused public {
        paused = false; emit UnpauseEvt(msg.sender);
    }
} 