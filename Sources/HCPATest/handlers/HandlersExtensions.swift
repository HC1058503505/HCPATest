//
//  HandlersExtensions.swift
//  HCPATest
//
//  Created by UltraPower on 2017/8/2.
//
//

import PerfectHTTP
import PerfectLib
import StORM

extension Handlers {
    
    static func responseAction(response: HTTPResponse, status:HTTPResponseStatus, body:Any) {
        response.status = status
        
        if body is String {
            response.setBody(string: body as! String)
        } else if body is [UInt8] {
            response.setBody(bytes: body as! [UInt8])
        } else if body is JSONConvertible {
            let _ = try? response.setBody(json: body as! JSONConvertible)
        }
        response.completed()
    }
    
    
    static func error(_ request: HTTPRequest, _ response: HTTPResponse, error: String, code: HTTPResponseStatus = .badRequest) {
        do {
            response.status = code
            try response.setBody(json: ["error" : "\(error)"])
        } catch {
            print(error)
        }
        response.completed()
    }
    
    static func unimplemented(data: [String:Any]) throws -> RequestHandler {
        return {
            request, response in
            response.status = .notImplemented
            response.completed()
        }
    }
    
    // Common helper function to dump rows to JSON
    static func nestedDataDict(_ rows: [StORM]) -> [Any] {
        var d = [Any]()
        for i in rows {
            d.append(i.asDataDict())
        }
        return d
    }
    
    // Handles psuedo redirects.
    // Will serve up alternate content, for example if you wish to report an error condition, like missing data.
    static func redirectRequest(_ request: HTTPRequest, _ response: HTTPResponse, msg: String, template: String, additional: [String:String] = [String:String]()) {
        
        var context: [String : Any] = [
            "msg": msg
        ]
        for i in additional {
            context[i.0] = i.1
        }
        
        response.render(template: template, context: context)
        response.completed()
        return
    }
}
