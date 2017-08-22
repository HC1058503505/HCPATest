//
//  UserLoginRegister.swift
//  HCPATest
//
//  Created by UltraPower on 2017/8/3.
//
//

import Foundation
import PerfectHTTP
import PerfectLib
import MySQL
import PerfectCrypto

class UserLoginRegister:Handlers {
    
    static func loginRegister() -> RequestHandler  {
        
        return { request, response in
            
            // login
            guard request.method == .post else {
                login(request: request, response: response)
                return
            }
            
            // register
            register(request: request, response: response)
        }
    }
    
    static func login() -> RequestHandler {
        return { request, response in
            response.render(template: "login")
            response.completed()
        }
    }
    
    static func register() -> RequestHandler {
        return { request, response in
            response.render(template: "register")
            response.completed()
        }
    }
}

extension UserLoginRegister {
    fileprivate static func login(request: HTTPRequest, response: HTTPResponse){
        
        // login
        guard mysqlDB.connect(host: testHost, user: testUser, password: testPassword, db: testDB) else {
            // 连接数据库失败
            responseAction(response: response, status: .custom(code: Int(mysqlDB.errorCode()), message: mysqlDB.errorMessage()), body: mysqlDB.errorMessage())
            return
        }
        // 连接数据库成功
        defer {
            // 最后关闭数据库
            mysqlDB.close()
        }
        
        let userName = request.param(name: "username", defaultValue: "")!
        let userPwd = request.param(name: "password", defaultValue: "")!
        let query = mysqlDB.query(statement: "select * from person where name=\'\(userName)\' and password=\'\(userPwd)\'")
        
        // 确保查询完成
        guard query else {
            responseAction(response: response, status: .custom(code: Int(mysqlDB.errorCode()), message: mysqlDB.errorMessage()), body: mysqlDB.errorMessage())
            return
        }
        
        // 在当前会话过程中查询结果
        guard let result = mysqlDB.storeResults(), result.numRows() > 0 else {
            responseAction(response: response, status: .custom(code: Int(mysqlDB.errorCode()), message: mysqlDB.errorMessage()), body: "Fail")
            return
        }
        
        responseAction(response: response, status: .ok, body: "Success")
    }
    
    fileprivate static func register(request: HTTPRequest, response: HTTPResponse) {
        // 连接数据库
        // 1.连接失败
        guard mysqlDB.connect(host: testHost, user: testUser, password: testPassword, db: testDB) else {
            error(request, response, error: mysqlDB.errorMessage(), code: .custom(code: Int(mysqlDB.errorCode()), message: mysqlDB.errorMessage()))
            return
        }
        
        // 2.连接成功
        defer {
            mysqlDB.close()
        }
        
        let userName = request.param(name: "username", defaultValue: "default")!
        let password = request.param(name: "password", defaultValue: "default")!
        
        // 3.查询
        let query = mysqlDB.query(statement: "select * from person where name = \'\(userName)\'")
        
        // 查询失败
        guard query else {
            error(request, response, error: mysqlDB.errorMessage(), code: .custom(code: Int(mysqlDB.errorCode()), message: mysqlDB.errorMessage()))
            return
        }
        
        // 查询成功,但是已存在
        guard let result = mysqlDB.storeResults() , result.numRows() <= 0 else {
            responseAction(response: response, status: .custom(code: Int(mysqlDB.errorCode()), message: mysqlDB.errorMessage()), body: "Had register!")
            return
        }
        
        // 查询成功,并且不存在该用户，注册成功
        let number = Int(Date().timeIntervalSince1970)
        
        let insert = mysqlDB.query(statement: "insert into person (number,name,password) values (\(number),\'\(userName)\',\'\(password)\')")
        guard insert else {
            responseAction(response: response, status: .custom(code: Int(mysqlDB.errorCode()), message: mysqlDB.errorMessage()), body: mysqlDB.errorMessage())
            return
        }
        
        responseAction(response: response, status: .ok, body: "Success")
        
    }
    
}
