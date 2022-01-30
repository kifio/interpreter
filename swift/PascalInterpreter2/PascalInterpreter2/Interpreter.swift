//
//  Interpreter.swift
//  PascalInterpreter2
//
//  Created by Ivan Murashov on 30.01.2022.
//

/// Интерпретирует AST
class Interpreter {
    
    /// По хорошему надо создать обертку для Int и Double и хранить все рещультаты арифметики в ней.
    private var runtimeMemory = [String:Double]()
    
    func visit(node: AST) throws -> Double {
        if let binaryOperation = node as? BinaryOperation {
            return try visitBinaryOperation(binaryOperation)
        } else if let number = node as? Number {
            return visitNumber(number)
        } else if let unaryOperation = node as? UnaryOperation {
            return try visitUnaryOperation(unaryOperation)
        } else if let compound = node as? Compound {
            try visitCompound(compound)
            return 0
        } else if let assign = node as? Assign {
            try visitAssign(assign: assign)
            return 0
        } else if let variable = node as? Var {
            return try visitVar(variable: variable)
        } else if let programm = node as? Programm {
            try visitProgramm(programm)
            return 0
        } else if let block = node as? Block {
            try visitBlock(block)
            return 0
        } else if node is NoOp || node is VarDecl || node is VarType {
            return 0
        } else {
            throw RuntimeError("Unexpected AST node! \(node)")
        }
    }
    
    private func visitBinaryOperation(_ binaryOperation: BinaryOperation) throws -> Double {
        switch (binaryOperation.op.type) {
        case .plus:
            let left = try visit(node: binaryOperation.left)
            let right = try visit(node: binaryOperation.right)
            return Double(left + right)
        case .multiply:
            let left = try visit(node: binaryOperation.left)
            let right = try visit(node: binaryOperation.right)
            return Double(left * right)
        case .minus:
            let left = try visit(node: binaryOperation.left)
            let right = try visit(node: binaryOperation.right)
            return Double(left - right)
        case .real_div:
            let left = try visit(node: binaryOperation.left)
            let right = try visit(node: binaryOperation.right)
            return Double(left) / Double(right)
        case .integer_div:
            let left = try visit(node: binaryOperation.left)
            let right = try visit(node: binaryOperation.right)
            return Double(Int(left) / Int(right))
        default:
            throw RuntimeError("Unsupported binary operation \(binaryOperation.op.type)!")
        }
    }
    
    private func visitUnaryOperation(_ unaryOperation: UnaryOperation) throws -> Double {
        switch (unaryOperation.op.type) {
        case .plus: return try visit(node: unaryOperation.value)
        case .minus: return try -visit(node: unaryOperation.value)
        default: throw RuntimeError("Unsupported unary operation \(unaryOperation.op.type)!")
        }
    }
    
    private func visitNumber(_ number: Number) -> Double {
        return number.value
    }
    
    private func visitCompound(_ compoundAST: Compound) throws {
        try compoundAST.statements.forEach {
            try visit(node: $0)
        }
    }
    
    private func visitProgramm(_ programm: Programm) throws {
        try visit(node: programm.block)
    }
    
    private func visitBlock(_ block: Block) throws {
        try block.declarations.forEach { try visit(node: $0) }
        try visit(node: block.compoundStatement)
    }

    private func visitAssign(assign: Assign) throws {
        self.runtimeMemory[assign.left.name.lowercased()] = try visit(node: assign.right)
    }
    
    private func visitVar(variable: Var) throws -> Double {
        guard let value = runtimeMemory[variable.name.lowercased()] else {
            throw RuntimeError("Symbol table doesn't contains \(variable.name)!")
        }
        return value
    }
}
