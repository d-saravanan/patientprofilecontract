pragma solidity ^0.4.17;
pragma experimental ABIEncoderV2;

contract PatientProfile {

    struct Patient {
        uint Id;
        string Address;
        string FullName;
    }

    struct PatientDoctors {
        uint PatientId;
        uint[] DoctorIds;
    }

    struct PatientDocuments { 
        uint PatientId;
        mapping(uint => string) DocumentMapping;
    }

    Patient[] public patients;
    uint index=0;

    function getPatient(uint patientId) public returns(Patient) {
        patients.push(Patient(patientId,"0x123123123121231","Saran"));
        index = index + 1;
        return patients[index-1];
    }
}