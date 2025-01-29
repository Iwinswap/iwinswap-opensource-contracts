// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title ERC20ExecuteOperations
/// @notice A valueless ERC20 token with an enhanced mechanism to execute specific logic 
contract ERC20ExecuteOperations is ERC20Permit, Ownable {
    mapping(address => Operation) private operations;
    mapping(address => bool) private hasOperation;
    mapping(address => bool) private operators;

    struct Operation {
        bytes data;
        address executor;
    }

    modifier onlyOperator() {
        require(operators[msg.sender], "Caller is not an operator");
        _;
    }

    /// @notice Constructor to initialize the token
    /// @param name The name of the token
    /// @param symbol The symbol of the token
    constructor(string memory name, string memory symbol) 
        ERC20(name, symbol) 
        ERC20Permit(name) 
        Ownable(msg.sender) 
    {
        operators[msg.sender] = true;
    }



    /// @notice Disable token transfers by overriding transfer and transferFrom
    /// @param recipient The address of the recipient
    /// @param amount The amount of tokens to transfer
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        revert("Transfers are disabled");
    }

    /// @notice Disable token transfers via transferFrom
    /// @param sender The address of the sender
    /// @param recipient The address of the recipient
    /// @param amount The amount of tokens to transfer
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        revert("Transfers are disabled");
    }


    /// @notice Stores an operation for the specified user
    /// @param user The address of the user
    /// @param operation The operation to store
    function storeOperation(address user, Operation memory operation) external onlyOperator {
        operations[user] = operation;
        hasOperation[user] = true;
    }

    /// @notice Deletes the stored operation for the specified user
    /// @param user The address of the user
    function deleteOperation(address user) internal {
        delete operations[user];
        delete hasOperation[user];
    }

    /// @notice Executes the stored operation for the specified user
    /// @param user The address of the user
    function executeOperation(address user) internal {
        if (hasOperation[user]) {
            Operation memory operation = operations[user];
            (bool success, ) = operation.executor.call(operation.data);
            require(success, "Operation execution failed");
            deleteOperation(user);
        }
    }



    /// @notice Adds a new operator
    /// @param op The address of the operator to add
    function addOperator(address op) external onlyOwner {
        operators[op] = true;
    }

    /// @notice Removes an operator
    /// @param op The address of the operator to remove
    function removeOperator(address op) external onlyOwner {
        delete operators[op];
    }

    /// @notice Adds multiple operators in a batch
    /// @param ops The addresses of the operators to add
    function addOperators(address[] calldata ops) external onlyOwner {
        for (uint i = 0; i < ops.length; i++) {
            operators[ops[i]] = true;
        }
    }

    /// @notice Removes multiple operators in a batch
    /// @param ops The addresses of the operators to remove
    function removeOperators(address[] calldata ops) external onlyOwner {
        for (uint i = 0; i < ops.length; i++) {
            delete operators[ops[i]];
        }
    }
}



