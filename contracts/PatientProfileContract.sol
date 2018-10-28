pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

contract PatientProfileContract {
    function sum(uint input1, uint input2) public returns (uint) {
        return input1 + input2;
    }

    struct patient {
        uint id;
        string fullName;
        string key; //The unique key for the user
        PatientDocuments[] Documents;
        DocumentAccess[] DocumentAccessRights;
        mapping(uint => string[]) DoctorAccess;
    }

    struct PatientDocuments {
        uint PatientId;
        uint DocumentId;
        string DocumentType;
        string DocumentName;
        string DocumentKey;
    }

    struct DocumentAccess {
        uint PatientId;
        uint DoctorId;
        uint DocumentId;
        string AccessKey; // use this as permision than an access key
    }

    mapping(uint => patient) public patients;
    mapping(uint => bool) public IsPatientConfigured;

    function setPatientData(uint id,string fullName,string key) public returns(bool) {

        bytes memory emptyStringTest_FullName = bytes(fullName);
        bytes memory emptyStringTest_Key = bytes(key);
        if(id == 0 || emptyStringTest_FullName.length == 0 || emptyStringTest_Key.length == 0) {
            IsPatientConfigured[id] = false;
            return false;
        }

        patient profile;
        profile.id = id;
        profile.fullName = fullName;
        profile.key = key;
        patients[id] = profile;
        IsPatientConfigured[id] = true; //once basic details are set, say configured as true.
        return true;
    }

    function isPatientBasicDataConfigured(uint patientId) public returns (bool) {
        return IsPatientConfigured[patientId];
    }

    function getPatientData(uint patientId) public returns (uint id, string name){
        patient memory data = patients[patientId];
        return (data.id, data.fullName);
    }

    function addPatientDocuments(uint patientId, uint documentId, string documentName, string documentType, string accessKey) returns (bool) {
        if(IsPatientConfigured[patientId] == false){
            return false;
        }
        patient profile = patients[patientId];
        PatientDocuments patientDocs;
        patientDocs.PatientId = patientId;
        patientDocs.DocumentId = documentId;
        patientDocs.DocumentName = documentName;
        patientDocs.DocumentType = documentType;
        patientDocs.DocumentKey = accessKey;
        profile.Documents.push(patientDocs);
        return true;
    }

    function setDocumentAccess(uint patientId, uint doctorId, uint documentId, string accessKey) returns (bool) {
        if(IsPatientConfigured[patientId] == false){
            return false;
        }
        patient profile = patients[patientId];
        DocumentAccess docRights;
        docRights.PatientId = patientId;
        docRights.DoctorId = doctorId;
        docRights.DocumentId = documentId;
        docRights.AccessKey = accessKey;
        profile.DocumentAccessRights.push(docRights);
        return true;
    }

    function getPatient(uint patientId, uint doctorId) public returns (string[]) {
        patient p;
        p.id = 1;
        p.fullName="Saran";
        p.DoctorAccess[doctorId].push("Doctor1Key");
        return p.DoctorAccess[doctorId];
    }
}