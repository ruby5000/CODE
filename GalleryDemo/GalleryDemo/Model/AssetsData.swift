import Foundation
import UIKit
import Photos

struct AssetsData {
    var asset: PHAsset?
    var url: URL?
    var localURL: URL?
    var image: UIImage?
    var localImage: UIImage?
}

struct StoriesData {
    var image: UIImage?
    var title: String?
}

struct AlbumData {
    var image: UIImage?
    var title: String?
    var count: Int?
}

struct MediaData {
    var icon: UIImage?
    var title: String?
}

enum Albums {
    case allPhotos
    case recent
    case videos
    case favourite
    case other
    case portrait
    case burst
    case animated
    case highDefination
    case screenshots
    case place
    case bin
}
