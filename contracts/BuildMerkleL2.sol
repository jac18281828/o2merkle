// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

// solhint-disable const-name-snakecase
// solhint-disable immutable-vars-naming

import { ICrossDomainMessenger } from "@eth-optimism/contracts/libraries/bridge/ICrossDomainMessenger.sol";
import { StandardBridge } from "./StandardBridge.sol";
import { MerkleTree } from "./MerkleTree.sol";
import { MerkleProof } from "./MerkleProof.sol";

contract BuildMerkleL2 {
    uint32 public constant L1_GAS_LIMIT = 1000000;

    // MerkleProof.sol on Görli testnet
    address public constant L1_MERKLE = 0xB9f39DF9C81f014531Ec9C2fA03820813Be2B423;

    /// The L2 Bridge has a standard address
    address public constant L2_BRIDGE = 0x4200000000000000000000000000000000000010;

    StandardBridge public constant l2Bridge = StandardBridge(L2_BRIDGE);
    ICrossDomainMessenger public immutable xDomainMessenger;

    constructor() {
        xDomainMessenger = ICrossDomainMessenger(l2Bridge.MESSENGER());
    }

    function build(bytes32[] memory leaves) public {
        bytes32 root = MerkleTree.build(leaves);
        _setRoot(root);
    }

    function build(bytes32[] memory leaves, bytes32 leaf) public {
        bytes32 root = MerkleTree.build(leaves, leaf);
        _setRoot(root);
    }

    function _setRoot(bytes32 _root) internal {
        bytes memory callData = abi.encodeWithSelector(MerkleProof.setRoot.selector, _root);
        xDomainMessenger.sendMessage(L1_MERKLE, callData, L1_GAS_LIMIT);
    }
}
