var Election = artifacts.require("./Election.sol");

module.exports = function(deployer) {
  deployer.deploy(Election, ["Candidate 1","Candidate 2"]);
};
