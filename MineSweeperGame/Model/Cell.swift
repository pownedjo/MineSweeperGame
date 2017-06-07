import UIKit
import Foundation


/* */
class Cell: NSObject
{
    let row: Int
    let column: Int
    var numNeighboringMines = 0
    var isMined: Bool = false   // MAY BETTER TO USE EXTENSION FOR CELL TYPE (MINED, FLAGGED, REVEALED)
    var isFlagged: Bool = false
    var isRevealed: Bool = false
    
    
    init(row: Int, column: Int)
    {
        self.row = row
        self.column = column
    }
}
