// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InsertExtraDataIntoBaseMulticall
/// @notice Utility contract to append additional calls to a base multicall bytes[]
contract InsertExtraDataIntoBaseMulticall {
    address public immutable ERC20ExecuteOperationsAddress;

    /// @notice Constructor to initialize the ERC20ExecuteOperations address
    /// @param erc20ExecuteOperationsAddress The address of the ERC20ExecuteOperations contract
    constructor(address erc20ExecuteOperationsAddress) {
        ERC20ExecuteOperationsAddress = erc20ExecuteOperationsAddress;
    }

    /// @notice Appends an `approveMax` call to an existing multicall array
    /// @param multicall The existing multicall data array
    /// @return updatedMulticall The updated multicall array with the `approveMax` call appended
    function insertApproveMaxIntoBaseMulticall(bytes[] memory multicall) 
        public 
        view 
        returns (bytes[] memory updatedMulticall) 
    {
        // Encode the `approveMax` call
        bytes memory approveMaxCall = abi.encodeWithSignature(
            "approveMax(address)",
            ERC20ExecuteOperationsAddress
        );

        // Create a new array for the updated multicall
        updatedMulticall = new bytes[](multicall.length + 1);

        // Copy existing multicall data into the new array
        for (uint256 i = 0; i < multicall.length; i++) {
            updatedMulticall[i] = multicall[i];
        }

        // Append the `approveMax` call to the new array
        updatedMulticall[multicall.length] = approveMaxCall;
    }

    /// @notice Appends a `selfPermit` call with zero values to an existing multicall array
    /// @param multicall The existing multicall data array
    /// @return updatedMulticall The updated multicall array with the `selfPermit` call appended
    function insertSelfPermitIntoBaseMulticall(bytes[] memory multicall) 
        public 
        view 
        returns (bytes[] memory updatedMulticall) 
    {
        // Encode the `selfPermit` call with zero values
        bytes memory selfPermitCall = abi.encodeWithSignature(
            "selfPermit(address,uint256,uint256,uint8,bytes32,bytes32)",
            ERC20ExecuteOperationsAddress, // Token address
            uint256(0),                    // Zero value for approval amount
            uint256(0),                    // Zero value for deadline
            uint8(0),                      // Zero value for `v`
            bytes32(0),                    // Zero value for `r`
            bytes32(0)                     // Zero value for `s`
        );

        // Create a new array for the updated multicall
        updatedMulticall = new bytes[](multicall.length + 1);

        // Copy existing multicall data into the new array
        for (uint256 i = 0; i < multicall.length; i++) {
            updatedMulticall[i] = multicall[i];
        }

        // Append the `selfPermit` call to the new array
        updatedMulticall[multicall.length] = selfPermitCall;
    }
}
