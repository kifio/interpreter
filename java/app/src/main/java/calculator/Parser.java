package calculator;

class Parser {
    
    private Lexer lexer;
    private Token current;

    Parser(Lexer lexer) {
        this.lexer = lexer;
        this.current = lexer.next(null);
    }

    AST expr() {

        AST result = term();

        while (current.getType() == TokenType.PLUS || current.getType() == TokenType.MINUS) {
            Token operation = null;
            AST left;
            AST right;

            if (current.getType() == TokenType.PLUS) {
                current = lexer.next(current);
                operation = Token.PLUS;
            } else if (current.getType() == TokenType.MINUS) {
                current = lexer.next(current);
                operation = Token.MINUS;
            }

            result = new BinaryOperation(result, operation, term());
        }

        return result;
    }

    private AST term() {
        AST result = factor();
        current = lexer.next(current);

        while (current.getType() == TokenType.MULTIPLY || current.getType() == TokenType.DIVIDE) {
            Token operation = null;
            AST left;
            AST right;


            if (current.getType() == TokenType.MULTIPLY) {
                current = lexer.next(current);
                operation = Token.MULTIPLY;
            } else if (current.getType() == TokenType.DIVIDE) {
                current = lexer.next(current);
                operation = Token.DIVIDE;
            }
            
            result = new BinaryOperation(result, operation, factor());
            current = lexer.next(current);

            if (current.getType() == TokenType.CLOSE_PARENTHESIS) {
                return result;
            }
        }

        return result;
    }

    private AST factor() {
        if (current.getType() == TokenType.MINUS || current.getType() == TokenType.PLUS) {
            Token operation = current;
            current = lexer.next(current);
            return new UnaryOperation(operation, factor());
        } if (current.getType() == TokenType.OPEN_PARENTHESIS) {
            current = lexer.next(current);
            return expr();
        } else {
            return new Integer(current);
        }
    }

}
