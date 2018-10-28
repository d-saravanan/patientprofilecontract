pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

contract PatientProfileContract {

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
    mapping(uint => string) public Doctors;

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

    function addPatientDocuments(uint patientId, uint documentId, string documentName, string documentType, string accessKey) public returns (bool) {
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

    function addDoctor(uint doctorId, string doctorName) public returns (bool) {
        Doctors[doctorId] = doctorName;
        return true;
    }

    string constant emtpyString = "";
    uint constant maxDocumentLimit = 9999999999;

    function setDocumentAccess(uint patientId, uint doctorId, uint documentId) public returns (string) {
        //Step0: if the patient data is not yet configured, do not proceed
        if(IsPatientConfigured[patientId] == false){
            return "Patient not yet configured";
        }   
        //Step1: get the patient profile
        patient profile = patients[patientId];        
        uint documentFound = maxDocumentLimit;

        //Step2: get the list of documents, and validate the documentid against the patient's documents
        for(uint i = 0; i < profile.Documents.length; i++) {
            if(documentId == profile.Documents[i].DocumentId){
                documentFound = i;
                break;
            }
        }

        if(documentFound == maxDocumentLimit){
            return "document id is invalid"; // invalid document id
        }

        var doctorName = Doctors[doctorId];

        bytes memory emptyStringTest_doctorName = bytes(doctorName);

        if(emptyStringTest_doctorName.length < 1){
            return "invalid doctorId"; // invalid doctorId
        }

        DocumentAccess docRights;

        //Step3: get the document accesskey and send in the response after adding the access details to the DocumentAccessRights
        docRights.PatientId = patientId;
        docRights.DoctorId = doctorId;
        docRights.DocumentId = documentId;
        docRights.AccessKey = profile.Documents[documentFound].DocumentKey;
        profile.DocumentAccessRights.push(docRights);
        return docRights.AccessKey;
    }
}