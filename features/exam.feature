Feature: Exam
  In order to learn the words
  Arden
  want to take exam

@arden
  Scenario: take the exam for my words
	Give "Arden" logged in
	When "Arden" starts the exam
	Then "Arden" can get a list of question from his vocabulary

  Scenario: take the exam for top words
	Give "Arden" logged in
	When "Arden" starts the exam
	Then "Arden" can get a list of question from his vocabulary from
	
  Scenario: Shai testing results to douban
	Give "Arden" logged in
	When "Arden" finished the exam
	Then "Arden" share this result to his douban friends

  Scenario: Shai testing results to facebook
	Give "Arden" logged in
	When "Arden" finished the exam
	Then "Arden" share this result to his douban facebook
	
  Scenario: Shai testing results to kaixin001
	Give "Arden" logged in
	When "Arden" finished the exam
	Then "Arden" share this result to his douban kaixin001
