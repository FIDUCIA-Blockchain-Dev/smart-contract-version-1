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
    struct ballot{
         mapping(address=>Voters)  voters;
        uint ballotid;
        Candidates[]   candidates;
        Candidates[]  tiebreakers;
        address[] voter_address;
         uint  candidatescount;
    uint  starttime;
   bool isset ;
   bool isstarted ;
    bool isstartedregister ;
    bool isstoppedregister ;
    bool isstartedvoting ;
    bool isstoppedvoting ;
    bool isstartedreveal ;
    }
        mapping(uint => ballot) public ballots;
    uint public currentBallotID = 0;
    Candidates[]  public candidates;
    Candidates[] public tiebreakers;
    address[] public voter_address;
    uint public candidatescount;
    uint public starttime;
   bool isset = false;
   bool isstarted = false;
    bool isstartedregister = false;
    bool isstoppedregister = false;
    bool isstartedvoting = false;
    bool isstoppedvoting = false;
    bool isstartedreveal = false;
    constructor()  {
            
            chairperson = msg.sender;
            
                
    }
    function createBallot(uint no_of_voters) public{
        require(msg.sender==chairperson);
        uint ballotID = currentBallotID++;
        require(ballots[ballotID].isset==false);
         for(uint i=0;i<no_of_voters;i++)
        {
            ballots[ballotID].candidates.push(Candidates({
                        candidate_name: "candidate",no_of_votes:0
                }));
        }
        ballots[ballotID].candidatescount = no_of_voters;
        ballots[ballotID].isset = true;


    }
    function set(uint no_of_voters) public {
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

    }
    function get_isstarted(uint ballotID) public view returns (bool) {
        return ballots[ballotID].isstarted;
    }
     function get_isset(uint ballotID) public view returns (bool) {
        return ballots[ballotID].isset;
    }
     function get_isstartedregister(uint ballotID) public view returns (bool) {
        return ballots[ballotID].isstartedregister;
    }
     function get_isstoppedregister(uint ballotID) public view returns (bool) {
        return ballots[ballotID].isstoppedregister;
    }
     function get_isstartedvoting(uint ballotID) public view returns (bool) {
        return ballots[ballotID].isstartedvoting;
    }
     function get_isstoppedvoting(uint ballotID) public view returns (bool) {
        return ballots[ballotID].isstoppedvoting;
    }
     function get_isstartedreveal(uint ballotID) public view returns (bool) {
        return ballots[ballotID].isstartedreveal;
    }
    
    function add_candidates(string[] memory arr,uint ballotID) public {
        for(uint i=0;i<ballots[ballotID].candidatescount;i++)
        {
            ballots[ballotID].candidates[i].candidate_name = arr[i];
        }
    }
    function get_names(uint index,uint ballotID) public view returns (string memory)  {
        return ballots[ballotID].candidates[index].candidate_name;
    }
    function get_winners_length(uint ballotID) public view returns (uint ){
        return ballots[ballotID].tiebreakers.length;
    }
    function get_winners(uint index,uint ballotID) public view returns (string memory) {
        return ballots[ballotID].tiebreakers[index].candidate_name;
    }
    function start(uint ballotID) public{
        require(msg.sender==chairperson,"not chairperson");
        require(ballots[ballotID].isstarted==false ," started");
        starttime = block.timestamp;
        ballots[ballotID].isstarted = true;
    }

    function start_register(uint ballotID) public {
         require(msg.sender==chairperson,"chairperson");
        ballots[ballotID].isstartedregister = true;
    }
    function stop_register(uint ballotID) public {
         require(msg.sender==chairperson,"chairperson");
        ballots[ballotID].isstartedregister = false;
        ballots[ballotID].isstoppedregister = true;
    }
    function start_voting(uint ballotID) public {
         require(msg.sender==chairperson,"chairperson");
        require(ballots[ballotID].isstartedregister==false,"chairperson has  started register process");
    require(ballots[ballotID].isstoppedregister==true,"chairperson has not stopped register process");
        ballots[ballotID].isstartedvoting = true;
    }
    function stop_voting(uint ballotID) public {
         require(msg.sender==chairperson,"chairperson");
             require(ballots[ballotID].isstartedregister==false,"chairperson has  started register process");
    require(ballots[ballotID].isstoppedregister==true,"chairperson has not stopped register process");
        ballots[ballotID].isstartedvoting = false;
        ballots[ballotID].isstoppedvoting = true;
    }
    function start_reveal(uint ballotID) public {
        require(msg.sender==chairperson,"chairperson");
          require(ballots[ballotID].isstartedregister==false,"chairperson has  started register process");
    require(ballots[ballotID].isstoppedregister==true,"chairperson has not stopped register process");
    require(ballots[ballotID].isstartedvoting==false,"chairperson has   started voting process");
    require(ballots[ballotID].isstoppedvoting==true,"chairperson has not  stopped voting process");
            ballots[ballotID].isstartedreveal = true;
    }
    function register(uint ballotID) public
    {   require(msg.sender!=chairperson,"chairperson");
    require(ballots[ballotID].isstartedregister==true,"chairperson has not started register process");
    require(ballots[ballotID].isstoppedregister==false,"chairperson has stopped register process");
    require(ballots[ballotID].isstartedvoting==false,"chairperson has started voting process");
    require(ballots[ballotID].isstoppedvoting==false,"chairperson has stopped voting process");
    require(ballots[ballotID].isstartedreveal==false,"chairperson has started revealing the winners");   
    require(ballots[ballotID].isset==true,"chairpeson did not set");
    require(ballots[ballotID].isstarted==true,"chairperson did not start");
        address voter = msg.sender;
      // require(block.timestamp<= starttime + register_time*1 minutes);
        require(ballots[ballotID].voters[voter].voted == false,"voter already voted");
        require(ballots[ballotID].voters[voter].registered==false,"already registered");
        ballots[ballotID].voters[voter].weight = 1;
        ballots[ballotID].voters[voter].registered = true;
        ballots[ballotID].voter_address.push(voter);
    }

    function voting_process(uint vo,uint ballotID) public 
    {     // require(block.timestamp>= starttime + register_time*1 minutes && block.timestamp<= starttime + voting_time*1 minutes);
            require(ballots[ballotID].voters[msg.sender].weight !=0,"voter not registered");
            require(!ballots[ballotID].voters[msg.sender].voted,"voter already voted");
             require(msg.sender!=chairperson,"chairperson");
    require(ballots[ballotID].isstartedregister==false,"chairperson has  started register process");
    require(ballots[ballotID].isstoppedregister==true,"chairperson has not stopped register process");
    require(ballots[ballotID].isstartedvoting==true,"chairperson has not  started voting process");
    require(ballots[ballotID].isstoppedvoting==false,"chairperson has stopped voting process");
    require(ballots[ballotID].isstartedreveal==false,"chairperson has started revealing the winners");  
            
            
                ballots[ballotID].voters[msg.sender].vote = vo;
                ballots[ballotID].voters[msg.sender].voted = true;
                ballots[ballotID].candidates[vo].no_of_votes += 1;
            
    }

    function reveal_winner(uint ballotID) public   
    {  //require(block.timestamp>=starttime + reveal_winner_time*1 minutes);
         require(msg.sender!=chairperson,"chairperson");
    require(ballots[ballotID].isstartedregister==false,"chairperson has  started register process");
    require(ballots[ballotID].isstoppedregister==true,"chairperson has not stopped register process");
    require(ballots[ballotID].isstartedvoting==false,"chairperson has   started voting process");
    require(ballots[ballotID].isstoppedvoting==true,"chairperson has not  stopped voting process");
    require(ballots[ballotID].isstartedreveal==true,"chairperson has not started revealing the winners");   
       
        tiecalculate(ballotID);
        
      
    }
    function tiecalculate(uint ballotID) public
    {
        uint winningvotecounts = 0;
      
        for(uint i=0;i<ballots[ballotID].candidates.length;i++)
        {
                if(winningvotecounts<ballots[ballotID].candidates[i].no_of_votes)
                {
                    winningvotecounts = ballots[ballotID].candidates[i].no_of_votes;
                   
                }
               
        }
       
        for(uint i=0;i<ballots[ballotID].candidates.length;i++)
        {
            if(winningvotecounts == ballots[ballotID].candidates[i].no_of_votes)
            {
                tiebreakers.push(Candidates({
                    candidate_name: ballots[ballotID].candidates[i].candidate_name,
                    no_of_votes: ballots[ballotID].candidates[i].no_of_votes
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
    
    function reset(uint ballotID) public 
    {
        candidatescount = 0;
        starttime = 0;
        ballots[ballotID].isstarted = false;
        ballots[ballotID].isset = false;
        for(uint256 i=0;i<ballots[ballotID].candidates.length;i++)
        {
            delete ballots[ballotID].candidates[i];
            
        }
        for(uint256 i=0;i<ballots[ballotID].tiebreakers.length;i++)
        {
            
            delete ballots[ballotID].tiebreakers[i];
        }
        for(uint256 i=0;i<ballots[ballotID].voter_address.length;i++)
        {
            delete ballots[ballotID].voters[ballots[ballotID].voter_address[i]];
        }
    ballots[ballotID].isstartedregister = false;
    ballots[ballotID].isstoppedregister = false;
    ballots[ballotID].isstartedvoting = false;
    ballots[ballotID].isstoppedvoting = false;
    ballots[ballotID].isstartedreveal = false;
        
        
        
    }
}
