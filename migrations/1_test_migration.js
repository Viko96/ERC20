// Deployment using Truffle suite

// Contracts used by deployed contracts no need to deploy
// let owned     = artifacts.require('Owned');

// Interfaces are not deployable
// let ierc      = artifacts.require('IERC20');

// Testing Deployment
var erc = artifacts.require("ERC20");

module.exports = function(deployer) {
    let initialAddress = web3.eth.accounts.create();

    let nam = "crux",
        sym = "+",
        iac = initialAddress.address,
        bal = 5000;

    deployer.deploy(erc, nam, sym, iac, bal);
}