import UIKit
import Foundation


class MainVC: UIViewController, UIGestureRecognizerDelegate
{
    @IBOutlet weak var gameDifficultySelector: UISegmentedControl!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playsLabel: UILabel!
    @IBOutlet weak var flagsLabel: UILabel!
    @IBOutlet weak var gameView: UIView!    // Maybe moove to its own Class (MVC like)
    @IBOutlet weak var playButton: UIButton!
    
    var grid: Grid!
    var cellButtons = [CellButton]()
    var seconde: Double = 0
    var timer = Timer()
    var flags: Int = 0
    var mineWithNoNeighbors: Int = 0

    var plays: Int = 0 {
        didSet {
            self.playsLabel.text = "Plays: \(plays)"
        }
    }
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    
    // Init Game Board with 2 for loops (row / col) according to selected Game Difficulty
    func initializeBoard()
    {
        for row in 0 ..< grid.difficulty.getBoardAxisSize()
        {
            for col in 0 ..< grid.difficulty.getBoardAxisSize()
            {
                let cell = grid.cells[row][col]
                let cellSize = self.gameView.frame.width / CGFloat(grid.difficulty.getBoardAxisSize())
                let cellButton = CellButton(cell: cell, cellSize: cellSize)
                let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
                longGesture.delegate = self
                longGesture.minimumPressDuration = 1    // 1 sec min long press duration (flag otpion)

                cellButton.setTitle("-", for: UIControlState()) // Default Label for each CellButton
                cellButton.setTitleColor(UIColor.darkGray, for: UIControlState())
                cellButton.addTarget(self, action: #selector(cellButtonPressed), for: .touchUpInside)
                cellButton.addGestureRecognizer(longGesture)
                
                self.gameView.addSubview(cellButton)
                self.cellButtons.append(cellButton)
            }
        }
    }
    
    
    func resetGrid()
    {
        self.grid.resetGrid()
        
        // Iterates through each CellButton and resets text to default value
        for cellButton in self.cellButtons
        {
            cellButton.setTitle("-", for: UIControlState())
        }
    }
    
    
    func startNewGame()
    {
        self.grid = Grid(difficulty: selectGameDifficulty())    // Init new Grid
        
        for views in self.gameView.subviews // Clean gameView (useful when starting new game)
        {
            views.removeFromSuperview()
        }

        self.resetGrid()
        self.seconde = 0
        self.plays = 0
        self.flags = 0
        self.gameDifficultySelector.isEnabled = false
        self.gameView.isUserInteractionEnabled = true
        self.playButton.setTitle("STOP", for: UIControlState())
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
    }

    
    func endCurrentGame()
    {
        self.timer.invalidate()
        self.gameDifficultySelector.isEnabled = true
        self.playButton.setTitle("START", for: UIControlState())
        self.grid = nil
        self.cellButtons = []
        self.gameView.isUserInteractionEnabled = false  // Disable GameView between each games
    }
    
    
    // Timer method
    func counter()
    {
        seconde += 0.01     // Update Timer each miliseconds
        timerLabel.text = stringFromTimeInterval(interval: seconde) // Convert timer value
    }
    
    
    // Change CellButton title according to Cell state
    func revealButtonWith(cell: Cell)
    {
        for buttons in self.cellButtons // TODO - refactor
        {
            if buttons.cell == cell
            {
                buttons.setTitle(buttons.getLabelText(), for: UIControlState())
                self.grid.remainingCell -= 1
                buttons.isEnabled = false
            }
        }
    }
    
    
    // Handle propagation features - check neigboring Cell for each Blank Cell
    func startPropagationFrom(cell: Cell)
    {
        revealNeighborsFor(cell: cell)  // TODO - refactor (cell not taken by getNeighboringCellsFrom)
        
        for acell in self.grid.getNeighboringCellsFrom(cell: cell)
        {
            revealNeighborsFor(cell: acell)
        }
    }
    
    
    
    func revealNeighborsFor(cell: Cell?)
    {
        if cell != nil  // Be sure to have a valid Cell
        {
            if (cell?.isRevealed)! || (cell?.isMined)! || (cell?.isFlagged)! { return }
            
            if cell?.numNeighboringMines != 0   // Cell with neighboring mines
            {
                cell?.isRevealed = true
                revealButtonWith(cell: cell!)
            }
            else    // Blank Cell
            {
                cell?.isRevealed = true
                revealButtonWith(cell: cell!)
                startPropagationFrom(cell: cell!)
            }
        }
    }
}



/* Handle User Action */
extension MainVC
{
    @IBAction func playButtonPressed(_ sender: Any)
    {
        if self.gameDifficultySelector.isEnabled == false   // Stop current game & clean game view
        {
            self.endCurrentGame()
        }
        else    // Play new Game & Init new Grid
        {
            startNewGame()
            initializeBoard()
        }
    }
    
    
    @IBAction func infoButtonPressed(_ sender: Any)
    {
        let infoAlert = handleAlertView(title: "MineSweeper Game Rules", message: infoAlertMessage)
        self.present(infoAlert, animated:  true)
    }
    
    
    // Change Game difficulty according to upper segmented control value (User selection)
    func selectGameDifficulty() -> GameDifficulty!
    {
        switch gameDifficultySelector.selectedSegmentIndex {
        case 0:
            return GameDifficulty.Begineer
        case 1:
            return GameDifficulty.Medium
        case 2:
            return GameDifficulty.Hard
        default:
            print("Default Selected Segment Index - should not happen!")
            return GameDifficulty.Begineer
        }
    }
    
    
    // Monitor User Regular Tapping
    func cellButtonPressed(_ sender: CellButton)
    {
        if sender.cell.isFlagged    // User hit a flagged Cell
        {
            sender.cell.isFlagged = false
            self.flags -= 1
            self.flagsLabel.text = "Flags : \(self.flags)"
            sender.setTitle("\(sender.getFlagLabelText())", for: UIControlState())
            return
        }
        
        if sender.cell.isMined  // User hit a mine
        {
            sender.setTitle("\(sender.getLabelText())", for: UIControlState())
            self.plays += 1
            minePressed()
            return
        }
        
        if sender.cell.isRevealed == false // User hit a not revealed Cell
        {
            if sender.cell.numNeighboringMines != 0
            {
                sender.cell.isRevealed = true
                self.plays += 1
                revealButtonWith(cell: sender.cell)
            }
            else
            {
                startPropagationFrom(cell: sender.cell)   // Propagation when User hits Blank Cell
                self.plays += 1
            }
            
            if self.grid.didUserWinGame()    // Check if User win the game
            {
                userWin()
            }
        }
    }
    
    
    // Monitor Long pressing for Flag placement option
    func handleGesture(gestureRecognizer: UILongPressGestureRecognizer)
    {
        if gestureRecognizer.state == UIGestureRecognizerState.ended    // Wait till the press' end
        {
            let tappedCellButton = gestureRecognizer.view as! CellButton
            
            if tappedCellButton.cell.isFlagged == false // Be sure that Cell has no Flag
            {
                tappedCellButton.cell.isFlagged = true
                self.flags += 1
                self.flagsLabel.text = "Flags : \(self.flags)"
                tappedCellButton.setTitle("\(tappedCellButton.getFlagLabelText())", for: UIControlState())
            }
        }
    }
}



/* Manage Game State */
extension MainVC
{
    // Handle Win Situation && End current Game
    func userWin()
    {
        endCurrentGame()
        
        let winAlert = handleAlertView(title: "You Win!", message: "Congrats! You finished the game with \(self.plays) moves in \(self.timerLabel.text!)s")
        self.present(winAlert, animated:  true)
    }
    
    
    // Handle Loose Situation && End current Game
    func minePressed()
    {
        endCurrentGame()
        
        let looseAlert = handleAlertView(title: "You Failed", message: "Too bad! You hit a mine on your \(self.plays) moves at \(self.timerLabel.text!)")
        self.present(looseAlert, animated: true)
    }
}
