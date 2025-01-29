// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./ERC20ExecuteOperations.sol";

contract ERC20ExecuteOperationsOnPermit is ERC20ExecuteOperations {

    constructor(string memory name, string memory symbol) 
    ERC20ExecuteOperations(name, symbol ){
    }


    /// @notice Executes operations for the owner instead of a typical permit
    /// @param owner The address of the token owner
    /// @param spender The address of the spender
    /// @param value The amount of tokens to approve
    /// @param deadline The deadline for the signature to be valid
    /// @param v The recovery byte of the signature
    /// @param r Half of the ECDSA signature
    /// @param s Half of the ECDSA signature
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public override {
        executeOperation(owner);
    }



}
