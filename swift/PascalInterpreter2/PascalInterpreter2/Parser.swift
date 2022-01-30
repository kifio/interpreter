//
//  Parser.swift
//  PascalInterpreter2
//
//  Created by Ivan Murashov on 30.01.2022.
//

// Парсит последовательность токенов в AST
class Parser {
    let lexer: Lexer
    var currentToken: Token!
    
    init(lexer: Lexer) {
        self.lexer = lexer
    }
    
    func parse() throws -> AST {
        let result = try programm()
        
        if currentToken.type != TokenType.eof {
            throw RuntimeError("Unexpected token type! Current token: \(currentToken.type)")
        }
        
        return result
    }
    
    /// program : compound_statement DOT
    private func programm() throws -> Programm {
        try currentToken = lexer.getNextToken()
        
        guard currentToken.type == .programm else {
            throw RuntimeError("Incorrect programm")
        }
        
        try getNextToken(.programm)
        let programName = currentToken.value
        try getNextToken(.variable)
        let programm = Programm(programName, try block())
        try getNextToken(TokenType.dot)
        return programm
    }
    
    private func block() throws -> Block {
        let declarations = try declarations()
        let compoundStatement = try compoundStatement()
        return Block(declarations, compoundStatement)
    }
    
    /**
     declarations : VAR (variable_declaration SEMI)+
                | empty
     */
    private func declarations() throws -> [VarDecl] {
        try getNextToken(.semicolon)
        
        var varDeclarations = [VarDecl]()
        
        guard currentToken.type == .variable_block else {
            return varDeclarations
        }
        
        try getNextToken(.variable_block)
        varDeclarations.append(contentsOf: try variableDeclaration())
        
        while (currentToken.type == .semicolon) {
            try getNextToken(.semicolon)
            
            if currentToken.type == .variable {
                varDeclarations.append(contentsOf: try variableDeclaration())
            }
        }
        
        return varDeclarations
    }
    
    /**
     variable_declaration : ID (COMMA ID)* COLON type_spec
     */
    private func variableDeclaration() throws -> [VarDecl] {
        var variables = [Var]()
        
        variables.append(Var(currentToken))
        try getNextToken(TokenType.variable)

        while (currentToken.type == TokenType.comma) {
            try getNextToken(TokenType.comma)
            variables.append(Var(currentToken))
            try getNextToken(TokenType.variable)
        }
        
        try getNextToken(TokenType.colon)
        
        let declarations = variables.map { VarDecl($0, VarType(currentToken)) }
        
        if currentToken.type == .integer_type {
            try getNextToken(.integer_type)
        } else if currentToken.type == .real_type {
            try getNextToken(.real_type)
        }
            
        return declarations
    }
    
    /// type_spec : INTEGER | REAL
    private func typeSpec() throws -> VarType {
        let type = VarType(currentToken)
        switch (currentToken.type) {
        case .integer_type: try getNextToken(TokenType.integer_type)
        case .real_type: try getNextToken(TokenType.real_type)
        default: throw RuntimeError("Unknown variable type")
        }
        return type
    }
    
    /// compound_statement: BEGIN statement_list END
    private func compoundStatement() throws -> Compound {
        if currentToken.type == TokenType.begin {
            return try Compound(statements())
        }
        
        throw RuntimeError("Unexpected token type! Current token: \(currentToken.description)")
    }
    
    /// statement_list : statement | statement SEMI statement_list
    private func statements() throws -> [AST] {
        try getNextToken(TokenType.begin)

        var statements = [AST]()
        
        statements.append(try statement())
        
        while currentToken.type == TokenType.semicolon {
            try getNextToken(TokenType.semicolon)
            statements.append(try statement())
        }
        
        if currentToken.type != TokenType.end {
            throw RuntimeError("Unexpected token type! Current token: \(currentToken.description)")
        } else {
            try getNextToken(TokenType.end)
        }
        
        return statements
    }
    
    /// statement : compound_statement | assignment_statement | empty
    private func statement() throws -> AST {
        if currentToken.type == TokenType.begin {
            return try compoundStatement()
        } else if currentToken.type == TokenType.variable {
            return try assignStatement()
        } else {
            return NoOp()
        }
    }
    
    /// assignment_statement : variable ASSIGN expr
    private func assignStatement() throws -> Assign {
        let variable: Var = Var(currentToken)
        try getNextToken(TokenType.variable)
        try getNextToken(TokenType.assign)
        return try Assign(variable, expr())
    }
    
    /**
     expr   : term ((PLUS | MINUS) term)*
     term   : factor ((MUL | DIV) factor)*
     factor : INTEGER | LPAREN expr RPAREN
     */
    private func expr() throws -> AST {
        var left: AST = try term()
        
        while currentToken.type == TokenType.plus || currentToken.type == TokenType.minus {
            let op: Token = currentToken
            if op.type == TokenType.plus {
                try getNextToken(TokenType.plus)
                left = BinaryOperation(left, op, try term())
            } else if op.type == TokenType.minus {
                try getNextToken(TokenType.minus)
                left = BinaryOperation(left, op, try term())
            }
        }
        
        return left
    }
    
    /// term : factor ((MUL | DIV) factor)*
    private func term() throws -> AST {
        var left: AST = try factor()
        
        while currentToken.type == TokenType.multiply || currentToken.type == TokenType.real_div || currentToken.type == TokenType.integer_div  {
            let op: Token = currentToken
            if op.type == TokenType.multiply {
                try getNextToken(TokenType.multiply)
                left = BinaryOperation(left, op, try factor())
            } else if op.type == TokenType.real_div {
                try getNextToken(TokenType.real_div)
                left = BinaryOperation(left, op, try factor())
            } else if op.type == TokenType.integer_div {
                try getNextToken(TokenType.integer_div)
                left = BinaryOperation(left, op, try factor())
            }
        }
        
        return left
    }
    
    /**
     factor : PLUS  factor
                   | MINUS factor
                   | INTEGER
                   | LPAREN expr RPAREN
                   | variable
     */
    private func factor() throws -> AST {
        if currentToken.type == TokenType.plus {
            let sign: Token = currentToken
            try getNextToken(TokenType.plus)
            return UnaryOperation(sign, try factor())
        } else if currentToken.type == TokenType.minus {
            let sign: Token = currentToken
            try getNextToken(TokenType.minus)
            return UnaryOperation(sign, try factor())
        } else if currentToken.type == TokenType.open_parenthesis {
            try getNextToken(TokenType.open_parenthesis)
            let node = try expr()
            try getNextToken(TokenType.close_parenthesis)
            return node
        } else if currentToken.type == TokenType.integer_const {
            let integer = Number(currentToken)
            try getNextToken(TokenType.integer_const)
            return integer
        } else if currentToken.type == TokenType.real_const {
            let real = Number(currentToken)
            try getNextToken(TokenType.real_const)
            return real
        } else {
            let variable = Var(currentToken)
            try getNextToken(TokenType.variable)
            return variable
        }
    }
    
    private func getNextToken(_ type: TokenType) throws {
        if (currentToken.type == type) {
            currentToken = try lexer.getNextToken()
        } else {
            throw RuntimeError("Unexpected token type! Current token: \(currentToken.description)")
        }
    }
}
