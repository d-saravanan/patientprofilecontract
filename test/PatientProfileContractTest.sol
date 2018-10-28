pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";
import "../contracts/PatientProfileContract.sol";

contract PatientProfileContractTest {

    // Constant declarations
    uint constant patientId = 1;
    string constant patientName ="Saran";
    string constant patientKey ="0x1455388907668930980";

    function testSum() public {
        PatientProfileContract f = new PatientProfileContract();
        Assert.equal(f.sum(1,2),3," two plus one should be three");
    }

    function testSetPatientData() public {
        PatientProfileContract f = new PatientProfileContract();
        bool patientAddStatus = f.setPatientData(patientId, patientName, patientKey);
        Assert.equal(patientAddStatus, true, "Add Patient data should succeed");
    }

    function testSetPartialPatientDataShouldFail() public {
        PatientProfileContract f = new PatientProfileContract();
        bool patientAddStatus = f.setPatientData(patientId, patientName, "");
        Assert.equal(patientAddStatus, false, "Partially added Patient data should fail");
    }

    function testSetPartialPatientDataShouldReturnIsConfiguredAsFalse() public {
        PatientProfileContract f = new PatientProfileContract();
        bool patientAddStatus = f.setPatientData(patientId, patientName, "");
        Assert.equal(patientAddStatus, false, "Partially added Patient data should fail");

        bool isConfigured = f.isPatientBasicDataConfigured(patientId);
        Assert.equal(isConfigured, false, "Patient Configuration should fail due to partial data");

    }

    function testPatientConfigurationAfterAddingBasicData() public { 
        PatientProfileContract f = new PatientProfileContract();
        var status = f.setPatientData(patientId, patientName, patientKey);
        Assert.equal(status,true,"Adding the patient data should succeed");

        var configurationStatus = f.isPatientBasicDataConfigured(patientId);
        Assert.equal(configurationStatus, true, "All the basic data is configured, hence will pass");
    }

    function testPatientGetData() public {
        PatientProfileContract f = new PatientProfileContract();
        var status = f.setPatientData(patientId, patientName, patientKey);
        Assert.equal(status, true, "Adding the patient data should succeed");

        var (id, name) = f.getPatientData(1);
        Assert.equal(id, patientId, "Patient id should be equal to 1");
        Assert.equal(name, patientName,"Patient id should be equal to 1");
    }

    function testGetPatientDataShouldReturnInvalidDataForNonExistentPatient() public {
        PatientProfileContract f = new PatientProfileContract();
        var (id, name) = f.getPatientData(2);
        Assert.equal(id, 0, "As patient id is invalid, return value for id will be 0");
        Assert.equal(name, "", "As patient id is invalid, return value for name will be empty");
    }
}

