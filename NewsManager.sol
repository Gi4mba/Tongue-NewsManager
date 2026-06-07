// SPDX-License-Identifier: MIT

pragma solidity >=0.8.3;

import "./NewsValidationLib.sol";

contract NewsManager {

    // ===== CUSTOM ERRORS =====

    // Admin
    error OnlyOwner();
    // Validators
    error ValidatorNotFound();
    error ValidatorAlreadyExists();
    error ValidatorNotActive();
    // News
    error NewsNotFound();
    error NewsExpired();
    error NewsNotConfirmed();
    error AlreadyValidated();
    // Rating
    error InvalidRating(uint8 vote);
    // Reward Pool
    error InsufficientBalance(uint256 required);
    

    // ===== EVENTS =====

    // Admin Actions
    event ValidatorAdded(address indexed _validator);
    event ValidatorRemoved(address indexed _validator);
    event RewardPoolToppedUp(address indexed _topper, uint256 _amount);
    // News Actions
    event NewsAdded(address indexed _newsId, string _newsName, uint256 _deadline);
    event NewsValidated(address indexed _newsId, address indexed _validator, uint8 _rating);
    event NewsConfirmed(address indexed _newsId);
    // Reward Actions
    event RewardDistributed(address indexed _validator, uint256 _amount);


    // ===== STRUCTS =====

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
    

    // ===== STATE VARIABLES =====

    address public owner;
    uint256 public totalDistributed;
    uint256 public rewardAmount;


    // ===== MAPPINGS =====

    mapping(address => Validator) public validators;
    mapping(address => News) public newsList;
    
    
    // ===== ARRAYS =====

    address[] validatorsList;

}