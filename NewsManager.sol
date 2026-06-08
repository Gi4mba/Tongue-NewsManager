// SPDX-License-Identifier: MIT

pragma solidity >=0.8.3;

import "./NewsValidationLib.sol";

contract NewsManager {

    // ===== CUSTOM ERRORS =====
    error OnlyOwner();
    
    error ValidatorNotFound(address validator);
    error ValidatorAlreadyExists(address validator);
    error ValidatorNotActive(address validator);
    
    error NewsNotFound(address newsId);
    error NewsExpired(address newsId);
    error DeadlineTooSoon();
    error NewsNotConfirmed(address newsId);
    error AlreadyValidated(address validator, address newsId);
    
    error InvalidRating(uint8 vote);
    
    error InsufficientAmount();
    error InsufficientBalance();
    

    // ===== EVENTS =====
    event ValidatorAdded(address indexed validator);
    event ValidatorRemoved(address indexed validator);
    event RewardPoolToppedUp(address indexed topper, uint256 amount);
    
    event NewsAdded(address indexed newsId, string newsName, uint256 deadline);
    event NewsValidated(address indexed newsId, address indexed validator, uint8 rating);
    event NewsConfirmed(address indexed newsId);
    
    event RewardDistributed(address indexed validator, uint256 amount);


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

    
    // ===== MAPPINGS =====
    mapping(address => Validator) public validators;
    mapping(address => News) public newsList;
    
    
    // ===== ARRAYS =====
    address[] public validatorsList;


    // ===== STATE VARIABLES =====
    address public owner;
    uint256 public totalDistributed;
    uint256 public rewardAmount;


    // ===== CONSTRUCTOR =====
    constructor(uint256 _rewardAmount) {
        owner = msg.sender;
        rewardAmount = _rewardAmount;
        totalDistributed = 0;
    }


    // ===== MODIFIERS =====
    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }


    // ===== CORE LOGIC =====
    // ===== ADMIN FUNCTIONS =====
    function addValidator(address _validator) external onlyOwner {
        if (NewsValidationLib.isValidator(validatorsList, _validator)) {
            revert ValidatorAlreadyExists(_validator);
        }

        validators[_validator].isActive = true;
        validatorsList.push(_validator);
        emit ValidatorAdded(_validator);
    }

    function removeValidator(address _validator) external onlyOwner {
        if (!NewsValidationLib.isValidator(validatorsList, _validator) ||
        !validators[_validator].isActive) {
            revert ValidatorNotFound(_validator);
        }

        validators[_validator].isActive = false;
        emit ValidatorRemoved(_validator);
    }

    function topUpRewardPool() external payable onlyOwner {
        if (msg.value == 0) revert InsufficientAmount();

        emit RewardPoolToppedUp(msg.sender, msg.value);
    }


    // ===== NEWS FUNCTIONS =====
    function addNews(
        address _newsId,
        string calldata _newsName,
        uint256 _deadline
    ) external {
        if (_deadline <= block.timestamp)
        revert NewsExpired(_newsId);

        if (_deadline < block.timestamp + 1 days)
        revert DeadlineTooSoon();

        newsList[_newsId] = News(
            msg.sender,
            _newsName,
            _deadline,
            5,
            false,
            0,
            new address[](0)
        );

        emit NewsAdded(_newsId, _newsName, _deadline);
    }
}