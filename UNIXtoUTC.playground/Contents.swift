import UIKit



let UNIX = 1673744715



func convertUNIX(dt: Int) -> String {
    
    let dateFormatter = Date(timeIntervalSince1970: TimeInterval(dt)).formatted(.dateTime.day().month())
    
    
    return dateFormatter
}



print(convertUNIX(dt: UNIX))


extension Date {
    
    var justTheDayMonth: String {
        self.formatted(.dateTime.day().month())
    }
    
    
}
