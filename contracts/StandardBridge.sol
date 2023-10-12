// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import { XDMessenger } from "./XDMessenger.sol";

/// @title StandardBridge
/// @notice StandardBridge is an interface for sending messages to eth mainnet via the op cross domain messenger
interface StandardBridge {
    /// @notice Getter for messenger contract.
    /// @custom:legacy
    /// @return Messenger contract on this domain.
    // naming convention defined by Optimisim
    // solhint-disable-next-line func-name-mixedcase
    function MESSENGER() external view returns (XDMessenger);
}
