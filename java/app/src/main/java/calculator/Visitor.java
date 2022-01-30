package calculator;

public interface Visitor {
    int visitBinaryOperation(BinaryOperation operation);

    int visitUnaryOperation(UnaryOperation operation);

    int visitInteger(Integer integer);
}
