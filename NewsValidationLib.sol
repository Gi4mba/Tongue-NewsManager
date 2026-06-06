// SPDX-License-Identifier: MIT

pragma solidity >=0.8.3;

library NewsValidationLib {
    function getValidatorsCount(address[] storage _validators) internal view returns (uint256) {
        return _validators.length;
    }

    function isValidator(address[] storage _validators, address _target) internal view returns (bool) {
        for (
            uint256 i = 0; i < _validators.length; i++
        ) {
            if (_validators[i] == _target) return true;
        }
        return false;
    }

    function isNewsConfirmed(
        uint256 validationCount,
        uint256 minValidations,
        bool isConfirmed
    ) internal pure returns (bool) {
        return validationCount >= minValidations && isConfirmed;
    }
}

