package calculator;

class BinaryOperation implements AST {
    private AST left;
    private Token operation;
    private AST right;

    BinaryOperation(AST left, Token operation, AST right) {
        this.left = left;
        this.operation = operation;
        this.right = right;
    }

    AST getLeft() {
        return left;
    }

    Token getOperation() {
        return operation;
    }

    AST getRight() {
        return right;
    }

    @Override
    public int visit(Visitor visitor) {
        return visitor.visitBinaryOperation(this);
    };

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        if (this.getClass() != o.getClass()) return false;
        BinaryOperation op = (BinaryOperation) o;
        return op.getLeft().equals(left) && op.getOperation().equals(operation) && op.getRight().equals(right);
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 31 * hash + left.hashCode();
        hash = 31 * hash + operation.hashCode();
        hash = 31 * hash + right.hashCode();
        return hash;
    }

    @Override
    public String toString() {
        return new StringBuilder()
        .append(left.toString())
        .append(operation.getValue())
        .append(right.toString())
        .toString();
    }

}
