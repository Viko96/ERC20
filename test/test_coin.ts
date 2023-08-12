// https://moxiesuite.github.io/docs/truffle/testing/writing-tests-in-javascript
// Reference ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

const Web3 = require('web3');

// Name has to match contract & its file's name
const ERC20 = artifacts.require("ERC20");

// contract has "describe" function since it uses the Mocha testing framework
// Same functionality as the RSpec fw from Ruby
// TODO: Set "provider" to dashboard or custom EVM server
contract("ERC20", (accounts) => {
    // accounts has web3.eth.getAccounts()'s functionality
    it("Can interact with deployed contract", async () => {
        // console.log(instance.name.call());
        let instance = await ERC20.deployed()
        let errm = "No matching names with the one deployed";
        let name = await instance.name.call();
        let symbol = await instance.symbol.call();
        let totalSupply = await instance.totalSupply.call();
        assert.equal(name, 'crux', errm);
        assert.equal(symbol, '+', errm);
        assert.equal(totalSupply, 5000, errm);
    });

    it("Transfer of ownership", async () => {
        let instance = await ERC20.deployed()
        let owner = await instance.owner.call();
        assert.isTrue(web3.utils.isHex(owner), "No address returned");
        let transop = await instance.transferOwnership.call(accounts[2]);
        assert.ok(transop, "The operation wasn't carried out");
        let newowner = await instance.owner.call();
        assert.notEqual(owner, newowner, "No transfer of ownership was done");
    });
})