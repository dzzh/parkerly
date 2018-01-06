//
// Created by Zmicier Zaleznicenka on 6/1/18.
// Copyright (c) 2018 Zmicier Zaleznicenka. All rights reserved.
//

import Foundation

class NetworkOperation: BlockOperation {

    private let request: URLRequest
    private let completion: (Data?, URLResponse?, Error?) -> Void

    init(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.request = request
        self.completion = completion
        super.init()
        addExecutionBlock(requestBlock)
    }

    private var requestBlock: () -> Void {
        return {
            // TODO: response filter to map Error to ParkerlyError
            URLSession.shared.dataTask(with: self.request) { [weak self] (data, response, error) in
                self?.completion(data, response, error)
            }.resume()
        }
    }
}
