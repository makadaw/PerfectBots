//
//  HeliumLogger+Application.swift
//  SwiftBot
//

import Foundation
import HeliumLogger
import LoggerAPI
import protocol PerfectLib.Logger
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

extension HeliumLogger {
    fileprivate final class PerfectLoggerBridge: PerfectLib.Logger {
        let logger: HeliumLogger
        
        init(logger: HeliumLogger) {
            self.logger = logger
        }
        
        func debug(message: String, _ even: Bool) {
            logger.log(.debug, msg: message, functionName: "", lineNum: 0, fileName: "Perfect")
        }
        
        func info(message: String, _ even: Bool) {
            logger.log(.info, msg: message, functionName: "", lineNum: 0, fileName: "Perfect")
        }
        
        func warning(message: String, _ even: Bool) {
            logger.log(.warning, msg: message, functionName: "", lineNum: 0, fileName: "Perfect")
        }
        
        func error(message: String, _ even: Bool) {
            logger.log(.error, msg: message, functionName: "", lineNum: 0, fileName: "Perfect")
        }
        
        func critical(message: String, _ even: Bool) {
            logger.log(.error, msg: message, functionName: "", lineNum: 0, fileName: "Perfect")
        }
        
        func terminal(message: String, _ even: Bool) {
            logger.log(.error, msg: message, functionName: "", lineNum: 0, fileName: "Perfect")
        }
    }
    
    fileprivate final class HerokuOutputStream: TextOutputStream {
        func write(_ string: String) {
            fputs(string, stdout)
            fputs("\n", stdout)
            fflush(stdout)
        }
    }
    
    class func applicationLogger(type: LoggerAPI.LoggerMessageType = .verbose) -> HeliumLogger {
        #if os(Linux)
            let logger = HeliumStreamLogger(type, outputStream:HerokuOutputStream())
        #else
            let logger = HeliumLogger(type)
        #endif
        Log.logger = logger
        return logger
    }
    
    func perfectLogger() -> PerfectLib.Logger {
        return PerfectLoggerBridge(logger: self)
    }
}
