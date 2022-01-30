//
//  AST.swift
//  PascalInterpreter2
//
//  Created by Ivan Murashov on 30.01.2022.
//

/// Базовый класс узла абстрактного синтаксического дерева
class AST : CustomStringConvertible {
    public var description: String { return "" }
}

/// Представление всей программы в AST
class Programm : AST {
    let name: String
    let block: Block
    
    init(_ name: String, _ block: Block) {
        self.name = name
        self.block = block
    }
    
    public override var description: String { return "\(name)" }
}

/// Представление списка объявлений и главного блока программы  в AST
class Block : AST {
    let declarations: [VarDecl]
    let compoundStatement: AST
    
    init(_ declarations: [VarDecl], _ compoundStatement: AST) {
        self.declarations = declarations
        self.compoundStatement = compoundStatement
    }
}

/// BEGIN ... END
class Compound : AST {
    let statements: [AST]
    
    init(_ statements: [AST]) {
        self.statements = statements
    }
}

/// Представление имени переменной в AST
class Var : AST {
    let token: Token
    var name: String {
        get {
            return token.value
        }
    }
    
    init(_ token: Token) {
        self.token = token
    }
    
    public override var description: String { return "\(name)" }
}

/// Представление типа переменной в AST
class VarType: AST {
    let token: Token
    var type: String {
        get {
            return token.value
        }
    }
    
    init(_ token: Token) {
        self.token = token
    }
    
    public override var description: String { return "\(type)" }
}

/// Представление объявления переменной в AST
class VarDecl : AST {
    let variable : Var
    let type: VarType
    
    init(_ variable: Var, _ type: VarType) {
        self.variable = variable
        self.type = type
    }
    
    public override var description: String { return "\(variable)" }
}

/// Представление присваивания в AST
class Assign : AST {
    let left: Var
    let right: AST
    
    init(_ left: Var, _ right: AST) {
        self.left = left
        self.right = right
    }
    
    public override var description: String { return "\(left)\(right)" }
}

/// Представление числа в аст
class Number : AST {
    let token: Token
    let value: Double
    
    init(_ token: Token) {
        self.token = token
        self.value =  Double(token.value)!
    }
    
    public override var description: String { return "\(value)" }
}

/// Представление бинарной операции в аст
class BinaryOperation : AST {
    let left: AST
    let op: Token
    let right: AST
    
    init(_ left: AST, _ op: Token, _ right: AST) {
        self.left = left
        self.op = op
        self.right = right
    }
    
    public override var description: String { return "\(left)\(op)\(right)" }
    
}

// Представление унарной операции в аст
class UnaryOperation : AST {
    let op: Token
    let value: AST
    
    init(_ op: Token, _ value: AST) {
        self.value = value
        self.op = op
    }
    
    public override var description: String { return "\(op)\(value)" }
}

class NoOp : AST {
    
}
