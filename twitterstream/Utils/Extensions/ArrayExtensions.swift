//
//  ArrayExtensions.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 15/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import Foundation

extension Array {
    // Safely lookup an index that might be out of bounds,
    // returning nil if it does not exist
    func get(_ index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}
