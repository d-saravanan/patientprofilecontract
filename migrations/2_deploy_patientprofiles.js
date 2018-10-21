var PatientProfile = artifacts.require("./PatientProfile.sol");

module.exports = function(deployer) {
  deployer.deploy(PatientProfile);
};
