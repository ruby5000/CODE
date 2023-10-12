import Foundation
import UIKit
import SystemConfiguration
import CoreLocation
import NVActivityIndicatorView

var keyWindow = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .compactMap({$0 as? UIWindowScene})
    .first?.windows
    .filter({$0.isKeyWindow}).first
var MainstoryBoard = UIStoryboard(name: "Main", bundle: nil)

enum HttpResponseStatusCode: Int {
    case ok = 200
    case badRequest = 400
    case noAuthorization = 401
}

extension Bundle {
    var displayName: String? {
        return infoDictionary?["CFBundleDisplayName"] as? String
    }
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

public func Color_RGBA(_ R: Int,_ G: Int,_ B: Int,_ A: Int) -> UIColor {
    return UIColor(red: CGFloat(R)/255.0, green: CGFloat(G)/255.0, blue: CGFloat(B)/255.0, alpha :CGFloat(A))
}

public func SetCornerToView(_ view : UIView,BorderColor : UIColor,BorderWidth : CGFloat)    {
    view.layer.borderColor = BorderColor.cgColor;
    view.layer.borderWidth = BorderWidth;
}

public func setBorder(viewName: UIView , borderwidth : Int , borderColor: CGColor , cornerRadius: CGFloat) {
    viewName.layer.borderWidth = CGFloat(borderwidth)
    viewName.layer.borderColor = borderColor
    viewName.layer.cornerRadius = cornerRadius
    
}

func showAlertMsg(Message: String, AutoHide:Bool) -> Void {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: "", message: Message, preferredStyle: UIAlertController.Style.alert)
        if AutoHide == true {
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                print("Alert Dismiss")
                alert.dismiss(animated: true, completion:nil)
            }
        }
        else {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        }
        UIApplication.shared.windows[0].rootViewController?.present(alert, animated: true, completion: nil)
    }
}

func showAlertMessage(titleStr:String, messageStr:String) -> Void {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.shared.windows[0].rootViewController!.present(alert, animated: true, completion: nil)
    }
}

public func cornerRadius(viewName:UIView, radius: CGFloat) {
    viewName.layer.cornerRadius = radius
    viewName.layer.masksToBounds = true
}

public func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func getDocumentDirectoryPath() -> URL? {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
}

func getPhotoDirectoryPath() -> URL? {
    return FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).last
}

func nullToNil(value : AnyObject?) -> AnyObject? {
    if value is NSNull {
        return nil
    }
    else {
        return value
    }
}

func nullToNill(value : Any?) -> String? {
    if value is NSNull {
        return nil
    } else {
        return value as? String
    }
}

func randomString(length: Int) -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomString = ""
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}

func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    })
    else {
        return false
    }
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    let available =  (isReachable && !needsConnection)
    if(available) {
        return true
    }
    else {
        showAlertMsg(Message: "INTERNET_LOSS", AutoHide: true)
        return false
    }
}

func isValidateEmail(email:String) -> Bool {
    let emailRegx = "^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]{1}|[\\w-]{2,}))@"
    + "((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?"
    + "[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\."
    + "([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?"
    + "[0-9]{1,2}|25[0-5]|2[0-4][0-9])){1}|"
    + "([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})$"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegx)
    let result = emailTest.evaluate(with: email)
    return result
}

func isValidPassword(testStr:String) -> Bool {
    let passwordRegex = "^(?=^.{6,}$)(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\\s)[0-9a-zA-Z!@#$%^&*()]*$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: testStr)
}

func viewSlideInFromTop(toBottom views: UIView) {
    let transition = CATransition()
    transition.duration = 0.5
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromBottom
    views.layer.add(transition, forKey: nil)
}

func animateview(vw1 : UIView,vw2:UIView) {
    UIView.animate(withDuration: 0.1,
                   delay: 0.1,
                   options: UIView.AnimationOptions.curveEaseIn,
                   animations: { () -> Void in
        vw1.alpha = 0;
        vw2.alpha = 1;
    }, completion: { (finished) -> Void in
        vw1.isHidden = true;
    })
}

extension String {
    var toDouble: Double {
        return Double(self) ?? 0.00
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

