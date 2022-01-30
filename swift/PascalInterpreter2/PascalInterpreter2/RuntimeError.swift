//
//  RuntimeError.swift
//  PascalInterpreter2
//
//  Created by Ivan Murashov on 30.01.2022.
//

struct RuntimeError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var localizedDescription: String {
        return message
    }
}
