//
//  Symbol.swift
//  PascalInterpreter2
//
//  Created by Ivan Murashov on 30.01.2022.
//

class Symbol {
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
}

class BuiltinTypeSymbol : Symbol {
   
}

class VarSymbol : Symbol {
    
    var type: BuiltinTypeSymbol
    
    init(_ name: String, _ type: BuiltinTypeSymbol) {
        self.type = type
        super.init(name)
    }
}
