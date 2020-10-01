# Solidity code for General Elections - Assignment 1

## Summary

This Section has the logic implemented to Show a Sample General Elections.
There are 2 files, one for `Candidate.sol` who is standing in election and other file for `Voter.sol` where voters are maintained.

## Capabilities covered in the code

1. `Candidate` -> Register New Candidate, Remove Candidate,Get Candidate Details, Get VoteCount of Candidate, IsCandidateRegistered
2. `Voter` -> Register New Voter, Cast Vote, IsVoterRegistered

## Steps -

1. Deploy Candidate Contract with Account (A1)
2. Add 2 or more Candidates with registerNewCandidate function
3. Verify duplicate Candidate Id entries are not allowed
4. Then Check if all the candidates are registered correctly
5. Now Deploy Voter.sol Contract with different account ( A2 )with Contract Address of Candidate
6. Now Register 4-5 Voters
7. Now with all voters cast Votes using castVote method to respective candidate ids
8. Now with Account1 click `getWinner`

## Result - 

It will show the `candidate Name` and `votecount` who is winner in the Elections.
