//
//  SymbolTable.swift
//  PascalInterpreter2
//
//  Created by Ivan Murashov on 30.01.2022.
//

class SymbolTable {
    var symbols = [String : Symbol]()
    
    init() {
        self.define(BuiltinTypeSymbol("INTEGER"))
        self.define(BuiltinTypeSymbol("REAL"))
    }
    
    func define(_ symbol: Symbol) {
        symbols[symbol.name] = symbol
    }
    
    func lookup(_ name: String) -> Symbol? {
        return symbols[name]
    }
}
