// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Test } from "forge-std/Test.sol";
import { MerkleTree } from "../contracts/MerkleTree.sol";

contract MerkleTreeTest is Test {
    // solhint-disable-next-line var-name-mixedcase
    bytes32[] private LEAVES;
    bytes32 private root;

    function setUp() public {
        LEAVES = new bytes32[](5);
        LEAVES[0] = bytes32(uint256(0));
        LEAVES[1] = bytes32(uint256(1));
        LEAVES[2] = bytes32(uint256(2));
        LEAVES[3] = bytes32(uint256(3));
        LEAVES[4] = bytes32(uint256(4));

        root = MerkleTree.build(LEAVES);
    }

    function testMerkleProof() public {
        assertTrue(MerkleTree.verify(LEAVES, root, MerkleTree.ZERO_BLOCK));
    }

    function testNonMatching() public {
        bytes32[] memory altProof = new bytes32[](2);
        altProof[0] = bytes32(uint256(0));
        altProof[1] = bytes32(uint256(1));
        assertFalse(MerkleTree.verify(altProof, root, MerkleTree.ZERO_BLOCK));
        LEAVES[3] = bytes32(uint256(5));
        assertFalse(MerkleTree.verify(LEAVES, root, MerkleTree.ZERO_BLOCK));
    }

    function testNewLeaf() public {
        bytes32 zero = bytes32(uint256(0));
        assertFalse(MerkleTree.verify(LEAVES, root, zero));
    }
}
