import SwiftUI

enum CatalogAsset: String {
    case rightChevron = "chevron.right.2"
    
    var image: Image {
        Image(systemName: rawValue)
    }
}
