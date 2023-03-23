pragma solidity  ^0.8.17;
// SPDX-License-Identifier: GPL-3.0
/**
   * @title ContractName
   * @dev ContractDescription
   * @custom:dev-run-script Test.sol
   */
contract feedback{
    // state variables
    struct Person{
        bool f_given;
        bool registered;
        address delegate;
        string feedback;
        uint weight;
        
    }

string[] public feedback_list;
uint count=0;

    mapping(address=>Person) public people;

    function register() public
    {   
        address person = msg.sender;
        require(people[person].f_given == false);
        require(people[person].registered==false);
        people[person].weight = 1;
        people[person].registered = true;
        
    }


    function feedback_process(string memory feed) public 
    {       
            require(people[msg.sender].weight !=0);
            require(people[msg.sender].f_given == false);

                address p = msg.sender;
                feedback_list.push(feed);
                
                people[p].feedback = feed;
                people[p].f_given = true;
               
            
    }
    

    
}
