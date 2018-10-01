//
//  Extension.swift
//  GitHub API Swift
//
//  Created by Andreas Velounias on 01/10/2018.
//  Copyright © 2018 Andreas Velounias. All rights reserved.
//

import Foundation

extension URL {
    func asyncDownload(completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: self) {
            completion($0, $1, $2)
            }.resume()
    }
}
