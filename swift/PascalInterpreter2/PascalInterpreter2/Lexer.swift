//
//  Lexer.swift
//  PascalInterpreter2
//
//  Created by Ivan Murashov on 30.01.2022.
//

// Преобразует входные данные в токены
class Lexer {
    private let characters: Array<Character>
    private var pos = 0
    
    private let plus = Token(type: TokenType.plus, value: "+")
    private let minus = Token(type: TokenType.minus, value: "-")
    private let mul = Token(type: TokenType.multiply, value: "*")
    private let real_div = Token(type: TokenType.real_div, value: "/")
    private let openParenthesis = Token(type: TokenType.open_parenthesis, value: ")")
    private let closeParenthesis = Token(type: TokenType.close_parenthesis, value: "(")
    private let eof = Token(type: TokenType.eof, value: "EOF")
    private let asign = Token(type: TokenType.assign, value: ":=")
    private let colon = Token(type: TokenType.colon, value: ":")
    private let semicolon = Token(type: TokenType.semicolon, value: ";")
    private let dot = Token(type: TokenType.dot, value: ".")
    private let comma = Token(type: TokenType.comma, value: ",")

    private let reservedKeywords = [
        "PROGRAM" : Token(type: TokenType.programm, value: "PROGRAM"),
        "VAR" : Token(type: TokenType.variable_block, value: "VAR"),
        "DIV" : Token(type: TokenType.integer_div, value: "DIV"),
        "INTEGER" : Token(type: TokenType.integer_type, value: "INTEGER"),
        "REAL" : Token(type: TokenType.real_type, value: "REAL"),
        "BEGIN": Token(type: TokenType.begin, value: "BEGIN"),
        "END": Token(type: TokenType.end, value: "END")
    ]
    
    init(input: String) {
        self.characters = [Character](input)
    }
    
    func getNextToken() throws -> Token  {
        while pos < characters.count {
            let char = characters[pos]
            if (char == " " || char == "\n") {
                pos += 1
                continue
            } else if char == "+" {
                pos += 1
                return plus
            } else if char == "-" {
                pos += 1
                return minus
            } else if char == "*" {
                pos += 1
                return mul
            } else if char == "/" {
                pos += 1
                return real_div
            } else if char == "(" {
                pos += 1
                return openParenthesis
            } else if char == ")" {
                pos += 1
                return closeParenthesis
            } else if char == "{"  {
                pos += 1
                skipComment()
            } else if char == ":" && peek() == "=" {
                pos += 2
                return asign
            } else if char == ":" {
                pos += 1
                return colon
            }else if char == ";" {
                pos += 1
                return semicolon
            } else if char == "." {
                pos += 1
                return dot
            } else if char == "," {
                pos += 1
                return comma
            } else if isDigit(char) {
                return readNumber()
            } else if char.isLetter || char == "_" {
                return readWord()
            } else {
                pos += 1
                throw RuntimeError("Unknown symbol: \(char)")
            }
        }
        
        return eof
    }
    
    ///  Возвращает следующий символ, без инкремента счетчика считанных символов.
    ///  Используется для распознания двузначных операндов, например :=
    private func peek() -> Character? {
        if pos < characters.count - 1 {
            return characters[pos + 1]
        } else {
            return nil
        }
    }
    
    /// Возвращает число целое или рациональное
    private func readNumber() -> Token {
        var numberStr = ""
        
        repeat {
            numberStr.append(characters[pos])
            pos += 1
        } while pos < characters.count && isDigit(characters[pos]) || characters[pos] == "."
        
        if numberStr.contains(".") {
            return Token(type: TokenType.real_const, value: numberStr)
        } else {
            return Token(type: TokenType.integer_const, value: numberStr)
        }
    }
    
    /// Возвращает ключевое слово, либо название переменной/программы.
    private func readWord() -> Token {
        var str = ""
        
        repeat {
            str.append(characters[pos])
            pos += 1
        } while pos < characters.count && (
            characters[pos].isLetter || characters[pos] == "_" || isDigit(characters[pos])
        )
        
        if let keyword = reservedKeywords[str.uppercased()] {
            return keyword
        } else {
            return Token(type: TokenType.variable, value: str)
        }
    }
    
    private func isDigit(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }
    
    private func skipComment() {
        while pos < characters.count && characters[pos] != "}" {
            pos += 1
        }
        pos += 1
    }
}
