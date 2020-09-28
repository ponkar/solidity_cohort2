pragma solidity ^0.7.0;

contract Candidate {
    
    address payable ECAuthority;
    
    struct candidateDetail{
        string name;
        string electionparty;
        uint candidateId;
        string adhaarId;
        uint voteCount;
    }
    
    struct ballot{
        uint voter_Id;
        string candidateId;
        
    }
    
    
    constructor() payable{
        ECAuthority  = msg.sender;
        // ballot memory blt = ballot({});
    }
    
    modifier onlyElectionCommission() {
        require(ECAuthority == msg.sender,"UnAuthorized account....");
          _;  
    }
    
    mapping(uint => candidateDetail)  candidateMapProfile;
    
    
    function registerNewCandidate(string memory _name, string memory _elec_party, uint _candId, string memory _adhaarId) public onlyElectionCommission{
        bytes memory adhaar_id = bytes(_adhaarId);
        require(adhaar_id.length == 12, "Adhaar Id is not 12 digits");
        require(!isCandidateRegistered(_candId), "Candidate is already registered");
        candidateDetail memory cd = candidateDetail({name:_name , electionparty:_elec_party, candidateId:_candId, adhaarId:_adhaarId, voteCount:0  });
        candidateMapProfile[_candId] = cd;
    }
    
    function getCandidateDetails(uint _candidateId) public view returns (string memory, string memory, uint, string memory) {
        require(isCandidateRegistered(_candidateId), "No Candidate registered with this ID");
        return(candidateMapProfile[_candidateId].name, candidateMapProfile[_candidateId].electionparty, candidateMapProfile[_candidateId].candidateId, candidateMapProfile[_candidateId].adhaarId);
    }
    
    function removeCandidate(uint _candidateId) public onlyElectionCommission {
        delete candidateMapProfile[_candidateId];
    }
    
    function isCandidateRegistered(uint idToVerify) public view returns (bool) {
        if(idToVerify==candidateMapProfile[idToVerify].candidateId){
            return true;
        }else{
            return false;
        }
        
    }
    
    function register_vote(uint _candidate_id, uint _voter_id) public{
        candidateMapProfile[_candidate_id].voteCount+=1;
    }
    
    function getVoteCountForCandidate(uint _candidate_id) public view onlyElectionCommission returns (uint){
        return candidateMapProfile[_candidate_id].voteCount;
    }
    
    
}
