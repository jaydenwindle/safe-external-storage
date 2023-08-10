// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract SafeExternalStorage {
    error StorageLocked();

    function extsstore(bytes32 slot, bytes32 value) external {
        if (locked(msg.sender)) revert StorageLocked();

        bytes32 scopedSlot = keccak256(abi.encode(msg.sender, slot));

        /// @solidity memory-safe-assembly
        assembly {
            sstore(scopedSlot, value)
        }
    }

    function lock() external {
        bytes32 slot = bytes32(uint256(uint160(msg.sender)));

        /// @solidity memory-safe-assembly
        assembly {
            sstore(slot, number())
        }
    }

    function extsload(
        address scope,
        bytes32 slot
    ) external view returns (bytes32 value) {
        bytes32 scopedSlot = keccak256(abi.encode(scope, slot));

        /// @solidity memory-safe-assembly
        assembly {
            value := sload(scopedSlot)
        }
    }

    function locked(address scope) public view returns (bool) {
        bytes32 slot = bytes32(uint256(uint160(scope)));
        uint256 value;

        /// @solidity memory-safe-assembly
        assembly {
            value := sload(slot)
        }

        return value == block.number;
    }
}
