//
//  main.swift
//  PascalInterpreter2
//
//  Created by Ivan Murashov on 20.01.2022.
//

let program = """
PROGRAM Part10AST;
VAR
   a, b : INTEGER;
   y    : REAL;

BEGIN {Part10AST}
   a := 2;
   b := 10 * a + 10 * a DIV 4;
   y := 20 DIV 7 + 3.14;
END.  {Part10AST}
"""

let incorrectProgramm = """
PROGRAM NameError1;
VAR
   a : INTEGER;

BEGIN
   a := 2 + b;
END.
"""

let incorrectProgramm2 = """
PROGRAM NameError2;
VAR
   b : INTEGER;

BEGIN
   b := 1;
   a := b + 2;
END.
"""

let lexer = Lexer(input: program)
let parser = Parser(lexer: lexer)
let ast = try parser.parse()
let symbolTable = try SymbolTableBuilder().build(ast)
let result = try Interpreter().visit(node: ast)
print(result)
