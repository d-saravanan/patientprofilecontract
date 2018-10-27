var PatientProfileContract = artifacts.require("./PatientProfileContract.sol");

module.exports = function(deployer) {
  deployer.deploy(PatientProfileContract);
};
