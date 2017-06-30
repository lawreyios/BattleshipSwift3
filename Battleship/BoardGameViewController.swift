//
//  ViewController.swift
//  Battleship
//
//  Created by Lawrence Tan on 30/6/17.
//  Copyright © 2017 Lawrey. All rights reserved.
//

import UIKit

let teamAStrings =
    ["Team A place 3 ships",
     "Team A GO!",
     "Team A HIT!",
     "Team A MISSES!",
     "Team A WON!",
]

let teamBStrings =
    ["Team B place 3 ships",
     "Team B GO!",
     "Team B HIT!",
     "Team B MISSES!",
     "Team B WON!",
]

enum GameState {
    case Plan
    case Playing
    case GameOver
}

class RoundedButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
    }
}

class BoardGameViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var startGameButton: RoundedButton!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var boardA: Board!
    var boardB: Board!
    
    @IBOutlet weak var teamBButton: RoundedButton!
    @IBOutlet weak var teamAButton: RoundedButton!
    
    var currentTeam: Team = .none {
        didSet {
            teamAButton.isSelected = currentTeam == .A
            teamBButton.isSelected = currentTeam == .B
        }
    }
    
    var gameState: GameState = .Plan
    
    var totalShipsPlaced: Int = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentTeam = .A
        self.bottomLabel.text = teamAStrings[0]
        self.setupGrids()
        self.collectionView.backgroundColor = UIColor.clear
    }

    fileprivate func setupGrids() {
        self.boardA = Board(team: .A)
        self.boardA.delegate = self
        
        self.boardB = Board(team: .B)
        self.boardB.delegate = self
        
        self.collectionView.reloadData()
    }

    
    @IBAction func teamATapped(_ sender: Any) {
        self.currentTeam = .A
        self.bottomLabel.text = teamAStrings[1]
        self.collectionView.reloadData()
    }
    
    @IBAction func teamBTapped(_ sender: Any) {
        self.currentTeam = .B
        self.bottomLabel.text = teamBStrings[1]
        self.collectionView.reloadData()
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        self.currentTeam = .A
        self.setupGrids()
        self.bottomLabel.text = teamAStrings[0]
        self.gameState = .Plan
        self.totalShipsPlaced = 0
        self.collectionView.reloadData()
    }
    
    var board: Board {
        switch currentTeam {
        case .A:
            return self.boardA
        case .B:
            return self.boardB
        default:
            return Board(team: .none)
        }
    }
}


extension BoardGameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch gameState {
        case .Plan:
            let grid = board.grids[indexPath.row]
            if !grid.hasShip { board.placeShip(at: indexPath.row) } else {
                let alert = UIAlertController(title: "", message: "Please place elsewhere", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        case .Playing:
            let grid = board.grids[indexPath.row]
            if !grid.isHit { board.tryHitShip(at: indexPath.row) } else {
                let alert = UIAlertController(title: "", message: "Please hit elsewhere", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
}

extension BoardGameViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return board.grids.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
        
        cell.configureFor(grid: board.grids[indexPath.row], gameState: gameState)
        
        return cell
    }
    
}

extension BoardGameViewController: BoardDelegate {
    func placedShip() {
        if gameState == .Plan {
            self.totalShipsPlaced += 1
            self.collectionView.reloadData()
            
            if self.totalShipsPlaced == 3  {
                self.collectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.currentTeam = .B
                    self.bottomLabel.text = teamBStrings[0]
                    self.collectionView.reloadData()
                }
            }
            
            if self.totalShipsPlaced == 6 {
                self.collectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.currentTeam = .A
                    self.bottomLabel.text = teamAStrings[1]
                    self.gameState = .Playing
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func firedGrid(hitShip: Bool) {
        if currentTeam == .A {
            self.bottomLabel.text = hitShip ? teamAStrings[2] : teamAStrings[3]
        }else if currentTeam == .B {
            self.bottomLabel.text = hitShip ? teamBStrings[2] : teamBStrings[3]
        }
        self.collectionView.reloadData()
    }
    
}
