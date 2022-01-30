package calculator;

class Lexer {

    private char[] expression;
    private int count = 0;

    Lexer(String expression) {
        this.expression = expression.toCharArray();
    }

    boolean hasNext(Token current) {
        return current == null || current.getType() != TokenType.EOF;
    }

    Token next(Token current) {
        while (count < expression.length) {
            if (Character.isDigit(expression[count])) {
                StringBuilder strRepr = new StringBuilder();
                do {
                    strRepr.append(expression[count]);
                    count++;
                } while (count < expression.length && Character.isDigit(expression[count]));
                Token next = new Token(strRepr.toString(), TokenType.INTEGER);
                validateToken(current, next);
                return next;
            } else if (expression[count] == ' ') {
                count++;
                continue;
            } else if (expression[count] == '+') {
                Token next = Token.PLUS;
                count++;
                validateToken(current, next);
                return next;
            } else if (expression[count] == '-') {
                Token next = Token.MINUS;
                count++;
                validateToken(current, next);
                return next;
            } else if (expression[count] == '*') {
                Token next = Token.MULTIPLY;
                count++;
                validateToken(current, next);
                return next;
            } else if (expression[count] == '/') {
                Token next = Token.DIVIDE;
                count++;
                validateToken(current, next);
                return next;
            } else if (expression[count] == '(') {
                Token next = Token.OPEN_PARENTHESIS;
                count++;
                validateToken(current, next);
                return next;
            } else if (expression[count] == ')') {
                Token next = Token.CLOSE_PARENTHESIS;
                count++;
                validateToken(current, next);
                return next;
            }

        }

        Token next = Token.EOF;
        validateToken(current, next);
        return next;
    }

    private void validateExpression() {

        System.out.println("expression: " + new String(expression));

        int parenthesis = 0;

        for (char c : expression) {
            if (c == '(') {
                parenthesis += 1;
            } else if (c == ')') {
                parenthesis -= 1;
            }
        }

        if (parenthesis != 0) {
            throw new IllegalStateException("Invalid expression.");
        }
    }

    private void validateToken(Token currentToken, Token nextToken) {
        if (currentToken != null) {
            if (currentToken.getType() == TokenType.OPEN_PARENTHESIS) {
                if (nextToken.getType() != TokenType.INTEGER && nextToken.getType() != TokenType.OPEN_PARENTHESIS) {
                    throw new IllegalStateException("Invalid expression. current: " + currentToken.toString() + "; next: " + nextToken.toString());
                }
            } else if (currentToken.getType() == TokenType.CLOSE_PARENTHESIS) {
                if (nextToken.getType() == TokenType.INTEGER || nextToken.getType() == TokenType.OPEN_PARENTHESIS) {
                    throw new IllegalStateException("Invalid expression. current: " + currentToken.toString() + "; next: " + nextToken.toString());
                }
            } else if (nextToken.getType() == TokenType.EOF) {
                if (currentToken.getType() != TokenType.EOF && currentToken.getType() != TokenType.INTEGER && currentToken.getType() != TokenType.CLOSE_PARENTHESIS) {
                    throw new IllegalStateException("Invalid expression");
                }
            }
        }
    }
}