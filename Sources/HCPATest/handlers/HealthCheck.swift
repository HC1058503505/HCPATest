//
//  HealthCheck.swift
//  HCPATest
//
//  Created by UltraPower on 2017/8/2.
//
//

import PerfectHTTP
class HealthCheck:Handlers {
    static func healthcheck() -> RequestHandler {
        return { request, response in
            let _ = try? response.setBody(json: ["health" : "ok"])
            response.completed()

        
        }
    } 

}
