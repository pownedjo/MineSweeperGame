import Foundation
import UIKit


let infoAlertMessage: String = "The objective of the game is to clear a rectangular board containing hidden mines without detonating any of them, with help from clues about the number of neighboring mines in each field.\n\nThe size of the Board and the number of mines are set in advance by selecting the difficulty :\n\nBegineer : 10*10 (10mines)\nMedium : 16*16 (40 mines)\nHard : 24*24 (99 mines)\n\nThe game ends when User hits a mine or revealed all cells without mines.\n\nGood luck!"


// Handle AlertView creation
func handleAlertView(title: String, message: String) -> UIAlertController
{
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: UIAlertControllerStyle.alert)
    
    let cancelAction = UIAlertAction(title: "OK",
                                     style: .cancel, handler: nil)
    
    alert.addAction(cancelAction)
    return alert
}



// Convert Timer Doulbe value in String Value
func stringFromTimeInterval(interval: Double) -> String
{
    let time = NSInteger(interval)
    let ms = Int(interval.truncatingRemainder(dividingBy: 1) * 1000)
    
    let seconds = time % 60
    let minutes = (time / 60) % 60
    let hours = (time / 3600)
    
    return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
}
