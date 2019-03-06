pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract DateTime{
    function getYear(uint timestamp) public pure returns (uint16);
    function getMonth(uint timestamp) public pure returns (uint8);
    function getDay(uint timestamp) public pure returns (uint8);
}


contract Election {
    // Model a Candidate

    address public administrator;
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct AuthenticatedVoter{
        address add;
        string hashedPWD;
    }

    
    // Store address that have be authenticated
    mapping(address => AuthenticatedVoter) private authenticatvoters; 
    // Store addresses that have been created
    mapping(address => bool) public existVoters;
    // Store accounts that have voted
    mapping(address => bool) public voters;
    // Store Candidates
    // Fetch Candidate
    mapping(uint => Candidate) public candidates;
    // Store Candidates Count
    uint public candidatesCount;

    // voted event
    event votedEvent (
        uint indexed _candidateId
    );

    event loginSuccessEvent();


    constructor (string[] memory candidateName) public {
        candidatesCount = candidateName.length;
        administrator = msg.sender;
        // how to set the date for the voting

        for(uint i=0;i<candidateName.length;i++)
            candidates[i+1] = Candidate(i+1, candidateName[i], 0);
    }

    function login(string memory _hashpwd) public
    {
        require(existVoters[msg.sender]);
    
        require(keccak256(bytes(_hashpwd)) == keccak256(bytes(authenticatvoters[msg.sender].hashedPWD)));

        // redirect to main page;
        emit loginSuccessEvent();
    }

    function addVoter(address addr,string memory _hashpwd) public
    {
        require(msg.sender == administrator);
        require(!existVoters[addr]);

        authenticatvoters[addr] = AuthenticatedVoter(addr,_hashpwd);
        existVoters[addr] = true;
    }

    function addCandidate (string memory _name) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    // let the authenticated user to vote.
    function vote (uint _candidateId) public {
        
        require(existVoters[msg.sender]);

        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;

        // trigger voted event
        emit votedEvent(_candidateId);
    }
}
