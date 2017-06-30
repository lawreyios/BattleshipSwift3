//
//  Board.swift
//  Battleship
//
//  Created by Lawrence Tan on 30/6/17.
//  Copyright © 2017 Lawrey. All rights reserved.
//

import Foundation

enum Team: Int {
    case A = 0
    case B = 1
    case none = -1
}

let letters = ["A", "B", "C", "D", "E", "F", "G", "H"]
let numbers = ["1", "2", "3", "4", "5", "6", "7", "8"]

protocol BoardDelegate {
    func placedShip()
    func firedGrid(hitShip: Bool)
}

class Board {
    var team: Team = .none
    var grids: [Grid]!
    var delegate: BoardDelegate?

    
    init(team: Team) {
        self.team = team
        self.grids = setupGrid()
    }
    
    private func setupGrid() -> [Grid] {
        var grids = [Grid]()
        for i in 0..<8 {
            for j in 0..<5 {
                let newGrid = Grid(letter: letters[i], number: numbers[j])
                grids.append(newGrid)
            }
        }
        return grids
    }
    
    func placeShip(at index: Int) {
        grids[index].hasShip = true
        self.delegate?.placedShip()
    }
    
    func tryHitShip(at index: Int) {
        grids[index].isHit = true
        self.delegate?.firedGrid(hitShip: grids[index].isHit && grids[index].hasShip)
    }
    
    
}

class Grid {
    var letter: String!
    var number: String!
    var hasShip: Bool = false
    var isHit: Bool = false
    
    init(letter: String, number: String) {
        self.letter = letter
        self.number = number
    }
    
}
