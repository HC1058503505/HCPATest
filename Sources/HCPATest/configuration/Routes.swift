//
//  Routes.swift
//  HCPATest
//
//  Created by UltraPower on 2017/8/2.
//
//

import PerfectHTTPServer
import PerfectHTTP
import PerfectLib


func routesBox() -> Routes {
    var allRoutes = Routes()
    allRoutes.add(Route(method: .get, uri: "/healthcheck", handler: HealthCheck.healthcheck()))
    allRoutes.add(Route(method: .get, uri: "/", handler: Index.index()))
    allRoutes.add(Route(methods: [.get,.post], uri: "/loginregister", handler: UserLoginRegister.loginRegister()))
    allRoutes.add(Route(method: .get, uri: "/login", handler: UserLoginRegister.login()))
    allRoutes.add(Route(method: .get, uri: "/register", handler: UserLoginRegister.register()))
    return allRoutes
}
