package calculator;

enum TokenType {
    INTEGER, PLUS, MINUS, MULTIPLY, DIVIDE, OPEN_PARENTHESIS, CLOSE_PARENTHESIS, EOF
}

class Token {

    static final Token PLUS = new Token("+", TokenType.PLUS);
    static final Token MINUS = new Token("-", TokenType.MINUS);
    static final Token MULTIPLY = new Token("*", TokenType.MULTIPLY);
    static final Token DIVIDE = new Token("/", TokenType.DIVIDE);
    static final Token OPEN_PARENTHESIS = new Token("(", TokenType.OPEN_PARENTHESIS);
    static final Token CLOSE_PARENTHESIS = new Token(")", TokenType.CLOSE_PARENTHESIS);
    static final Token EOF = new Token("\0", TokenType.EOF);

    private String value;
    private TokenType type;

    Token(String value, TokenType type) {
        this.value = value;
        this.type = type;
    }

    String getValue() {
        return value;
    }

    TokenType getType() {
        return type;
    }

    @Override
    public String toString() {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append(type.name());
        stringBuilder.append(":");
        stringBuilder.append(value);
        return stringBuilder.toString();
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        if (this.getClass() != o.getClass()) return false;
        Token token = (Token) o;
        return value.equals(token.value) && type.equals(token.type);
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 31 * hash + type.hashCode();
        hash = 31 * hash + value.hashCode();
        return hash;
    }

}