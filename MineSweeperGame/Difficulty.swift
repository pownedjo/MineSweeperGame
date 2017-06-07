import Foundation

/* GameDifficulty Enum Class
 
 Beginner – 9 * 9 Board and 10 Mines
 Intermediate – 16 * 16 Board and 40 Mines
 Advanced – 24 * 24 Board and 99 Mines (or 16 * 30 board size)
 
 */

public enum GameDifficulty
{
    case Begineer
    case Medium
    case Hard
    
    func getBoardAxisSize() -> Int
    {
        switch self {
        case .Begineer:
            return 10
        case .Medium:
            return 16
        case .Hard:
            return 24
        }
    }
    
    
    func getNumberOfCell() -> Int
    {
        switch self {
        case .Begineer:
            return 100
        case .Medium:
            return 256
        case .Hard:
            return 576
        }
    }
    
    
    func getMineLocProbability() -> Int
    {
        switch self {
        case .Begineer:
            return 10   // 10%
        case .Medium:
            return 40   // 15,6%
        case .Hard:
            return 99   // 17,2%
        }
    }
}
