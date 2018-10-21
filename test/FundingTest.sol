pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";
import "../contracts/Funding.sol";

contract FundingTest {

    function testSum() public {
        Funding  f= new Funding();
        Assert.equal(f.sum(1,2),3," two plus one should be three");
    }

    function test_getPatient() public {
        Funding f = new Funding();
        string[] doctorKeys;
        doctorKeys.push("Doctor1Key");

        for (uint i=0; i<doctorKeys.length; i++) {
            Assert.equal(f.getPatient(1,1)[i],doctorKeys[i],"The doctor key mapping should be a valid one");
        }
    }
}

