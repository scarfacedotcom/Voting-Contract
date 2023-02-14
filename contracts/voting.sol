// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract voteContest is ERC20 {
    address public owner;
    address public Admin;
    bool public votingOngoing;


    address[] contestants;

    mapping(address => bool) public isContestant;
    mapping(address => bool) public alreadyVoted;
    mapping(address => uint) public contestantPoint;

    struct contestantResult {
        address _contestant;
        uint256 point;
    }

    contestantResult[] Result;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 _amount
    ) ERC20(name_, symbol_) {
        Admin = msg.sender;
        owner = address(this);
        _mint(Admin, _amount);

    }

    modifier onlyOwner() {
        require(
            msg.sender == owner || msg.sender == Admin,
            "Only owner can call this function"
        );
        _;
    }

    modifier onlyOneContestant(address[] memory _contestants) {
        require(
            _contestants[0] != _contestants[1] &&
                _contestants[1] != _contestants[2] &&
                _contestants[0] != _contestants[2],
            "Cannot pass in same address twice"
        );
        _;
    }

    function registerContestants(
        address[] memory _contestants
    ) public onlyOwner {
        require(_contestants.length == 3, "Contesters not up to 3");
        for (uint i = 0; i < _contestants.length; i++) {
            require(
                !isContestant[_contestants[i]],
                "Contestant already registered"
            );
            for (uint j = i + 1; j < _contestants.length; j++) {
                require(
                    _contestants[i] != _contestants[j],
                    "Duplicate contestant found"
                );
            }
            isContestant[_contestants[i]] = true;
        }
        contestants = _contestants;
    }

    function vote(
        address[] memory _contestants
    ) public onlyOneContestant(_contestants) {
        require(!votingOngoing, "vote is ongoing");
        require(isContestant[msg.sender] == false, "you cant vote yourself");
        require(alreadyVoted[msg.sender] == false, "you have already voted");
        uint256 tokenAmount = 3 * (_contestants.length);
        require(
            balanceOf(msg.sender) >= tokenAmount,
            "not enough tokens to vote"
        );
        transfer(address(this), tokenAmount);
        for (uint i = 0; i < _contestants.length; i++) {
            require(isContestant[_contestants[i]], "verify please");
            contestantPoint[_contestants[i]] += 3 - i;
        }
        alreadyVoted[msg.sender] = true;
            // Check if all eligible voters have cast their votes
        uint256 votesCast = 0;
        for (uint i = 0; i < contestants.length; i++) {
            if (alreadyVoted[contestants[i]]) {
                votesCast++;
            }
        }

        // If all eligible voters have cast their votes, stop the voting process
        if (votesCast == contestants.length) {
            votingOngoing = false;
        }
    }

    function getVoteResults() public view returns (contestantResult[] memory) {
        require(!votingOngoing, "voting is still ongoing");

        contestantResult[] memory results = new contestantResult[](
            contestants.length
        );

        for (uint256 i = 0; i < contestants.length; i++) {
            address contestant = contestants[i];
            uint256 points = contestantPoint[contestant];
            results[i] = contestantResult(contestant, points);
        }

        return results;
    }

    function getWinner() public view returns (address winner, uint256 _points) {
        require(!votingOngoing, "voting is still ongoing");

        uint256 highestPoints = 0;

        for (uint256 i = 0; i < contestants.length; i++) {
            address contestant = contestants[i];
            uint256 points = contestantPoint[contestant];
            if (points > highestPoints) {
                highestPoints = points;
                winner = contestant;
            }
        }

        _points = highestPoints;
    }

    function startVoting() public onlyOwner {
        votingOngoing = true;
    }

    function endVoting() public onlyOwner {
        votingOngoing = false;
    }

    function buyToken(uint _amount) public payable {
        // require(msg.value >= _amount, "Not enough ether");
        (bool success, ) = payable(address(this)).call{value: msg.value}("");
        require(success);
        _mint(msg.sender, _amount);
    }
}
