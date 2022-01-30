package calculator;

class Integer implements AST {
    private Token token;

    Integer(Token token) {
        this.token = token;
    }

    TokenType getType() {
        return token.getType();
    }

    String getValue() {
        return token.getValue();
    }

    @Override
    public int visit(Visitor visitor) {
        return visitor.visitInteger(this);
    };

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        if (this.getClass() != o.getClass()) return false;
        Integer integer = (Integer) o;
        return integer.getType().equals(getType()) && integer.getValue().equals(getValue());
    }

    @Override
    public int hashCode() {
        return token.hashCode();
    }

    @Override
    public String toString() {
        return token.getValue();
    }

}
