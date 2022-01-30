package calculator;

class ASTVisitor implements Visitor {

    @Override 
    public int visitBinaryOperation(BinaryOperation operation) {
        if (operation.getOperation().getType() == TokenType.PLUS) {
            return operation.getLeft().visit(this) + operation.getRight().visit(this);
        }
        else if (operation.getOperation().getType() == TokenType.MINUS) {
            return operation.getLeft().visit(this) - operation.getRight().visit(this);
        }
        else if (operation.getOperation().getType() == TokenType.MULTIPLY) {
            return operation.getLeft().visit(this) * operation.getRight().visit(this);
        }
        else if (operation.getOperation().getType() == TokenType.DIVIDE) {
            return operation.getLeft().visit(this) / operation.getRight().visit(this);
        } else {
            throw new IllegalArgumentException();
        }
    }

    @Override
    public int visitUnaryOperation(UnaryOperation operation) {
        if (operation.getOperation().getType() == TokenType.PLUS) {
            return operation.getExpression().visit(this);
        } else if (operation.getOperation().getType() == TokenType.MINUS) {
            return -operation.getExpression().visit(this);
        } else {
            throw new IllegalArgumentException();
        }
    }

    @Override
    public int visitInteger(Integer integer) {
        return java.lang.Integer.parseInt(integer.getValue());
    }
    
    int visit(AST ast) {
        return ast.visit(this);
    }
}
