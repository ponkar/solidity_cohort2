pragma solidity ^0.7.0;

import "browser/tests/artifacts/General_Elections/Candidate.sol";

contract Voter {
    Candidate c1 = Candidate(0xb27A31f1b0AF2946B7F582768f03239b1eC07c2c);
    
    address payable voteraccess;
    
    struct voterDetail{
        string name;
        uint voterId;
        string adhaarId;
        bool hasCastedVote;
    }
    
    constructor() payable{
        voteraccess = msg.sender;                                                                      
    }
    
    modifier onlyVoter() {
        require(voteraccess == msg.sender);
          _;  
    }
    
    mapping(uint => voterDetail)  voterMapProfile;
    
    
    function registerNewVoter(string memory _name, uint _voterId, string memory _adhaarId) public{
        bytes memory adhaar_id = bytes(_adhaarId);
        require(adhaar_id.length == 12, "Adhaar Id is not 12 digits");
        require(!isVoterRegistered(_voterId), "Voter is already registered");
        voterDetail memory vd = voterDetail({name:_name , voterId:_voterId, adhaarId:_adhaarId, hasCastedVote : false });
        voterMapProfile[_voterId] = vd;
    }
    
    function castVote(uint _candidateId, uint _voterId) public onlyVoter {
        require(voterMapProfile[_voterId].hasCastedVote == false,"Sorry voter has already casted vote..");
        require(c1.isCandidateRegistered(_candidateId),'Incorrect candidate id choosen , please choose correct candidate id');
        require(isVoterRegistered(_voterId),'Incorrect voter id choosen , please choose correct voter id');
        c1.register_vote(_candidateId,_voterId);
        voterMapProfile[_voterId].hasCastedVote = true;
        
    }
    
    
    // function getCandidateDetails(uint _candidateId) public view returns (string memory, string memory, uint, string memory) {
    //     return(candidateMapProfile[_candidateId].name, candidateMapProfile[_candidateId].electionparty, candidateMapProfile[_candidateId].candidateId, candidateMapProfile[_candidateId].adhaarId);
    // }
    
    // function removeCandidate(uint _candidateId) public {
    //     delete candidateMapProfile[_candidateId];
    // }
    
    function isVoterRegistered(uint idToVerify) public view returns (bool) {
        if(idToVerify==voterMapProfile[idToVerify].voterId){
            return true;
        }else{
            return false;
        }
    }
    
}
