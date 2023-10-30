// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.15;

import { MerkleTree } from "./MerkleTree.sol";

import { ICrossDomainMessenger } from "@eth-optimism/contracts/libraries/bridge/ICrossDomainMessenger.sol";

contract MerkleProof {
    error OnlyOwner();

    address public constant XDM_ADDR = 0x5086d1eEF304eb5284A0f6720f79403b4e9bE294;

    bytes32 public root;

    address public owner;

    // In a real-world example, this root might be set during contract deployment or via some management function.
    constructor() {
        root = MerkleTree.ZERO_BLOCK;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            if (msg.sender == XDM_ADDR) {
                ICrossDomainMessenger xDmessenger = ICrossDomainMessenger(XDM_ADDR);
                if (xDmessenger.xDomainMessageSender() != owner) revert OnlyOwner();
            } else if (msg.sender != owner) {
                revert OnlyOwner();
            }
        }
        _;
    }

    function setRoot(bytes32 _root) public onlyOwner {
        root = _root;
    }

    function verify(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
        return MerkleTree.verify(proof, root, leaf);
    }
}
