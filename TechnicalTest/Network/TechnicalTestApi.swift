//
//  TechnicalTestApi.swift
//  TechnicalTest
//
//  Created by Chris Rusin on 6/25/20.
//  Copyright © 2020 ChristianRusin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// HTTP method definitions.
///
/// See RFC https://tools.ietf.org/html/rfc7231#section-4.3
enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

class TechnicalTestApi {
    func getHomeData() -> Observable<HomeData> {
        guard let requestUrl = URL(string: "http://storage42.com/modulotest/data.json") else {
            fatalError("Unable to genreate URL from invalid string")
        }
        let defaultRequestTimeout: TimeInterval = TimeInterval(5.0)// 5 seconds

        var urlRequest = URLRequest(
            url: requestUrl,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: defaultRequestTimeout
        )

        urlRequest.httpMethod = HTTPMethod.get.rawValue

        return URLSession.shared.rx.data(request: urlRequest).map({ data in
            return try JSONDecoder().decode(HomeData.self, from: data)
        })
    }
}
