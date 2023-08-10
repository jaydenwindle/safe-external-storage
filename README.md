# Solidity Safe External Storage

`SafeExternalStorage` is a solidity contract which stores arbitrary account-scoped data. It allows storage for an account to be locked within a transaction, enabling contracts which permit arbitrary delegatecall operations to protect against storage collision attacks.

## Installation
```bash
$ forge install jaydenwindle/safe-external-storage
```

## Usage
```solidity

address caller = 0x...;
bytes32 slot = bytes32(0);
bytes32 value = bytes32(uint256(1));

SafeExternalStorage extStorage = new SafeExternalStorage();

// Store data scoped by sender address
extStorage.extsstore(slot, value);

// Query data by address scope
bytes32 value = extStorage.extsload(caller, slot)

// Lock storage (future calls to extsstore within the same transaction will revert)
extStorage.lock();
extStorage.extsstore(slot, value); // Revert: StorageLocked()
```

Inspired by Uniswap v4's [extsload](https://github.com/Uniswap/v4-core/blob/3b724503d4c3fa4872ac0b4f9b12f694774224a4/contracts/PoolManager.sol#L397) pattern.
