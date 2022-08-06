//
//  ApiCaller.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/26/22.
//

import UIKit

enum NetworkManagerError: Error {
    case badResponse(URLResponse?)
    case badData
    case badLocalUrl
}


class NetworkManager {
    
    static var shared = NetworkManager()
    
    private var session: URLSession
    
    private var images = NSCache<NSString, NSData>()
    
    
    private init()  {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    
    private func components() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        return components
    }
    
    
    private func characterComponents(with ID: String = "") -> URLComponents {
        var components = components()
        components.path = "/api/character/\(ID)"
        return components
    }
    
    
    private func episodeComponents(episodeNum: String) -> URLComponents {
        var components = components()
        components.path = "/api/episode/\(episodeNum)"
        return components
    }

    // MARK: FETCHS ALL CHARACTERS AND ALLOWS FOR SEARCHING OF SPECIFICS
    public func fetchCharacter(pageNum: Int, searchBarText: String = "", completion: @escaping (RMResults?, Error?) -> Void) {
        var components = characterComponents()
        let pages = URLQueryItem(name: "page", value: String(pageNum))
        let userCharacterSearch = URLQueryItem(name: "name", value: searchBarText)
        
        // Provides proper query items for URL
        if searchBarText == "" || searchBarText == " " {
            components.queryItems = [pages]
        } else {
            components.queryItems = [pages, userCharacterSearch]
        }
        
        // Checks URL
        guard let url = components.url else {
            print("Error: BAD URL, check URL...")
            return
        }
        
        print(url)
        
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
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(RMResults.self, from: data)
                completion(response, nil)
            } catch let error {
                print("ERROR DECODING")
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    
    func textEpisodeCharacter(with characterIDs: String) {
        let components = characterComponents(with: characterIDs)
        
        // Checks URL
        guard let url = components.url else {
            print("Error: BAD URL, check URL...")
            return
        }
        
        print(url)
    }
    
    // MARK: REQUEST FOR SPECIFIC EPISODES CHARACTER LIST
    public func getEpisodeCharacters(with characterIDs: String, completion: @escaping ([RMCharacter]?, Error?) -> (Void)) {
        let components = characterComponents(with: characterIDs)
        
        // Checks URL
        guard let url = components.url else {
            print("Error: BAD URL, check URL...")
            return
        }
        
        print(url)
        
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
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode([RMCharacter].self, from: data)
                completion(response, nil)
            } catch let error {
                print("ERROR DECODING")
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }

    // MARK: REQUEST FOR EPISODE DATA
    public func getEpisodeData(episodes: String, completion: @escaping ([Episode]?, Error?) -> (Void)) {
        let components = episodeComponents(episodeNum: episodes)

        // Checks URL
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
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            // Decode JSON into Episode Model
            do {
                let response = try decoder.decode([Episode].self, from: data)
                completion(response, nil)
            } catch let error {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    // MARK: DOWNLOADING IMAGES
    public func downloadCharImage(character: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        
        // Checks if Image has been cached and passes it back if so...
        if let imageData = images.object(forKey: character.absoluteString as NSString) {
//            print("using cached image...")
            completion(imageData as Data, nil)
            return
        }
        
        let task = session.downloadTask(with: character) { localurl, urlresponse, error in
//            print("...Not a cached Image")
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
            
            // Add the image to the NSCache and call the completion handler to pass the data.
            do {
                let myData = try Data(contentsOf: localurl)
                self.images.setObject(myData as NSData, forKey: character.absoluteString as NSString)
                completion(myData, nil)
            } catch let error {
                completion(nil, error)
            }
        
        }
        task.resume()
        
    }
    
    public func image(name: String, completion: @escaping (Data?, Error?) -> (Void)) {

        if let url = URL(string: name) {
            downloadCharImage(character: url, completion: completion)
        }
    }
}
