package calculator;

class UnaryOperation implements AST {

    private Token operation;
    private AST expr;

    UnaryOperation(Token operation, AST expr) {
        this.operation = operation;
        this.expr = expr;
    }

    Token getOperation() {
        return operation;
    }

    AST getExpression() {
        return expr;
    }

    @Override
    public int visit(Visitor visitor) {
        return visitor.visitUnaryOperation(this);
    };

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        if (this.getClass() != o.getClass()) return false;
        UnaryOperation op = (UnaryOperation) o;
        return op.getOperation().equals(operation) && op.getExpression().equals(expr);
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 31 * hash + operation.hashCode();
        hash = 31 * hash + expr.hashCode();
        return hash;
    }

    @Override
    public String toString() {
        return new StringBuilder()
        .append(operation.getValue())
        .append(expr.toString())
        .toString();
    }

}