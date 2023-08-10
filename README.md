# Solidity Safe External Storage

`SafeExternalStorage` is a solidity contract which stores arbitrary account-scoped data. It allows storage for an account to be locked within a transaction, enabling contracts which permit arbitrary delegatecall operations to protect against storage collision attacks.

Inspired by Uniswap v4's [extsload](https://github.com/Uniswap/v4-core/blob/3b724503d4c3fa4872ac0b4f9b12f694774224a4/contracts/PoolManager.sol#L397) pattern.
