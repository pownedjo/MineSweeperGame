import UIKit
import Foundation


/* */
class CellButton: UIButton
{
    var cell: Cell  // Cell instance
    let cellSize: CGFloat
    
    
    
    init(cell: Cell, cellSize: CGFloat)
    {
        self.cell = cell
        self.cellSize = cellSize
        
        let x = CGFloat(self.cell.column) * cellSize
        let y = CGFloat(self.cell.row) * cellSize
        let cellFrame = CGRect(x: x, y: y, width: cellSize, height: cellSize)
        
        super.init(frame: cellFrame)
    }
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // Return Title to display regarding Cell state
    func getLabelText() -> String
    {
        if !self.cell.isMined
        {
            if self.cell.numNeighboringMines == 0   // No mine && No mines on neighbors
            {
                return ""
            }
            else    // No Mine BUT mines on neighbors
            {
                return "\(self.cell.numNeighboringMines)"   // Determine text to display
            }
        }
        return "M"  // MINE
    }
    
    
    // Return Title to display regarding Cell Flag state
    func getFlagLabelText() -> String
    {
        if !self.cell.isFlagged
        {
            return "-"  // Back to defaut state
        }
        else
        {
            return "F"  // FLAG
        }
    }
    
}
