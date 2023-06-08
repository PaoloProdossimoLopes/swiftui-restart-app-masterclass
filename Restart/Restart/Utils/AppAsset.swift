import SwiftUI

enum AppAsset: String {
    case man = "man.character"
    case woman = "woman.character"
    
    var image: Image {
        Image(rawValue)
    }
}
