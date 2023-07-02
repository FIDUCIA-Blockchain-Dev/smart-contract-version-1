pragma solidity  ^0.8.17;
// SPDX-License-Identifier: GPL-3.0
contract voting{
    // state variables
    address public chairperson;
    struct Voters{
        bool voted;
        bool registered;
        address delegate;
        uint vote;
        uint weight;
        
    }

    mapping(address=>Voters) public voters;
    struct Candidates{
        string  candidate_name;
        
        uint no_of_votes;
    }

    Candidates[]  public candidates;
    Candidates[] public tiebreakers;
    address[] public voter_address;
    uint public candidatescount;
    uint public starttime;
   bool isset = false;
   bool isstarted = false;
uint register_time;
uint voting_time;
uint reveal_winner_time;
    constructor()  {
            
            chairperson = msg.sender;
            
                
    }
    function set(uint no_of_voters,uint r,uint v,uint rev) public {
        require(msg.sender==chairperson);
        require(isset==false);
        for(uint i=0;i<no_of_voters;i++)
        {
            candidates.push(Candidates({
                        candidate_name: "candidate",no_of_votes:0
                }));
        }
        candidatescount = no_of_voters;
        isset = true;
register_time = r;
voting_time = v;
reveal_winner_time = rev;
    }
    function start() public{
        require(msg.sender==chairperson);
        require(isstarted==false);
        starttime = block.timestamp;
    }
    function register() public
    {   require(msg.sender!=chairperson);  
    require(isset==true);
    require(isstarted==true);
        address voter = msg.sender;
       require(block.timestamp<= starttime + register_time*1 minutes);
        require(voters[voter].voted == false);
        require(voters[voter].registered==false);
        voters[voter].weight = 1;
        voters[voter].registered = true;
        voter_address.push(voter);
    }

    function voting_process(uint vo) public 
    {      require(block.timestamp>= starttime + register_time*1 minutes && block.timestamp<= starttime + voting_time*1 minutes);
            require(voters[msg.sender].weight !=0);
            require(!voters[msg.sender].voted);

            
            
                voters[msg.sender].vote = vo;
                voters[msg.sender].voted = true;
                candidates[vo].no_of_votes += 1;
            
    }

    function reveal_winner() public   
    {  require(block.timestamp>=starttime + reveal_winner_time*1 minutes);
   
       
        tiecalculate();
        
      
    }
    function tiecalculate() public
    {
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
                    candidate_name: candidates[i].candidate_name,
                    no_of_votes: candidates[i].no_of_votes
                }));
            }
        }
    }

   
   /* function tie(uint v) public
    {
        require(msg.sender == chairperson);
        require(tiebreakers.length>1);
        
        candidates[v].no_of_votes += 1;
    }*/
    
    function reset() public 
    {
        candidatescount = 0;
        starttime = 0;
        isstarted = false;
        isset = false;
        for(uint256 i=0;i<candidates.length;i++)
        {
            delete candidates[i];
            
        }
        for(uint256 i=0;i<tiebreakers.length;i++)
        {
            
            delete tiebreakers[i];
        }
        for(uint256 i=0;i<voter_address.length;i++)
        {
            delete voters[voter_address[i]];
        }
        
        
        
    }
}
