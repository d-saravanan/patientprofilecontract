pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";
import "../contracts/PatientProfileContract.sol";

contract PatientProfileContractTest {

    // Patient profile related Constant declarations
    uint constant patientId = 1;
    string constant patientName ="Saran";
    string constant patientKey ="0x1455388907668930980";

    // Patient Document related declarations > Blood Test Report
    uint constant document1Id = 100;
    string constant document1Name = "Blood Test Report";
    string constant document1Type = "Report";
    string constant document1AccessKey = "0x4577927917038";
    
    // Patient Document related declarations > ECG
    uint constant document2Id = 100;
    string constant document2Name = "Echo Cardiogram Report";
    string constant document2Type = "Report";
    string constant document2AccessKey = "0x45776590917038";

    // Doctor Details
    uint constant doctor1Id = 200;
    uint constant doctor2Id = 200;
    string constant doctor1Name = "John.Smith";
    string constant doctor2Name = "Stephen.Williams";

    //Test 1
    function testSetPatientData() public {
        PatientProfileContract f = new PatientProfileContract();
        bool patientAddStatus = f.setPatientData(patientId, patientName, patientKey);
        Assert.equal(patientAddStatus, true, "Add Patient data should succeed");
    }

    //Test 2
    function testSetPartialPatientDataShouldFail() public {
        PatientProfileContract f = new PatientProfileContract();
        bool patientAddStatus = f.setPatientData(patientId, patientName, "");
        Assert.equal(patientAddStatus, false, "Partially added Patient data should fail");
    }

    //Test 3
    function testSetPartialPatientDataShouldReturnIsConfiguredAsFalse() public {
        PatientProfileContract f = new PatientProfileContract();
        bool patientAddStatus = f.setPatientData(patientId, patientName, "");
        Assert.equal(patientAddStatus, false, "Partially added Patient data should fail");

        bool isConfigured = f.isPatientBasicDataConfigured(patientId);
        Assert.equal(isConfigured, false, "Patient Configuration should fail due to partial data");
    }
    
    //Test 4
    function testPatientConfigurationAfterAddingBasicData() public { 
        PatientProfileContract f = new PatientProfileContract();
        var status = f.setPatientData(patientId, patientName, patientKey);
        Assert.equal(status,true,"Adding the patient data should succeed");

        var configurationStatus = f.isPatientBasicDataConfigured(patientId);
        Assert.equal(configurationStatus, true, "All the basic data is configured, hence will pass");
    }

    //Test 5
    function testPatientGetData() public {
        PatientProfileContract f = new PatientProfileContract();
        var status = f.setPatientData(patientId, patientName, patientKey);
        Assert.equal(status, true, "Adding the patient data should succeed");

        var (id, name) = f.getPatientData(1);
        Assert.equal(id, patientId, "Patient id should be equal to 1");
        Assert.equal(name, patientName,"Patient id should be equal to 1");
    }

    //Test 6
    function testGetPatientDataShouldReturnInvalidDataForNonExistentPatient() public {
        PatientProfileContract f = new PatientProfileContract();
        var (id, name) = f.getPatientData(2);
        Assert.equal(id, 0, "As patient id is invalid, return value for id will be 0");
        Assert.equal(name, "", "As patient id is invalid, return value for name will be empty");
    }

    function setTestPatientData(PatientProfileContract f) private {
        var status = f.setPatientData(patientId, patientName, patientKey);
        Assert.equal(status, true, "Adding the patient data should succeed, provided the basic properties are all present");
    }

    //Test 7
    function testAddPatientDocuments() public {
        // uint patientId, uint documentId, string documentName, string documentType, string accessKey
        PatientProfileContract f = new PatientProfileContract();
        setTestPatientData(f);
        bool documentAdditionStatus = f.addPatientDocuments(patientId, document1Id, document1Name, document1Type, document1AccessKey);
        Assert.equal(documentAdditionStatus, true, "document add should return true, provided all the basic details are present");
    }

    //Test 8
    function testAddDoctorData() public {
        PatientProfileContract f = new PatientProfileContract();
        var doctorAddStatus = f.addDoctor(doctor1Id, doctor1Name);
        Assert.equal(doctorAddStatus, true, "Adding a new doctor should pass");
    }

    //Test 9
    function testDoctorAccessToDocument() public {
        PatientProfileContract f = new PatientProfileContract();
        //initialize the patient base data
        setTestPatientData(f);
        //add a document for the patient
        bool documentAdditionStatus = f.addPatientDocuments(patientId, document1Id, document1Name, document1Type, document1AccessKey);
        Assert.equal(documentAdditionStatus, true, "document add should return true, provided all the basic details are present");
        //Assign the patient data to the doctor
        var doctorAssignmentOfDocuments = f.setDocumentAccess(patientId, doctor1Id, document1Id);
        Assert.equal(doctorAssignmentOfDocuments, document1AccessKey, "The accesskey for the document1 should be returned");
    }
}

