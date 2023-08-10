// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SafeExternalStorage.sol";
import "./mocks/MockDelegateCaller.sol";
import "./mocks/MockStorageSetter.sol";

contract SafeExternalStorageTest is Test {
    SafeExternalStorage public extStorage;
    MockDelegateCaller public delegateCaller;
    MockStorageSetter public storageSetter;

    function setUp() public {
        extStorage = new SafeExternalStorage();
        delegateCaller = new MockDelegateCaller(address(extStorage));
        storageSetter = new MockStorageSetter(address(extStorage));
    }

    function testCanStoreAndQueryExternalData() public {
        bytes32 slot = bytes32(0);
        bytes32 value = bytes32(uint256(1));
        address scope = vm.addr(1);

        vm.prank(scope);
        extStorage.extsstore(slot, value);

        assertEq(extStorage.extsload(scope, slot), value);
    }

    function testExternalDataScopedBySender() public {
        bytes32 slot = bytes32(0);
        bytes32 value = bytes32(uint256(1));
        address scope1 = vm.addr(1);
        address scope2 = vm.addr(2);

        vm.prank(scope1);
        extStorage.extsstore(slot, value);

        assertEq(extStorage.extsload(scope1, slot), value);
        assertEq(extStorage.extsload(scope2, slot), bytes32(0));
    }

    function testCannotStoreDataWhileLocked() public {
        bytes32 slot = bytes32(0);
        bytes32 value = bytes32(uint256(1));
        address scope = vm.addr(1);

        // lock storage within current block
        vm.prank(scope);
        extStorage.lock();
        assertEq(extStorage.locked(scope), true);

        // cannot store data if storage is locked
        vm.prank(scope);
        vm.expectRevert(SafeExternalStorage.StorageLocked.selector);
        extStorage.extsstore(slot, value);
        assertEq(extStorage.extsload(scope, slot), bytes32(0));

        // can store data in subsequent blocks
        vm.roll(block.number + 1);
        vm.prank(scope);
        extStorage.extsstore(slot, value);
        assertEq(extStorage.extsload(scope, slot), value);
    }

    function testCannotStoreDataWithinDelegatecall() public {
        bytes32 slot = bytes32(0);
        bytes32 value = bytes32(uint256(1));

        // storage cannot be set using delegatecall when scope is locked
        (bool success, bytes memory result) = delegateCaller.execute(
            address(storageSetter),
            abi.encodeWithSignature("store(bytes32,bytes32)", slot, value)
        );

        assertEq(success, false);
        assertEq(bytes4(result), SafeExternalStorage.StorageLocked.selector);
    }
}
