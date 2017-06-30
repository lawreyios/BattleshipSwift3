//
//  GridCell.swift
//  Battleship
//
//  Created by Lawrence Tan on 30/6/17.
//  Copyright © 2017 Lawrey. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
    }
    
    func configureFor(grid: Grid, gameState: GameState) {
        switch gameState {
        case .Plan:
            imageView.isHidden = !grid.hasShip
        case .Playing:
            if grid.isHit && grid.hasShip {
                imageView.image = UIImage(named: "shipHit")
                imageView.isHidden = false
            } else if grid.isHit {
                imageView.image = UIImage(named: "hit")
                imageView.isHidden = false
            } else {
                imageView.isHidden = true
            }
        default:
            break
        }
    }
    
}
