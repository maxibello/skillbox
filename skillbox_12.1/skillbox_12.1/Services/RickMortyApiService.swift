//
//  HTTPService.swift
//  skillbox_12.1
//
//  Created by Максим Кузнецов on 06.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation
import Alamofire

class RickMortyApiService {
    
    static let imageCache = NSCache<NSString, UIImage>()
    
    static func loadCharacters(with request: DataRequest, completion: @escaping (Result<CharactersResponse, AFError>) -> Void) {
        request
        .validate()
        .responseDecodable(of: CharactersResponse.self) { (response) in
            DispatchQueue.main.async {
                completion(response.result)
            }
            
        }
    }
    
    static func createNewReqest(for page: Int) -> DataRequest {
        return AF.request("https://rickandmortyapi.com/api/character/?page=\(page)")
    }
    
    static func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data, let image = UIImage(data: data) {
                    
//                    data.write(to: <#T##URL#>, options: .atomic)
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                } else {
                    completion(nil, CFNetworkErrors.cfErrorHTTPParseFailure as? Error)
                }
            }.resume()
        }
    }
}
