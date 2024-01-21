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
        string candidateName;
        
        string candidatedescription;
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
     uint public StartRegisterTime;
     uint public StopRegisterTime;
     uint public StartVotingTime;
     uint public StopVotingTime;
     uint public StartResultTime;
     string[] public RegNo;
     string[]  public Phone;
     string[] public Email;
   
     mapping(address=>Voters) public voters;
     constructor(){
        chairperson = msg.sender;
         
     }
     function set(string[] memory regNo,string[
] memory phone,string[] memory email,string[] memory candidateNames,string[] memory candidateDesc,uint NoOfCandidates,uint startregistertime,uint stopregistertime,
     uint startvotingtime,uint stopvotingtime,uint startresultstime) public {
        require(msg.sender==chairperson,"the user is not chairperson");
        candidatescount = NoOfCandidates;
         StartRegisterTime = startregistertime;
         StopRegisterTime =stopregistertime;
         StartVotingTime = startvotingtime;
         StopVotingTime = stopvotingtime;
         StartResultTime = startresultstime;

        for(uint i=0;i<candidatescount;i++)
        {
            candidates.push(
                Candidates({
                    candidateNo:i,
                    no_of_votes:0,
                    candidateName:candidateNames[i],
                    
                    candidatedescription:candidateDesc[i]



                })
            );
        }
        RegNo = regNo;
        Phone = phone;
        Email = email;
       

     }
     function getLengthRegNo() public view returns(uint)
     {
        return RegNo.length;
     }
     function getLengthPhone() public view returns(uint)
     {
        return Phone.length;
     }
     function getLengthEmail() public view returns(uint)
     {
        return Email.length;
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
                    no_of_votes: candidates[i].no_of_votes,
                      candidateName:candidates[i].candidateName,
                   
                    candidatedescription:candidates[i].candidatedescription

                }));
            }
        }
     }
}
