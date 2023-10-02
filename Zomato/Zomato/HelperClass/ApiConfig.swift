import Foundation
import UIKit

//MARK: Urls
let API_URL = ""
let IMG_URL = ""

//MARK: Device info

let App_device_type = "ios"
let App_device_brand = "iphone"
let App_device_id = UIDevice.current.identifierForVendor?.uuidString
let App_device_name = UIDevice.current.model
let App_device_version = UIDevice.current.systemVersion
let App_version = Bundle.main.releaseVersionNumber
let api_version = "V1"

var formatter = NumberFormatter()

func setDecimalNumber()
{
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    formatter.locale = Locale(identifier: "en_US")
}
