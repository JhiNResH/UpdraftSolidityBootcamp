// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { SimpleStorage } from "./SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage{
    // +5
    // overrides
    // virtual lets contracts to be overridable
    function store(uint256 _newNumber) public override {
        myFavoriteNumber = _newNumber + 5;
    }
    }