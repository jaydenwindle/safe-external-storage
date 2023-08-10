// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../../src/SafeExternalStorage.sol";

contract MockStorageSetter {
    SafeExternalStorage public extStorage;

    constructor(address _extStorage) {
        extStorage = SafeExternalStorage(_extStorage);
    }

    function store(bytes32 slot, bytes32 value) external {
        extStorage.extsstore(slot, value);
    }
}
