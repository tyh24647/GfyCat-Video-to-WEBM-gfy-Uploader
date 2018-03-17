//
//  CallStackAnalyzer.swift
//
//  Created by Mitch Robertson on 2016-05-20.
//  Copyright © 2016 Mitch Robertson. All rights reserved.
//

import Foundation



class CallStackAnalyzer {
    
    private static func cleanMethod(method:(String)) -> String {
        if (method.count > 1) {
            let firstChar:Character = method[method.startIndex]
            if (firstChar == "(") {
                return String(method[Range<String.Index>(uncheckedBounds: (lower: method.index(method.startIndex, offsetBy: 1), upper: method.endIndex))])
            }
        }
        
        return method
    }
    
    /**
     Takes a specific item from 'NSThread.callStackSymbols()' and returns the class and method call contained within.
     - Parameter stackSymbol: a specific item from 'NSThread.callStackSymbols()'
     - Parameter includeImmediateParentClass: Whether or not to include the parent class in an innerclass situation.
     
     - Returns: a tuple containing the (class,method) or nil if it could not be parsed
     */
    static func classAndMethodForStackSymbol(stackSymbol:String, includeImmediateParentClass:Bool? = false) -> (String,String)? {
        
        let components = stackSymbol.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression,
            range: nil
        ).components(
            separatedBy: " "
        )
        
        if (components.count >= 4) {
            var packageClassAndMethodStr =   _stdlib_demangleName(components[3])
            packageClassAndMethodStr = packageClassAndMethodStr.replacingOccurrences(
                of: "\\s+",
                with: " ",
                options: .regularExpression,
                range: nil
                ).components(separatedBy: " ")[0]
            
            var packageClassAndMethod = packageClassAndMethodStr.components(separatedBy: ".")
            let numberOfComponents = packageClassAndMethod.count
            
            if (numberOfComponents >= 2) {
                
                let method = CallStackAnalyzer.cleanMethod(method: packageClassAndMethod[numberOfComponents - 1])
                if includeImmediateParentClass != nil {
                    if (includeImmediateParentClass == true && numberOfComponents >= 4) {
                        return (packageClassAndMethod[numberOfComponents-3] + "." + packageClassAndMethod[numberOfComponents - 2], method)
                    }
                }
                return (packageClassAndMethod[numberOfComponents-2],method)
            }
        }
        return nil
    }
    
    /**
     Analyses the 'NSThread.callStackSymbols()' and returns the calling class and method in the scope of the caller.
     
     - Parameter includeImmediateParentClass: Whether or not to include the parent class in an innerclass situation.
     
     - Returns: a tuple containing the (class,method) or nil if it could not be parsed
     */
    static func getCallingClassAndMethodInScope(includeImmediateParentClass:Bool? = false) -> (String,String)? {
        let stackSymbols = Thread.callStackSymbols
        if (stackSymbols.count >= 3) {
            return CallStackAnalyzer.classAndMethodForStackSymbol(stackSymbol: stackSymbols[2], includeImmediateParentClass: includeImmediateParentClass)
        }
        return nil
    }
    
    /**
     Analyses the 'NSThread.callStackSymbols()' and returns the current class and method in the scope of the caller.
     
     - Parameter includeImmediateParentClass: Whether or not to include the parent class in an innerclass situation.
     
     - Returns: a tuple containing the (class,method) or nil if it could not be parsed
     */
    static func getThisClassAndMethodInScope(includeImmediateParentClass:Bool? = false) -> (String,String)? {
        let stackSymbols = Thread.callStackSymbols
        if (stackSymbols.count >= 2) {
            return CallStackAnalyzer.classAndMethodForStackSymbol(stackSymbol: stackSymbols[1], includeImmediateParentClass: includeImmediateParentClass)
        }
        return nil
    }
    
}

@_silgen_name("swift_demangle")
public
func _stdlib_demangleImpl(
    _ mangledName: UnsafePointer<CChar>?,
    mangledNameLength: UInt,
    outputBuffer: UnsafeMutablePointer<UInt8>?,
    outputBufferSize: UnsafeMutablePointer<UInt>?,
    flags: UInt32
    ) -> UnsafeMutablePointer<CChar>?


func _stdlib_demangleName(_ mangledName: String) -> String {
    return mangledName.utf8CString.withUnsafeBufferPointer {
        (mangledNameUTF8) in
        
        let demangledNamePtr = _stdlib_demangleImpl(
            mangledNameUTF8.baseAddress,
            mangledNameLength: UInt(mangledNameUTF8.count - 1),
            outputBuffer: nil,
            outputBufferSize: nil,
            flags: 0)
        
        if let demangledNamePtr = demangledNamePtr {
            let demangledName = String(cString: demangledNamePtr)
            free(demangledNamePtr)
            return demangledName
        }
        return mangledName
    }
}
