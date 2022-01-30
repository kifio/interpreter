package calculator;

import java.util.ArrayList;

class TestCommon {
    
    static ArrayList<Token> getTokens(String expr) {
        Lexer lexer = new Lexer(expr);
        Token current = null;
        ArrayList<Token> tokens = new ArrayList<>();

        while (lexer.hasNext(current)) {
            current = lexer.next(current);
            tokens.add(current);
        }

        return tokens;
    }
}