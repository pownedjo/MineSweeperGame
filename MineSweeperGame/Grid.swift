import UIKit
import Foundation


/* */
class Grid
{
    var cells = [[Cell]]()   // 2 dimensional Array of Cells
    var mines: Int = 0      // Number of mines on Grid
    var remainingCell: Int = 0  // Number of not revealed Cell
    var difficulty: GameDifficulty = .Begineer  // Default value

    
    
    init(difficulty: GameDifficulty)
    {
        self.difficulty = difficulty
        self.remainingCell = difficulty.getNumberOfCell()
        buildGrid()
    }
    
    
    
    private func buildGrid()
    {
        for row in 0 ..< difficulty.getBoardAxisSize()
        {
            var cellRow = [Cell]()
            
            for col in 0 ..< difficulty.getBoardAxisSize()
            {
                let cell = Cell(row: row, column: col)  // Create each Cell
                cellRow.append(cell)
            }
            cells.append(cellRow)
        }
    }
    
    
    
    func resetGrid()
    {
        // Assign mines randomly to Cells
        for row in 0 ..< difficulty.getBoardAxisSize()
        {
            for column in 0 ..< difficulty.getBoardAxisSize()
            {
                isMineFor(cell: cells[row][column])
            }
        }
        
        // Nb of neighboor Cell
        for row in 0 ..< difficulty.getBoardAxisSize()
        {
            for column in 0 ..< difficulty.getBoardAxisSize()
            {
                self.calculateNumNeighborMinesFor(cell: cells[row][column])
            }
        }
    }

    
    
    /* TODO - NEED TO REFACTOR THIS ONE FOR CHANGING DIFFICULTY PROPERLY (nb of mines and placement) */
    func isMineFor(cell: Cell)
    {
        cell.isMined = ((arc4random()%10) == 0) // 10% chance for each cell to get a mine
        
        if cell.isMined
        {
            mines += 1
        }
        
        if mines > difficulty.getMineLocProbability()
        {
            print("TOO MUCH MINE ON BOARD")
        }
    }
    
    

    // Check if User has won the game
    func didUserWinGame() -> Bool
    {
        if mines == remainingCell
        {
            return true  // If the number of Cell that are covered up is the same as the number of mines
        }
        return false
    }

    
    
    func calculateNumNeighborMinesFor(cell: Cell)
    {
        let neighbors = getNeighboringCellsFrom(cell: cell)   // List of adjacent Cells
        var numNeighboringMines = 0
        
        // for each neighbor with a mine, add 1 to this square's count
        for neighborSquare in neighbors
        {
            if neighborSquare.isMined
            {
                numNeighboringMines += 1
            }
        }
        cell.numNeighboringMines = numNeighboringMines
    }
    
    
    
    // Return Array of neighboring Cells
    func getNeighboringCellsFrom(cell: Cell) -> [Cell]
    {
        var neighbors = [Cell]()
        // Array of tuples for position of each neighbor to current Cell
        let adjacentOffsets =
            [(-1,-1),(0,-1),(1,-1),     // Upper row
            (-1,0),(1,0),               // Left side col & Right side col
            (-1,1),(0,1),(1,1)]         // Below row
        
        for (rowOffset, colOffset) in adjacentOffsets
        {
            let optionalNeighbor: Cell? = getTileAtLocation(row: cell.row+rowOffset, column: cell.column+colOffset)
            
            if let neighbor = optionalNeighbor  // Be sure to have a non nil Cell
            {
                neighbors.append(neighbor)
            }
        }
        return neighbors
    }
    
    
    
    func getTileAtLocation(row: Int, column: Int) -> Cell?
    {
        if row >= 0 && row < self.difficulty.getBoardAxisSize() && column >= 0 && column < self.difficulty.getBoardAxisSize()
        {
            return cells[row][column]
        }
        else
        {
            return nil
        }
    }
}
