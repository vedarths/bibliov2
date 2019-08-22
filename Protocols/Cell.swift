//
//  Cell.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/21/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import UIKit

protocol Cell: class {
    /// A default reuse identifier for the cell class
    static var defaultReuseIdentifier: String { get }
}

extension Cell {
    static var defaultReuseIdentifier: String {
        // Should return the class's name, without namespacing or mangling.
        // This works as of Swift 3.1.1, but might be fragile.
        return "\(self)"
    }
}
