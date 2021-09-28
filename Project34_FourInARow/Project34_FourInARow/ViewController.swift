//
//  ViewController.swift
//  Project34_FourInARow
//
//  Created by Tyler Edwards on 9/26/21.
//

import UIKit
import GameplayKit

enum Oponent: Int{
    case player = 0
    case easyAI = 4
    case normalAI = 7
    case hardAI = 8
}

class ViewController: UIViewController {
    @IBOutlet var columnButtons: [UIButton]!
    
    var placedChips = [[UIView]]()
    var board: Board!
    
    var strategist: GKMinmaxStrategist!
    
    var oponent = Oponent.normalAI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0 ..< Board.width {
            placedChips.append([UIView]())
        }
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .plain, target: self, action: #selector(showQuitAlert))
        
        strategist = GKMinmaxStrategist()
        strategist.maxLookAheadDepth = oponent.rawValue
        strategist.randomSource = nil//GKARC4RandomSource()
        
        resetBoard()
    }
    
    @objc func showQuitAlert() {
        let ac = UIAlertController(title: "Are you sure!", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let quitAction = UIAlertAction(title: "Quit", style: .destructive) { [unowned self] (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        ac.addAction(cancelAction)
        ac.addAction(quitAction)
        
        present(ac, animated: true)
    }
    
    func resetBoard() {
        board = Board()
        strategist.gameModel = board
        
        updateUI()
        
        for i in 0..<placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }
            
            placedChips[i].removeAll(keepingCapacity: true)
        }
    }
    
    func continueGame() {
        var gameOverTitle: String? = nil
        if board.isWin(for: board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name) Wins!"
        } else if board.isFull() {
            gameOverTitle = "Draw!"
        }
        
        if gameOverTitle != nil {
            let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            
            let playAgainAction = UIAlertAction(title: "Play Again", style: .default) { [unowned self] (action) in
                self.resetBoard()
            }
            
            let quitAction = UIAlertAction(title: "Quit", style: .default) { [unowned self] (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            alert.addAction(quitAction)
            alert.addAction(playAgainAction)
            present(alert, animated: true)
            
            return
        }
        
        board.currentPlayer = board.currentPlayer.opponent
        updateUI()
    }
    
    
    func updateUI() {
        title = "\(board.currentPlayer.name)'s Turn"
        
        if board.currentPlayer.chip == .black && oponent != .player {
            startAIMove()
        }
    }
    
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, color: board.currentPlayer.color)
            continueGame()
        }
    }
    
    func addChip(inColumn column: Int, row: Int, color: UIColor) {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        if (placedChips[column].count < row + 1) {
            let newChip = UIView()
            newChip.frame = rect
            newChip.isUserInteractionEnabled = false
            newChip.backgroundColor = color
            newChip.layer.cornerRadius = size / 2
            newChip.center = positionForChip(inColumn: column, row: row)
            newChip.transform = CGAffineTransform(translationX: 0, y: -800)
            view.addSubview(newChip)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                newChip.transform = CGAffineTransform.identity
            })
            
            placedChips[column].append(newChip)
        }
    }
    
    func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)
        
        let xOffset = button.frame.midX
        var yOffset = button.frame.maxY - size / 2
        yOffset -= size * CGFloat(row)
        return CGPoint(x: xOffset, y: yOffset)
    }
    
    //MARK: AI
    
    func columnForAIMove() -> Int? {
        if let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move {
            return aiMove.column
        }
        
        return nil
    }
    
    func makeAIMove(in column: Int) {
        columnButtons.forEach { $0.isEnabled = true }
        navigationItem.rightBarButtonItem = nil
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row:row, color: board.currentPlayer.color)
            
            continueGame()
        }
    }
    
    func startAIMove() {
        columnButtons.forEach { $0.isEnabled = false }
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        
        DispatchQueue.global().async { [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let column = self.columnForAIMove() else { return }
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            
            let aiTimeCeiling = 1.0
            let delay = aiTimeCeiling - delta
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.makeAIMove(in: column)
            }
        }
    }
    
}

