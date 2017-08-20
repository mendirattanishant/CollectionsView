//
//  ServerUtils.swift
//  Mercari
//
//  Created by Nishant Mendiratta on 8/20/17.
//  Copyright © 2017 Mercari. All rights reserved.
//

import Foundation

var serverUtils : ServerUtils {
    return ServerUtils.instance()
}


class ServerUtils {
    #if DEBUG
    
    /// - Returns: The previous implementation, which can be used for un-stubbing.
    public static func stubInstance(with stub:ServerUtils) -> ServerUtils {
        let impl = _instance
        _instance = stub
        return impl
    }
    #endif
    
    private static var _instance = ServerUtils()
    
    /// Singleton instance
    class func instance() -> ServerUtils {
        return _instance
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
