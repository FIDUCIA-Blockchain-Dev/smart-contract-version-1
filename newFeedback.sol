
pragma solidity ^0.8.17;

// SPDX-License-Identifier: GPL-3.0

contract Feedback {
    address public chairperson;
    uint256 public Token;
    uint256 public questionsCount;
    uint256 public candidatescount;
    uint256 public StartRegisterTime;
    uint256 public StopRegisterTime;
    uint256 public StartFeedbackTime;
    uint256 public StopFeedbackTime;
    uint256 public StartResultTime;
    string[] public RegNo;
    string[] public Phone;
    string[] public Email;
   struct Feedbacks
   {
    uint qid;
    string answer;
   }
   Feedbacks[] public feedbacks;
   
    
    constructor(
        uint256 token,
        string[] memory regNo,
        string[] memory phone,
        string[] memory email,
        uint256[5] memory Times,
        uint256 NoOfQuestions
    ) {
        chairperson = msg.sender;
        Token = token;
        RegNo = regNo;
        Phone = phone;
        Email = email;
        StartRegisterTime = Times[0];
        StopRegisterTime = Times[1];
        StartFeedbackTime = Times[2];
        StopFeedbackTime = Times[3];
        StartResultTime = Times[4];
        questionsCount = NoOfQuestions;
    }
    function giveFeedback(string[] memory Answers) public {
        require(Answers.length==questionsCount);
        for(uint i=0;i<Answers.length;i++)
        {
            feedbacks.push(Feedbacks({
                qid:i,
                answer:Answers[i]
        }));
        }
        
       
    }
       // Function to retrieve all answers for a specific qid
    function getAnswersForQid(uint _qid) public view returns (string[] memory) {
        // Create a dynamic array to store answers for the given qid
        string[] memory answersForQid = new string[](feedbacks.length);
        uint count = 0;

        // Loop through the feedbacks array
        for (uint i = 0; i < feedbacks.length; i++) {
            // Check if the qid matches
            if (feedbacks[i].qid == _qid) {
                // Add the answer to the dynamic array
                answersForQid[count] = feedbacks[i].answer;
                count++;
            }
        }

        // Resize the array to remove unused space
        assembly {
            mstore(answersForQid, count)
        }

        return answersForQid;
    }
}
