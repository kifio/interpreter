package calculator;

import java.lang.Integer;

/**
 * expr : open-parenthesis term ((PLUS|MINUS) term)* addition-subtraction close-parenthesis
 * term : open-parenthesis factor ((MUL|DIV) factor)* close-parenthesis 
 * factor : INTEGER
**/
class Calculator {
    
    private Lexer lexer;
    private Token current;

    Calculator(Lexer lexer) {
        this.lexer = lexer;
        this.current = lexer.next(null);
    }

    int expr() {        
        int result = term();

        while (current.getType() == TokenType.PLUS || current.getType() == TokenType.MINUS) {
            if (current.getType() == TokenType.PLUS) {
                current = lexer.next(current);
                result += term();
            } else if (current.getType() == TokenType.MINUS) {
                current = lexer.next(current);
                result -= term();
            }
        }

        return result;
    }

    private int term() {
        int result = factor();
        current = lexer.next(current);

        while (current.getType() == TokenType.MULTIPLY || current.getType() == TokenType.DIVIDE) {
            if (current.getType() == TokenType.MULTIPLY) {
                current = lexer.next(current);
                result *= factor();
            } else if (current.getType() == TokenType.DIVIDE) {
                current = lexer.next(current);
                result /= factor();

            }

            current = lexer.next(current);

            if (current.getType() == TokenType.CLOSE_PARENTHESIS) {
                return result;
            } 

        }

        return result;
    }

    private int factor() {
        if (current.getType() == TokenType.OPEN_PARENTHESIS) {
            current = lexer.next(current);
            return expr();
        } else {
            return Integer.parseInt(current.getValue());
        }
    }
}