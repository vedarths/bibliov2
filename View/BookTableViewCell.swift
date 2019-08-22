//
//  BookTableViewCell.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/21/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import UIKit

internal final class BookTableViewCell: UITableViewCell, Cell {
    // Outlets
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
