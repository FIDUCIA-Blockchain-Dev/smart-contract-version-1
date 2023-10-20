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
    bool isstartedregister = false;
    bool isstoppedregister = false;
    bool isstartedvoting = false;
    bool isstoppedvoting = false;
    bool isstartedreveal = false;
    constructor()  {
            
            chairperson = msg.sender;
            
                
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
    function get_isstarted() public view returns (bool) {
        return isstarted;
    }
     function get_isset() public view returns (bool) {
        return isset;
    }
     function get_isstartedregister() public view returns (bool) {
        return isstartedregister;
    }
     function get_isstoppedregister() public view returns (bool) {
        return isstoppedregister;
    }
     function get_isstartedvoting() public view returns (bool) {
        return isstartedvoting;
    }
     function get_isstoppedvoting() public view returns (bool) {
        return isstoppedvoting;
    }
     function get_isstartedreveal() public view returns (bool) {
        return isstartedreveal;
    }
    
    function add_candidates(string[] memory arr) public {
        for(uint i=0;i<candidatescount;i++)
        {
            candidates[i].candidate_name = arr[i];
        }
    }
    function get_names(uint index) public view returns (string memory)  {
        return candidates[index].candidate_name;
    }
    function get_winners_length() public view returns (uint ){
        return tiebreakers.length;
    }
    function get_winners(uint index) public view returns (string memory) {
        return tiebreakers[index].candidate_name;
    }
    function start() public{
        require(msg.sender==chairperson,"not chairperson");
        require(isstarted==false ," started");
        starttime = block.timestamp;
        isstarted = true;
    }

    function start_register() public {
         require(msg.sender==chairperson,"chairperson");
        isstartedregister = true;
    }
    function stop_register() public {
         require(msg.sender==chairperson,"chairperson");
        isstartedregister = false;
        isstoppedregister = true;
    }
    function start_voting() public {
         require(msg.sender==chairperson,"chairperson");
        require(isstartedregister==false,"chairperson has  started register process");
    require(isstoppedregister==true,"chairperson has not stopped register process");
        isstartedvoting = true;
    }
    function stop_voting() public {
         require(msg.sender==chairperson,"chairperson");
             require(isstartedregister==false,"chairperson has  started register process");
    require(isstoppedregister==true,"chairperson has not stopped register process");
        isstartedvoting = false;
        isstoppedvoting = true;
    }
    function start_reveal() public {
        require(msg.sender==chairperson,"chairperson");
          require(isstartedregister==false,"chairperson has  started register process");
    require(isstoppedregister==true,"chairperson has not stopped register process");
    require(isstartedvoting==false,"chairperson has   started voting process");
    require(isstoppedvoting==true,"chairperson has not  stopped voting process");
            isstartedreveal = true;
    }
    function register() public
    {   require(msg.sender!=chairperson,"chairperson");
    require(isstartedregister==true,"chairperson has not started register process");
    require(isstoppedregister==false,"chairperson has stopped register process");
    require(isstartedvoting==false,"chairperson has started voting process");
    require(isstoppedvoting==false,"chairperson has stopped voting process");
    require(isstartedreveal==false,"chairperson has started revealing the winners");   
    require(isset==true,"chairpeson did not set");
    require(isstarted==true,"chairperson did not start");
        address voter = msg.sender;
      // require(block.timestamp<= starttime + register_time*1 minutes);
        require(voters[voter].voted == false,"voter already voted");
        require(voters[voter].registered==false,"already registered");
        voters[voter].weight = 1;
        voters[voter].registered = true;
        voter_address.push(voter);
    }

    function voting_process(uint vo) public 
    {     // require(block.timestamp>= starttime + register_time*1 minutes && block.timestamp<= starttime + voting_time*1 minutes);
            require(voters[msg.sender].weight !=0,"voter not registered");
            require(!voters[msg.sender].voted,"voter already voted");
             require(msg.sender!=chairperson,"chairperson");
    require(isstartedregister==false,"chairperson has  started register process");
    require(isstoppedregister==true,"chairperson has not stopped register process");
    require(isstartedvoting==true,"chairperson has not  started voting process");
    require(isstoppedvoting==false,"chairperson has stopped voting process");
    require(isstartedreveal==false,"chairperson has started revealing the winners");  
            
            
                voters[msg.sender].vote = vo;
                voters[msg.sender].voted = true;
                candidates[vo].no_of_votes += 1;
            
    }

    function reveal_winner() public   
    {  //require(block.timestamp>=starttime + reveal_winner_time*1 minutes);
         require(msg.sender!=chairperson,"chairperson");
    require(isstartedregister==false,"chairperson has  started register process");
    require(isstoppedregister==true,"chairperson has not stopped register process");
    require(isstartedvoting==false,"chairperson has   started voting process");
    require(isstoppedvoting==true,"chairperson has not  stopped voting process");
    require(isstartedreveal==true,"chairperson has not started revealing the winners");   
       
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
        while(candidates.length>0)
    {
        candidates.pop();
    }
        /*for(uint256 i=0;i<candidates.length;i++)
        {
            delete candidates[i];
            
        }*/
       /* for(uint256 i=0;i<tiebreakers.length;i++)
        {
            
            delete tiebreakers[i];
        }*/
              while(tiebreakers.length>0)
    {
        tiebreakers.pop();
    }
                while(voter_address.length>0)
    {
        voter_address.pop();
    }
        /*for(uint256 i=0;i<voter_address.length;i++)
        {
            delete voters[voter_address[i]];
        }*/
    isstartedregister = false;
    isstoppedregister = false;
    isstartedvoting = false;
    isstoppedvoting = false;
    isstartedreveal = false;
        
        
        
    }
}
