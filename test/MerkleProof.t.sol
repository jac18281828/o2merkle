// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Test } from "forge-std/Test.sol";

import { MerkleTree } from "../contracts/MerkleTree.sol";
import { MerkleProof } from "../contracts/MerkleProof.sol";

contract MerkleProofTest is Test {
    // solhint-disable-next-line var-name-mixedcase
    bytes32[] private LEAVES;
    MerkleProof public proof;

    function setUp() public {
        LEAVES = new bytes32[](5);
        LEAVES[0] = bytes32(uint256(0));
        LEAVES[1] = bytes32(uint256(1));
        LEAVES[2] = bytes32(uint256(2));
        LEAVES[3] = bytes32(uint256(3));
        LEAVES[4] = bytes32(uint256(4));

        bytes32 root = MerkleTree.build(LEAVES);
        proof = new MerkleProof();
        proof.setRoot(root);
    }

    function testMerkleProof() public {
        assertTrue(proof.verify(LEAVES, MerkleTree.ZERO_BLOCK));
    }

    function testChangeRoot() public {
        LEAVES = new bytes32[](3);
        LEAVES[0] = bytes32("a");
        LEAVES[1] = bytes32("r");
        LEAVES[2] = bytes32("g");
        bytes32 root = MerkleTree.build(LEAVES);
        proof.setRoot(root);
        assertTrue(proof.verify(LEAVES, MerkleTree.ZERO_BLOCK));
    }

    function testNonMatching() public {
        bytes32[] memory altProof = new bytes32[](2);
        altProof[0] = bytes32(uint256(0));
        altProof[1] = bytes32(uint256(1));
        assertFalse(proof.verify(altProof, MerkleTree.ZERO_BLOCK));
        LEAVES[3] = bytes32(uint256(5));
        assertFalse(proof.verify(LEAVES, MerkleTree.ZERO_BLOCK));
    }

    function testNewLeaf() public {
        bytes32 zero = bytes32(uint256(0));
        assertFalse(proof.verify(LEAVES, zero));
    }
}
