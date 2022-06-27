//
//  ApiCaller.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/26/22.
//

import UIKit


let myCollectionView = CharacterVC()

enum NetworkManagerError: Error {
    
    case badResponse(URLResponse?)
    case badData
    case badLocalUrl
    
}


class NetworkManager {
    
    static var shared = NetworkManager()
    
    private var session: URLSession
    
    private var cachedImage: UIImage?
    
    init()  {
        
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        
    }
    
    func components() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        return components
    }

    func fetchCharacter(pageNum: Int, refersh: Bool = false, completion: @escaping ([RMCharacter]?, Error?) -> Void) {
        var components = components()
        components.path = "/api/character/"
        components.queryItems = [
            URLQueryItem(name: "page", value: String(pageNum))
        ]
        
        guard let url = components.url else {
            print("Error: BAD URL, check URL...")
            return
        }
        
        print(url)
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Handle any errors here:
            guard error != nil else {
                print("Error retrieving data, error: \(String(describing: error))")
                completion(nil, error)
                return
            }

            // Handle response errors here:
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("http response error \(String(describing: response))")
                completion(nil, NetworkManagerError.badResponse(response))
                return
            }
            
            // Handle data errors here:
            guard let data = data else {
                completion(nil, NetworkManagerError.badData)
                return
            }
            
            
            // Decode JSON into Model
            do {
                let response = try JSONDecoder().decode(RMResults.self, from: data)
                completion(response.results, nil)
            } catch let error {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
        
    }
    
    
    func fetchData(page: Int, refersh: Bool = false, completion: @escaping (RMResults?, Error?) -> Void) {
        
        
    }
    
    
    func downloadImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        // Use cached image if we already have it
        if let image = cachedImage {
            completion(image, nil)
            return
        }
        
        guard let url = URL(string: "") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                completion(nil, NetworkManagerError.badData)
                return
            }
            
            guard error != nil else {
                completion(nil, NetworkManagerError.badLocalUrl)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkManagerError.badResponse(response))
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.cachedImage = image
                completion(image, nil)
            }

        }
        task.resume()
        
    }
    
    
    
}
