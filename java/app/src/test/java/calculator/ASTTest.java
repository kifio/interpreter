package calculator;

import org.junit.Test;
import static org.junit.Assert.*;

public class ASTTest {
    
    @Test public void calculatorTest() {
        Integer two = new Integer(new Token("2", TokenType.INTEGER));
        Token plus = Token.PLUS;
        
        assertEquals(7, 
            new ASTVisitor().visit(
                new Parser(new Lexer("5 - - 2")).expr()
            )
        );

        assertEquals(3, 
            new ASTVisitor().visit(
                new Parser(new Lexer("5 + - 2")).expr()
            )
        );

        assertEquals(3, 
            new ASTVisitor().visit(
                new Parser(new Lexer("+3")).expr()
            )
        );

        assertEquals(-3, 
            new ASTVisitor().visit(
                new Parser(new Lexer("-3")).expr()
            )
        );

        assertEquals(8, 
            new ASTVisitor().visit(
                new Parser(new Lexer("5 - - - + - 3")).expr()
            )
        );
        
        assertEquals(10, 
            new ASTVisitor().visit(
                new Parser(new Lexer("5 - - - + - (3 + 4) - +2")).expr()
            )
        );

        assertEquals(new BinaryOperation(two, plus, two), new Parser(new Lexer("2 + 2")).expr());

        assertEquals(
            new BinaryOperation(new BinaryOperation(two, plus, two), plus, two), 
            new Parser(new Lexer("(2 + 2) + 2")).expr()
        );

        assertEquals(4, 
            new ASTVisitor().visit(
                new Parser(new Lexer("2 + 2")).expr()
            )
        );

        assertEquals(8, 
            new ASTVisitor().visit(
                new Parser(new Lexer("2 + 2 + 2+ 2 +2-2")).expr()
            )
        );
        
        assertEquals(12, 
            new ASTVisitor().visit(
                new Parser(new Lexer("12 + 2 - 2")).expr()
            )
        );

        assertEquals(100, 
            new ASTVisitor().visit(
                new Parser(new Lexer("100 - 50 + 48+2")).expr()
            )
        );

        assertEquals(30,
            new ASTVisitor().visit(
                new Parser(new Lexer("2 + 7 * 4")).expr()
            )
        );

        assertEquals(14, 
            new ASTVisitor().visit(
                new Parser(new Lexer("7 * 4 / 2")).expr()
            )
        );
        assertEquals(42, 
            new ASTVisitor().visit(
                new Parser(new Lexer("7 * 4 / 2 * 3")).expr()
            )
        );
        assertEquals(30, 
            new ASTVisitor().visit(
                new Parser(new Lexer("10 * 4  * 2 * 3 / 8")).expr()
            )
        );

        assertEquals(50,
            new ASTVisitor().visit(
                new Parser(new Lexer("8 + 7 * 4 / 2 * 3")).expr()
            )
        );
 
        assertEquals(5,
            new ASTVisitor().visit(
                new Parser(new Lexer("7 - 8 / 4")).expr()
            )
        );
        assertEquals(17,
            new ASTVisitor().visit(
                new Parser(new Lexer("14 + 2 * 3 - 6 / 2")).expr()
            )
        );
        assertEquals(4,
            new ASTVisitor().visit(
                new Parser(new Lexer("(2 + 2)")).expr()
            )
        );
        assertEquals(4,
            new ASTVisitor().visit(
                new Parser(new Lexer("0 + (2 + 2)")).expr()
            )
        );
        assertEquals(7,
            new ASTVisitor().visit(
                new Parser(new Lexer("12 - (2 * ((2 * 2))) + 3")).expr()
            )
        );
    }
}
