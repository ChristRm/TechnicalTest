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

class TechnicalTestApi {
    static func getHomeData() -> Observable<HomeData> {
        guard let requestUrl = URL(string: "http://storage42.com/modulotest/data.json") else {
            fatalError("Unable to genreate URL from invalid string")
        }
        let defaultRequestTimeout: TimeInterval = TimeInterval(5.0)// 5 seconds

        var urlRequest = URLRequest(
            url: requestUrl,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: defaultRequestTimeout
        )

        urlRequest.httpMethod = "GET"

        return URLSession.shared.rx.data(request: urlRequest).map({ data in
            return try JSONDecoder().decode(HomeData.self, from: data)
        })
    }
}
