//
//  RMError.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/7/22.
//

import Foundation


enum RMError: String, Error {
    
    case invalidCharacter = "Character created an invlaid request. Check your spelling and try again."
    case unableToComplete = "Unable to complete your request. Please check your connection and try again."
    case responseError = "Invalid response from server. Check your connection or your search and try again."
    case badDataError = "Bad data received from the server. Please try again."
    case badLocalUrl = "Bad url"
}
