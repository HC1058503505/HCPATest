//
//  PageHandlers.swift
//  HCPATest
//
//  Created by UltraPower on 2017/8/2.
//
//

import PerfectMustache
import PerfectHTTP
import PerfectLib

public struct MustacheHandler: MustachePageHandler {
    var context: [String: Any]
    public func extendValuesForResponse(context contxt: MustacheWebEvaluationContext, collector: MustacheEvaluationOutputCollector) {
        contxt.extendValues(with: context)
        do {
            contxt.webResponse.setHeader(.contentType, value: "text/html")
            try contxt.requestCompleted(withCollector: collector)
        } catch {
            let response = contxt.webResponse
            response.status = .internalServerError
            response.appendBody(string: "\(error)")
            response.completed()
        }
    }
    
    public init(context: [String: Any] = [String: Any]()) {
        self.context = context
    }
}


extension HTTPResponse {
    public func render(template: String, context: [String: Any] = [String: Any]()) {
        mustacheRequest(request: self.request, response: self, handler: MustacheHandler(context: context), templatePath: request.documentRoot + "/templates/\(template).mustache")
    }
    public func redirect(path: String) {
        self.status = .found
        self.addHeader(.location, value: path)
        self.completed()
    }
    
}
