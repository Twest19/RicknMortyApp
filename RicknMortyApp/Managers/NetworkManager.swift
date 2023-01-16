//
//  NetworkManager.swift
//  RicknMortyApp
//

import UIKit


class NetworkManager {
    // MARK: ALL network requests below use a completion handler with a result type!
    
    static var shared = NetworkManager()
    
    private var session: URLSession
    
    private var images = NSCache<NSString, NSData>()
    
    
    private init()  {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }

    // MARK: FETCHS ALL CHARACTERS AND ALLOWS FOR SEARCHING OF SPECIFIC CHARACTERS
    public func getCharacters(pageNum: Int, searchBarText: String = "", completion: @escaping (Result<RMResults, RMError>) -> Void) {
        // Create the Character URL
        let url = CharacterURLManager.shared.createCharacterURL(pageNum: pageNum, searchBarText: searchBarText)
        
        // Checks URL
        guard let url = url else {
            completion(.failure(.invalidCharacter))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Handle any errors here:
            if let error = error {
                print("Error retrieving data, error: \(String(describing: error))")
                completion(.failure(.unableToComplete))
                return
            }

            // Handle response errors here:
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("When enter invalid search")
                completion(.failure(.responseError))
                return
            }
            
            // Handle data errors here:
            guard let data = data else {
                completion(.failure(.badDataError))
                return
            }
            
            // Decode JSON into Model
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(RMResults.self, from: data)
                completion(.success(response))
            } catch let error {
                print("ERROR DECODING")
                print(error)
                completion(.failure(.badDataError))
            }
        }
        task.resume()
    }
    
    // MARK: REQUEST FOR A SPECIFIC EPISODE'S CHARACTER LIST
    public func getCharacters(using characterIDs: String, completion: @escaping (Result<[RMCharacter], RMError>) -> Void) {
        let components = CharacterURLManager.shared.characterComponents(with: characterIDs)
        
        // Checks URL
        guard let url = components.url else {
            completion(.failure(.invalidCharacter))
            return
        }
                
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Handle any errors here:
            if let error = error {
                print("Error retrieving data, error: \(String(describing: error))")
                completion(.failure(.unableToComplete))
                return
            }

            // Handle response errors here:
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("http response error \(String(describing: response))")
                completion(.failure(.responseError))
                return
            }
            
            // Handle data errors here:
            guard let data = data else {
                completion(.failure(.badDataError))
                return
            }
            
            // Decode JSON into Model
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode([RMCharacter].self, from: data)
                completion(.success(response))
            } catch let error {
                print("ERROR DECODING")
                print(error)
                completion(.failure(.badDataError))
            }
        }
        task.resume()
    }
    
    
    // MARK: FETCHS ALL EPISODES
    public func getEpisode(pageNum: Int, completion: @escaping (Result<EpisodeResults, RMError>) -> Void) {
        let url = EpisodeURLManager.shared.createEpisodeURL(pageNum: pageNum)
        
        // Checks URL
        guard let url = url else {
            completion(.failure(.invalidCharacter))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Handle any errors here:
            if let error = error {
                print("Error retrieving data, error: \(String(describing: error))")
                completion(.failure(.unableToComplete))
                return
            }

            // Handle response errors here:
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Response Error \(String(describing: response))")
                completion(.failure(.responseError))
                return
            }
            
            // Handle data errors here:
            guard let data = data else {
                completion(.failure(.badDataError))
                return
            }
            
            // Decode JSON into Model
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let response = try decoder.decode(EpisodeResults.self, from: data)
                //print(response)
                completion(.success(response))
            } catch let error {
                print("ERROR DECODING")
                print(error)
                completion(.failure(.badDataError))
            }
        }
        task.resume()
    }
    

    // MARK: REQUEST FOR EPISODE DATA
    public func getEpisodeData(episodes: String, completion: @escaping (Result<[Episode], RMError>) -> Void) {
        let components = EpisodeURLManager.shared.episodeComponents(episodeNum: episodes)

        // Checks URL
        guard let url = components.url else {
            print("Invalid Character URL")
            completion(.failure(.invalidCharacter))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            // Handle any errors here:
            if let error = error {
                print("Error retrieving data, error: \(String(describing: error))")
                completion(.failure(.unableToComplete))
                return
            }

            // Handle response errors here:
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("http response error \(String(describing: response))")
                completion(.failure(.responseError))
                return
            }

            // Handle data errors here:
            guard let data = data else {
                completion(.failure(.badDataError))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            // Decode JSON into Episode Model
            do {
                let response = try decoder.decode([Episode].self, from: data)
                completion(.success(response))
            } catch let error {
                print(error) // print error for debugging
                completion(.failure(.badDataError))
            }
        }
        task.resume()
    }
    
    // MARK: DOWNLOADING IMAGE AND CACHE
    public func downloadAndCacheImageFor(character: URL, completion: @escaping (Result<Data, RMError>) -> Void) {
        
        // Checks if Image has been cached and passes it back if so...
        if let imageData = images.object(forKey: character.absoluteString as NSString) {
            completion(.success(imageData as Data))
            return
        }
        
        let task = session.downloadTask(with: character) { localurl, urlresponse, error in
            // Handle any errors here:
            if let error = error {
                print("Error retrieving data, error: \(String(describing: error))")
                completion(.failure(.unableToComplete))
                return
            }

            // Handle response errors here:
            guard let httpResponse = urlresponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("http response error \(String(describing: urlresponse))")
                completion(.failure(.responseError))
                return
            }
            
            // Handle data errors here:
            guard let localurl = localurl else {
                completion(.failure(.badLocalUrl))
                return
            }
            
            // Add the image to the NSCache and call the completion handler to pass the data.
            do {
                let myData = try Data(contentsOf: localurl)
                self.images.setObject(myData as NSData, forKey: character.absoluteString as NSString)
                completion(.success(myData))
            } catch {
                completion(.failure(.badDataError))
            }
        }
        task.resume()
    }
    
    
    public func downloadImageUsing(URLString: String, completion: @escaping (Result<Data, RMError>) -> Void) {

        if let url = URL(string: URLString) {
            downloadAndCacheImageFor(character: url, completion: completion)
        }
    }
}
