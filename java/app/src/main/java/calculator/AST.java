package calculator;

public interface AST {
    
    int visit(Visitor visitor);

}
