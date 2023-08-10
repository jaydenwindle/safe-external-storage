// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../../src/SafeExternalStorage.sol";

contract MockDelegateCaller {
    SafeExternalStorage public extStorage;

    constructor(address _extStorage) {
        extStorage = SafeExternalStorage(_extStorage);
    }

    function execute(
        address to,
        bytes calldata data
    ) external returns (bool success, bytes memory result) {
        extStorage.lock();
        (success, result) = to.delegatecall(data);
    }
}
