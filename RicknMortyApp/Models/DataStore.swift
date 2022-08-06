//
//  DataStore.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/6/22.
//

import UIKit


class DataStore {
    var rmCharacters: [RMCharacter]

    init(character: [RMCharacter]) {
        self.rmCharacters = character
    }

    func follower(with id: Int) -> RMCharacter? {
        return rmCharacters.first(where: { $0.id == id })
    }

}

