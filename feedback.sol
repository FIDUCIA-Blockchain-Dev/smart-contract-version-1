pragma solidity ^0.8.17;
// SPDX-License-Identifier: GPL-3.0
contract feedback {
    address public chairperson;
   
    string[] public Questions;
    struct questions_and_answers
    {
        uint question;
        string answer;
    }
    questions_and_answers[] public Questions_And_Answers;
    struct User
    {
        address user_address;
        
        bool registered;
    }
    struct answers_with_question
    {
        uint  question_no;
        string[] answers;
        string type_of_answer;
    }
    answers_with_question[] public Answers_with_Question;
    bool public start = false;
    address[] registered_users;
    mapping(address=>User) public users;
    bool isReset = false;
    constructor() {
        chairperson = msg.sender;
    }

    function Start() public {
        //require(!start, "already started");
        start = true;
    }
    function set_isReset(bool a) public {
        isReset = a;
    }
    function get_isReset() public view returns (bool) {
        return isReset;
    }
    function no_of_q() public view returns (uint){
        return Questions.length;
    }
    function questions_input(string[] calldata questions, uint no_of_q1) public {
    require(start, "Question input is not allowed before starting.");
    require(msg.sender == chairperson, "Only chairperson is allowed to input questions.");
    require(questions.length == no_of_q1, "Number of questions must match the specified length.");

    for (uint i = 0; i < no_of_q1; i++) {
        Questions.push(questions[i]);
    }
}
   // Define a mapping to store answers for each question
mapping(uint => answers_with_question) public AnswersMap;
 uint[] public keys; // This array will store the keys
function answers_input(uint no_of_q2, string[][] memory options, string memory t) public {
    require(start, "Question input is not allowed before starting.");
    require(msg.sender == chairperson, "Only chairperson is allowed to input options.");
    require(no_of_q2 > 0, "Number of questions must be greater than zero.");
    require(options.length == no_of_q2, "Number of question options arrays must match the specified number of questions.");

    for (uint i = 0; i < no_of_q2; i++) {
        AnswersMap[i] = answers_with_question({
            question_no: i,
            answers: options[i],
            type_of_answer: t
        });
        keys.push(i);
    }
}

    function register() public 
    {     
          address person = msg.sender;
          require(start, "cannot register before starting");
        require(msg.sender!=chairperson,"chairperson cannot register");
        require(users[person].registered==false,"user is already registered");
      
        users[person].user_address = person;
        users[person].registered = true;
        registered_users.push(person);

    }
   function answers(uint[] calldata question_nos, string[][] calldata answers1) public {
    require(question_nos.length == answers1.length, "Number of questions and answer arrays must match.");
    require(start, "Cannot answer before starting.");
    address person = msg.sender;
    require(users[person].registered == true, "User is not registered.");
    
    for (uint i = 0; i < question_nos.length; i++) {
        require(question_nos[i] >= 0 && question_nos[i] < Questions.length, "Invalid question number");
        
        // Store each question and its answers
        for (uint j = 0; j < answers1[i].length; j++) {
            Questions_And_Answers.push(questions_and_answers({
                question: question_nos[i],
                answer: answers1[i][j]
            }));
        }
    }
}
  function getAnswersForQuestion(uint question_no) public view returns (string[] memory) {
    require(question_no >= 0 && question_no < Questions.length, "Invalid question number");
    require(msg.sender == chairperson, "The user is not a chairperson");
    require(start, "Cannot get answers before starting");

    string[] memory answer = new string[](Questions_And_Answers.length); // Initialize an array with a fixed length

    uint k = 0;
    for (uint i = 0; i < Questions_And_Answers.length; i++) {
        if (Questions_And_Answers[i].question == question_no) {
            answer[k] = Questions_And_Answers[i].answer;
            k++;
        }
    }

    // Resize the array to the correct length
    assembly {
        mstore(answer, k)
    }

    return answer;
}
function get_Questions(uint q_no) public view returns(string memory) {
     require(q_no >= 0 && q_no < Questions.length, "Invalid question number");
    return Questions[q_no];
}

function get_options(uint q_no) public view returns (string[] memory){
    require(q_no >= 0 && q_no < Questions.length, "Invalid question number");
    
   return AnswersMap[q_no].answers;
}
function get_type(uint q_no) public view returns (string memory){
    return AnswersMap[q_no].type_of_answer;

}

function reset() public 
{   require(msg.sender==chairperson,"the user is not chairperson");
isReset = true;
    start = false;
    //Questions_And_Answers
    //users
    //Questions
   /* for(uint i=0;i<Questions_And_Answers.length;i++)
    {
        delete Questions_And_Answers[i];
    }*/
    while(Questions_And_Answers.length>0)
    {
        Questions_And_Answers.pop();
    }
    
    for(uint i=0;i<registered_users.length;i++)
    {
        delete users[registered_users[i]];
    }
    /*for(uint i=0;i<Questions.length;i++)
    {
        delete Questions[i];
    }*/
    while(Questions.length>0)
    {
        Questions.pop();
    }
    
    /*for(uint i=0;i<Answers_with_Question.length;i++)
    {
        delete Answers_with_Question[i];
    }*/
    while(Answers_with_Question.length>0)
    {
        Answers_with_Question.pop();
    }
   
     // Iterate through the keys and delete the values
        for (uint i = 0; i < keys.length; i++) {
            delete AnswersMap[keys[i]];
        }
        // Clear the keys array
        //delete keys;
        while(keys.length>0)
        {
            keys.pop();
        }
        
}

}
