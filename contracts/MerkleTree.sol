// SPDX-License-Identifier: BSD-3-Clause
// solhint-disable one-contract-per-file
pragma solidity ^0.8.15;

library MerkleTree {
    error EmptyTree();

    bytes32 public constant ZERO_BLOCK = keccak256(abi.encode(uint256(0)));

    /**
     * @dev build a merkle tree from a list of leaves
     * @param leaves the list of leaves
     * @return bytes32 the root of the merkle tree
     */
    function build(bytes32[] memory leaves) internal pure returns (bytes32) {
        return build(leaves, ZERO_BLOCK);
    }

    /**
     * @dev build a merkle tree from a list of leaves
     * @param leaves the list of leaves
     * @param leaf the starting leaf for the tree
     * @return bytes32 the root of the merkle tree
     */
    function build(bytes32[] memory leaves, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < leaves.length; i++) {
            bytes32 proofElement = leaves[i];

            if (computedHash <= proofElement) {
                // Hash(current computed hash + current element of the proof)
                computedHash = keccak256(abi.encode(computedHash, proofElement));
            } else {
                // Hash(current element of the proof + current computed hash)
                computedHash = keccak256(abi.encode(proofElement, computedHash));
            }
        }

        // return the computed hash
        return computedHash;
    }

    /**
     * @dev Verify a Merkle proof proving the existence of a leaf in a Merkle tree.
     * @param proof Merkle proof containing sibling hashes on the branch from the leaf to the root of the Merkle tree
     * @param root Merkle root
     * @param leaf Leaf item
     */
    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        bytes32 computedHash = build(proof, leaf);

        // Check if the computed hash (root) is equal to the provided root
        return computedHash == root;
    }
}
