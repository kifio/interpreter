//
//  Token.swift
//  PascalInterpreter2
//
//  Created by Ivan Murashov on 30.01.2022.
//

enum TokenType {
    
    // Арифметика
    case integer_const
    case real_const
    case plus
    case minus
    case multiply
    case real_div
    case integer_div
    case open_parenthesis
    case close_parenthesis
    
    // Ключевые слова
    case programm
    case variable_block
    case real_type
    case integer_type
    case begin
    case end
    
    // Разделители
    case assign
    case colon
    case comma
    case semicolon
    case dot
    
    // Условные токены
    case variable
    case eof
}

class Token : CustomStringConvertible {
    
    let type: TokenType
    let value: String
    
    init(type: TokenType, value: String) {
        self.type = type
        self.value = value
    }
    
    var description: String { return "[\(type)]\(value)" }
    
}
