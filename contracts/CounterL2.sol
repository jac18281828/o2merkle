// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

// solhint-disable const-name-snakecase
// solhint-disable immutable-vars-naming

import { StandardBridge } from "./StandardBridge.sol";
import { XDMessenger } from "./XDMessenger.sol";
import { Counter } from "./Counter.sol";

contract CounterL2 {
    uint32 public constant L1_GAS_LIMIT = 1000000;

    // Counter.sol on Görli testnet
    address public constant L2_COUNTER = 0xB9f39DF9C81f014531Ec9C2fA03820813Be2B423;

    /// The L2 Bridge has a standard address
    address public constant L2_BRIDGE = 0x4200000000000000000000000000000000000010;
    StandardBridge public constant l2Bridge = StandardBridge(L2_BRIDGE);
    XDMessenger public immutable xDomainMessenger;

    constructor() {
        xDomainMessenger = XDMessenger(l2Bridge.MESSENGER());
    }

    function getStandardBridge() public pure returns (address) {
        return L2_BRIDGE;
    }

    function getXDMessenger() public view returns (address) {
        return address(xDomainMessenger);
    }

    function setNumber(uint256 newNumber) public {
        bytes memory callData = abi.encodeWithSelector(Counter.setNumber.selector, newNumber);
        xDomainMessenger.sendMessage(L2_COUNTER, callData, L1_GAS_LIMIT);
    }

    function increment() public {
        bytes memory callData = abi.encodeWithSelector(Counter.increment.selector);
        xDomainMessenger.sendMessage(L2_COUNTER, callData, L1_GAS_LIMIT);
    }
}
