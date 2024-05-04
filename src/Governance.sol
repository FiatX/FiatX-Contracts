// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IRouter} from "./interface/IRouter.sol";

contract GovernanceDispute {
    address public adjudicator1;
    address public adjudicator2;
    address public adjudicator3;
    address public adjudicator4;
    address public adjudicator5;

    IRouter public router;

    struct VotingResult {
        address escrow;
        uint256 merchantVotes;
        uint256 userVotes;
        uint256 timeVote;
        bool done;
    }

    mapping(address => VotingResult) public votingMap;
    mapping(address => mapping(address => bool)) public voted;

    event DisputeHappen(address indexed escrow, uint256 timeVote);
    event Voted(address indexed adjudicator, bool side);

    constructor(
        address _adjudicator1,
        address _adjudicator2,
        address _adjudicator3,
        address _adjudicator4,
        address _adjudicator5,
        address _router
    ) {
        adjudicator1 = _adjudicator1;
        adjudicator2 = _adjudicator2;
        adjudicator3 = _adjudicator3;
        adjudicator4 = _adjudicator4;
        adjudicator5 = _adjudicator5;
        router = IRouter(_router);
    }

    function add_vote_dispute(address escrow) external {
        //first check if the router has the escrow address
        require(votingMap[escrow].escrow != escrow, "Dispute have been made");
        (address _escrowAdd, address merchant, address user, uint256 amount) = router.get_escrow_data(escrow);
        require(amount != 0 || user != address(0) || merchant != address(0), "Transaction not found");
        require(msg.sender == escrow, "Someone is calling it outside the escrow");

        VotingResult memory votingData = VotingResult(escrow, 0, 0, block.timestamp + 1 days, false);
        votingMap[escrow] = votingData;

        emit DisputeHappen(escrow, block.timestamp + 1 days);
    }

    function vote(address escrow, bool side) external {
        require(votingMap[escrow].escrow == escrow, "Dispute not found");
        require(votingMap[escrow].timeVote >= block.timestamp, "Time has ran out");
        require(
            msg.sender == adjudicator1 || msg.sender == adjudicator2 || msg.sender == adjudicator3
                || msg.sender == adjudicator4 || msg.sender == adjudicator5,
            "You are not adjudicator so u cant vote"
        );
        if (side == true) {
            votingMap[escrow].merchantVotes += 1;
            voted[escrow][msg.sender] = true;
        } else {
            votingMap[escrow].userVotes += 1;
            voted[escrow][msg.sender] = true;
        }
        emit Voted(msg.sender, side);
    }

    function get_the_five_adjudicator() public view returns (address, address, address, address, address) {
        return (adjudicator1, adjudicator2, adjudicator3, adjudicator4, adjudicator5);
    }
}
