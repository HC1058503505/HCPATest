//
//  main.swift
//  HCPATest
//
//  Created by UltraPower on 2017/8/2.
//
//
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer


// 读取配置文件
let server:HTTPServer = config()

// 初始化
Utility.initializeObjects()

do {
//    try HTTPServer.launch(configurationData: confData)
    try server.start()
} catch {
    fatalError("\(error)")
}
