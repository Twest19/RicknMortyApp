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
    
    var session: URLSession
    
    private var images = NSCache<NSString, NSData>()
    
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

    func fetchCharacter(pageNum: Int, refersh: Bool = false, completion: @escaping (RMResults?, Error?) -> Void) {
        var components = components()
        components.path = "/api/character/"
        components.queryItems = [
            URLQueryItem(name: "page", value: String(pageNum))
        ]
        
        guard let url = components.url else {
            print("Error: BAD URL, check URL...")
            return
        }
        
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Handle any errors here:
            if let error = error {
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
                completion(response, nil)
            } catch let error {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
        
    }
    
    
    func downloadCharImage(character: String, completion: @escaping (Data?, Error?) -> (Void)) {
        
        guard let url = URL(string: character) else {
            print("Error getting image URL")
            return
        }
            
        if let imageData = images.object(forKey: url.absoluteString as NSString) {
            print("using cached image...")
            completion(imageData as Data, nil)
            return
        }
        
        let task = session.downloadTask(with: url) { localurl, urlresponse, error in
            
            // Handle any errors here:
            if let error = error {
                print("Error retrieving data, error: \(String(describing: error))")
                completion(nil, error)
                return
            }

            // Handle response errors here:
            guard let httpResponse = urlresponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("http response error \(String(describing: urlresponse))")
                completion(nil, NetworkManagerError.badResponse(urlresponse))
                return
            }
            
            // Handle data errors here:
            guard let localurl = localurl else {
                completion(nil, NetworkManagerError.badLocalUrl)
                return
            }
            
            // Add the image to the NSCache and call the completion handler and pass the data.
            do {
                let myData = try Data(contentsOf: localurl)
                self.images.setObject(myData as NSData, forKey: url.absoluteString as NSString)
                completion(myData, nil)
            } catch let error {
                completion(nil, error)
            }
        
        }
        task.resume()
        
    }
    
    
    
}
