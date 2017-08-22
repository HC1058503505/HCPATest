//
//  config.swift
//  HCPATest
//
//  Created by UltraPower on 2017/8/2.
//
//

import PerfectLib
import JSONConfig
import PerfectHTTPServer
import PerfectRequestLogger
import PerfectLogger

struct AppCredentials {
    var clientid = ""
    var clientsecret = ""
}


func config() -> HTTPServer{
    let server = HTTPServer()

    // 保存请求记录
    RequestLogFile.location = "./weblog/webLog.log"
    
    server.serverPort = 8181
    server.serverName = "localhost"
    
    server.setResponseFilters(filtersResponse())
    server.setRequestFilters(filtersRequest())

    server.addRoutes(routesBox())
    return server
}
