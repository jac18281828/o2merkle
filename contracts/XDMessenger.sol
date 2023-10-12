// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

/**
 * @title XDMessenger
 * @dev XDMessenger is an interface for sending messages to eth mainnet via the op cross domain messenger
 */
interface XDMessenger {
    /// see here: https://github.com/ethereum-optimism/optimism/blob/develop/packages/contracts-bedrock/src/universal/CrossDomainMessenger.sol
    function sendMessage(address _target, bytes calldata _message, uint32 _minGasLimit) external payable;

    function xDomainMessageSender() external returns (address);
}
