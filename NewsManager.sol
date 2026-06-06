// SPDX-License-Identifier: MIT

pragma solidity >=0.8.3;

import "./NewsValidationLib.sol";

contract NewsManager {

    // STRUCTS
    struct Validator {
        uint256 accumulatedRewards;
        uint256 totalVotes;
        uint256 sumOfRatings;
        bool isActive;
    }

    struct News {
        address createBy;
        string newsName;
        uint256 deadline;
        uint256 minValidations;
        bool isConfirmed;
        uint256 validationCount;
        address[] validators;
    }

    // STATE VARIABLES
    address public owner;
    uint256 public totalDistributed;
    uint256 public rewardAmount;

    // MAPPINGS
    mapping(address => Validator) public validators;
    mapping(address => News) public newsList;
    
    // ARRAYS
    address[] validatorsList;
}