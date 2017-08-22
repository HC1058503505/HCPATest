//
//  Filters.swift
//  HCPATest
//
//  Created by UltraPower on 2017/8/2.
//
//

import PerfectHTTPServer
import PerfectRequestLogger
import PerfectHTTP
func filtersRequest() -> [(HTTPRequestFilter, HTTPFilterPriority)] {
    var filters: [(HTTPRequestFilter, HTTPFilterPriority)] = [(HTTPRequestFilter, HTTPFilterPriority)]()
    filters.append((try! RequestLogger.filterAPIRequest(data: ["default":""]), HTTPFilterPriority.high))
    return filters
}


func filtersResponse() -> [(HTTPResponseFilter, HTTPFilterPriority)] {
    var filters: [(HTTPResponseFilter, HTTPFilterPriority)] = [(HTTPResponseFilter, HTTPFilterPriority)]()
    filters.append((try! HTTPFilter.contentCompression(data: ["default":""]), HTTPFilterPriority.high))
    filters.append((try! RequestLogger.filterAPIResponse(data: ["default" : ""]), HTTPFilterPriority.low))
    return filters
}
