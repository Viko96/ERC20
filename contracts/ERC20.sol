// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.17;

import './IERC20.sol';
import './Whitelist.sol';
import './Pausable.sol';

contract ERC20 is IERC20, Whitelist, Pausable {

    // TOKEN SUMMARY
    address public initialAccount;
    string public name;
    string public symbol;

    mapping (address => uint256) balance;
    mapping (address => mapping(address => uint256)) _allowance;
    uint256 internal _totalSupply;

    constructor(string memory _name, 
                string memory _symbol, 
                address _initialAccount, 
                uint256 initialBalance) 
                payable Whitelist() Pausable() {
                    // TODO: Refactor | Needed for addWhitelist
                    owner = msg.sender;
                    addAdmin(msg.sender);
                    
                    // initialAccount is address(0)
                    addWhitelist(initialAccount);

                    balance[initialAccount] = initialBalance;
                    _totalSupply = initialBalance;
                    initialAccount = _initialAccount;
                    name = _name;
                    symbol = _symbol;
                }

    modifier verifyTransaction(address to) {
        string memory mesg ='Tried a transaction with a NON-Whitelisted account';
        require(isWhitelist(to), mesg);
        _;
    }

    modifier notMe(address account) {
        require(account != address(0));
        _;
    }

    function totalSupply()
    public view returns(uint256) {
        return _totalSupply;
    } 

    function balanceOf(address tokenOwner)
    public view returns(uint256) {
        return balance[tokenOwner];
    }

    function transfer(address to, uint256 value)
    whenNotPaused notMe(to) verifyTransaction(to) public {
        // msg.sender is self in this case
        require(balance[msg.sender] > value);
        balance[msg.sender] -= value;
        balance[to] += value;
        emit Transfer(msg.sender, to, value);
    }

    function transferFrom(address from, address spender, uint256 value)
    whenNotPaused notMe(spender) verifyTransaction(spender) public {
        require(value <= balance[from]);
        balance[from] -= value;
        balance[spender] += value;
        _allowance[from][msg.sender] -= value;
        emit Transfer(from, spender, value);
    }

    function approve(address spender, uint256 amount)
    notMe(spender) public {
        _allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    function allowance(address owner, address spender)
    public view returns(uint256) {
        return _allowance[owner][spender];
    }

    function burn(uint256 amount) 
    whenNotPaused onlyAdmin public {
        require(balance[msg.sender] >= amount);
        balance[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Burn(msg.sender, amount);
    }

    function mint(address account, uint256 amount) 
    whenNotPaused onlyAdmin notMe(account) public {
        _totalSupply += amount;
        balance[account] += amount;
        emit Transfer(address(0), account, amount);
    }
}