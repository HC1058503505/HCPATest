//
//  Index.swift
//  HCPATest
//
//  Created by UltraPower on 2017/8/3.
//
//

import PerfectHTTP
class Index: Handlers {
    static func index() -> RequestHandler {
        return { request, response in
            response.setBody(string: "Hello Perfect")
            response.completed()
        }
    }
}
