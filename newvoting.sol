pragma solidity  ^0.8.17;
// SPDX-License-Identifier: GPL-3.0

contract Voting{
    // state variables
     
    struct Voters{
        bool voted;
        bool registered;
        address delegate;
        uint vote;
        uint weight;
        
    }
     struct Candidates{
        uint candidateNo;
        
        uint no_of_votes;
    }
    uint registerFrom;
    uint registerTo;
    uint votingFrom;
    uint votingTo;
    uint resultsFrom;
    address public chairperson;
        Candidates[]  public candidates;
    Candidates[] public tiebreakers;
     uint public candidatescount;
     mapping(address=>Voters) public voters;
     constructor(){
        chairperson = msg.sender;
     }
     function set(uint noOfCandidates) public {
        require(msg.sender==chairperson,"the user is not chairperson");
        candidatescount = noOfCandidates;
        for(uint i=0;i<noOfCandidates;i++)
        {
             candidates.push(Candidates({
                candidateNo: i,
                no_of_votes: 0
            }));

        }

     }
     function register() public{
        require(msg.sender!=chairperson,"the user is the chairperson");
        address voter = msg.sender;
          require(voters[voter].voted == false,"voter already voted");
        require(voters[voter].registered==false,"already registered");
        voters[voter].weight = 1;
        voters[voter].registered = true;
     }
     function voting(uint vo) public{
         require(msg.sender!=chairperson,"the user is the chairperson");
             require(voters[msg.sender].weight !=0,"voter not registered");
            require(!voters[msg.sender].voted,"voter already voted");
              voters[msg.sender].vote = vo;
                voters[msg.sender].voted = true;
                candidates[vo].no_of_votes += 1;

     }
     function results() public{
          require(msg.sender!=chairperson,"chairperson");
           tiecalculate();
     }
     function tiecalculate() private{
          uint winningvotecounts = 0;
      
        for(uint i=0;i<candidates.length;i++)
        {
                if(winningvotecounts<candidates[i].no_of_votes)
                {
                    winningvotecounts = candidates[i].no_of_votes;
                   
                }
               
        }
       
        for(uint i=0;i<candidates.length;i++)
        {
            if(winningvotecounts == candidates[i].no_of_votes)
            {
                tiebreakers.push(Candidates({
                    candidateNo: candidates[i].candidateNo,
                    no_of_votes: candidates[i].no_of_votes
                }));
            }
        }
     }
}