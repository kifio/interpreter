//
//  SymbolTableBuilder.swift
//  PascalInterpreter2
//
//  Created by Ivan Murashov on 30.01.2022.
//

class SymbolTableBuilder {
    
    private let symbolTable = SymbolTable()
        
    func visit(node: AST) throws {
        if let binaryOperation = node as? BinaryOperation {
            try visitBinaryOperation(binaryOperation)
        } else if let unaryOperation = node as? UnaryOperation {
            try visitUnaryOperation(unaryOperation)
        } else if let compound = node as? Compound {
            try visitCompound(compound)
        } else if let programm = node as? Programm {
            try visitProgramm(programm)
        } else if let block = node as? Block {
            try visitBlock(block)
        } else if let varDecl = node as? VarDecl {
            try visitVarDecl(varDecl)
        } else if let assign = node as? Assign {
            try visitAssign(assign)
        } else if let variable = node as? Var {
            try visitVar(variable)
        } else if node is NoOp || node is Number || node is VarType {

        } else {
            throw RuntimeError("Unexpected AST node! \(node)")
        }
    }
    
    private func visitBinaryOperation(_ binaryOperation: BinaryOperation) throws {
        try visit(node: binaryOperation.left)
        try visit(node: binaryOperation.right)
    }
    
    private func visitUnaryOperation(_ unaryOperation: UnaryOperation) throws {
        try visit(node: unaryOperation.value)
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
    
    private func visitVarDecl(_ varDecl: VarDecl) throws {
        let type: BuiltinTypeSymbol = symbolTable.lookup(varDecl.type.type) as! BuiltinTypeSymbol
        let name = varDecl.variable.name
        symbolTable.define(VarSymbol(name, type))
    }
    
    /// Верифицируем, что переменная объявлена
    private func visitAssign(_ assign: Assign) throws {
        let name = assign.left.name
        guard let _ = symbolTable.lookup(name) else {
            throw RuntimeError("Var \(name) is not defined")
        }
        
        try self.visit(node: assign.right)
    }

    /// Верифицируем, что переменная объявлена
    private func visitVar(_ variable: Var)  throws{
        let name = variable.name
        guard let _ = symbolTable.lookup(name) else {
            throw RuntimeError("Var \(name) is not defined")
        }
    }
    
    func build(_ ast: AST) throws -> SymbolTable {
        try visit(node: ast)
        return symbolTable
    }
}
