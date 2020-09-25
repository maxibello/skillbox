//
//  BlackStarApiService.swift
//  BlackStar
//
//  Created by Максим on 27.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Alamofire

class BlackStarApiService {
    
    
    static func loadCategories(completion: @escaping (Result<DecodedArray<Category>, AFError>) -> Void) {

        AF.request("https://blackstarshop.ru/index.php?route=api/v1/categories")
            .validate()
            .responseDecodable(of: DecodedArray<Category>.self) { response in
                DispatchQueue.main.async {
                    completion(response.result)
                }
        }
    }
    
    static func downloadImage(from relativePath: String, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        
        guard let url = URL(string: "https://blackstarshop.ru/\(relativePath)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(nil, error)
            } else if let data = data, let image = UIImage(data: data) {
                completion(image, nil)
            } else {
                completion(nil, CFNetworkErrors.cfErrorHTTPParseFailure as? Error)
            }
        }.resume()
        
    }
}
