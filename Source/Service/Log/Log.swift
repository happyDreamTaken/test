//
//  Log.swift
//  OEMCloud
//
//  Created by codeboor on 2017/5/17.
//  Copyright © 2017年 OEMCloud. All rights reserved.
//

import Foundation

class Log {
    enum LogType: String {
        case info = "✅"
        case error = "❌"
        case warning = "⚠️"
    }
    
    class func Info(file: String = #file, line: Int = #line, _ items: Any...){
        printLog(logType: .info ,file: file, line: line, items: items)
    }
    
    class func Error(file: String = #file, line: Int = #line, _ items: Any...){
        printLog(logType: .error ,file: file, line: line, items: items)
    }
    
    class func Warning(file: String = #file, line: Int = #line, _ items: Any...){
        printLog(logType: .warning ,file: file, line: line, items: items)
    }
    
    
    static func printLog(logType: LogType, file: String, line: Int, items: Any...) {
        #if DEBUG
            var logString = ""
            for obj in items {
                logString = logString + "\(obj)" + " "
            }
            let fileName = (file.split(separator: "/").last ?? "").replacingOccurrences(of: ".swift", with: "")
            
            let logTag = logType.rawValue
            
            print("\(logTag)\(fileName):\(line) \(logString)\n")
        #endif
    }
}

