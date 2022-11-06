// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ByteHasher} from "./ByteHasher.sol";
import {IWorldID} from "./IWorldID.sol";
import "./UsingTellor.sol";

contract Contract is UsingTellor {
    using ByteHasher for bytes;

    ///////////////////////////////////////////////////////////////////////////////
    ///                                  ERRORS                                ///
    //////////////////////////////////////////////////////////////////////////////

    struct ENS {
        string name;
        address owner;
    }

    /// @notice Thrown when attempting to reuse a nullifier
    error InvalidNullifier();

    /// @dev The World ID instance that will be used for verifying proofs
    IWorldID internal immutable worldId;

    /// @dev The World ID group ID (always 1)
    uint256 internal immutable groupId = 1;

    /// @dev Whether a nullifier hash has been used already. Used to guarantee an action is only performed once by a single person
    mapping(uint256 => ENS) public nullifierHashes;

    /// @param _worldId The WorldID instance that will verify the proofs
    constructor(IWorldID _worldId, address payable _tellorAddress) UsingTellor(_tellorAddress) {
        worldId = _worldId;
    }

    /// @param signal An arbitrary input from the user, usually the user's wallet address (check README for further details)
    /// @param root The root of the Merkle tree (returned by the JS widget).
    /// @param nullifierHash The nullifier hash for this proof, preventing double signaling (returned by the JS widget).
    /// @param proof The zero-knowledge proof that demostrates the claimer is registered with World ID (returned by the JS widget).
    /// @dev Feel free to rename this method however you want! We've used `claim`, `verify` or `execute` in the past.
    function verifyAndExecute(
        address signal,
        uint256 root,
        uint256 nullifierHash,
        uint256[8] calldata proof,
        string memory _ens
    ) public {
        // First, we make sure this person hasn't done this before
        if (nullifierHashes[nullifierHash].owner != address(0)) revert InvalidNullifier();

        // We now verify the provided proof is valid and the user is verified by World ID
        worldId.verifyProof(
            root,
            groupId,
            abi.encodePacked(signal).hashToField(),
            nullifierHash,
            abi.encodePacked(address(this)).hashToField(),
            proof
        );

        //require here that user owns ENS NFT from readValue() connected to Trellor

        // We now record the user has done this, so they can't do it again (proof of uniqueness)
        nullifierHashes[nullifierHash] = ENS(_ens, msg.sender);
    }

    function toString(bytes memory data) public pure returns(string memory) {
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }

    function readValue() external view returns (uint256) {
        //build our queryData
        bytes memory queryData = abi.encode("NumericApiResponse", abi.encode(string.concat("https://api.covalenthq.com/v1/80001/address/", toString(abi.encodePacked(msg.sender)), "/balances_v2/?quote-currency=USD&format=JSON&nft=true&no-nft-fetch=false&key=ckey_79c997c7e8084e0f9df0af9824c", "items")));
        //hash it (build our queryId)
        bytes32 queryId = keccak256(queryData);
        //get our data
        (bytes memory value, uint256 timestamp) = getDataBefore(queryId, block.timestamp - 15 minutes);
        //decode our data
        return abi.decode(value, (uint256));
    }
}