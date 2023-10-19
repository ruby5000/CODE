import Foundation
import UIKit
import SystemConfiguration
import CoreLocation


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
  //    viewName.backgroundColor = UIColor.white
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

enum mathFunction {
  case Add
  case Subtract
}

class AFWrapperClass : NSObject {
  class func compareStringValue(currentValue:String, limit:Int, toDo : mathFunction) -> String {
    var current : Int = Int(currentValue)!
    if (current <= limit) && (current >= 0) {
      if toDo == .Add {
        if current == limit {
          return String(current)
        }
        else{
          current += 1
          return String(current)
        }
      }
      else {
        if current == 1 {
          return String(current)
        }
        else {
          current -= 1
          return String(current)
        }
      }
    }
    else {
      return String(current)
    }
  }
}
class RectangularDashedView: UIView {

  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  @IBInspectable var dashWidth: CGFloat = 0
  @IBInspectable var dashColor: UIColor = .clear
  @IBInspectable var dashLength: CGFloat = 0
  @IBInspectable var betweenDashesSpace: CGFloat = 0

  var dashBorder: CAShapeLayer?

  override func layoutSubviews() {
    super.layoutSubviews()
    dashBorder?.removeFromSuperlayer()
    let dashBorder = CAShapeLayer()
    dashBorder.lineWidth = dashWidth
    dashBorder.strokeColor = dashColor.cgColor
    dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
    dashBorder.frame = bounds
    dashBorder.fillColor = nil
    if cornerRadius > 0 {
      dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    } else {
      dashBorder.path = UIBezierPath(rect: bounds).cgPath
    }
    layer.addSublayer(dashBorder)
    self.dashBorder = dashBorder
  }
}
extension UIView {
  @IBInspectable
  var cornerRadiuss: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }

  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  @IBInspectable
  var borderColor: UIColor? {
    get {
      if let color = layer.borderColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.borderColor = color.cgColor
      } else {
        layer.borderColor = nil
      }
    }
  }
}
extension UITextField{
  @IBInspectable var placeHolderColor: UIColor? {
    get {
      return self.placeHolderColor
    }
    set {
      self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor : newValue!])
    }
  }
}

//MARK:- CST Time Date Change
func CSTToAssignDateFormateDate(strDate:String) -> String{
  let dateFormatter = DateFormatter()
  let timeZone = TimeZone(identifier: "CST")
  dateFormatter.timeZone = timeZone
  dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"

  guard let date = dateFormatter.date(from: strDate) else {
    return ""
  }
  let dateFormatter1 = DateFormatter()
  dateFormatter1.timeZone = .current
  dateFormatter1.dateFormat = "MM/dd/yyyy hh:mm a"
  let dateString = dateFormatter1.string(from: date)
  return dateString
}
// Calling function
func callNumber(phoneNumber: String) {
  guard let url = URL(string: "telprompt://\(phoneNumber)"),
        UIApplication.shared.canOpenURL(url) else {
          return
        }
  UIApplication.shared.open(url, options: [:], completionHandler: nil)
}


public func daysBetween(start: Date, end: Date) -> Int {
  let fromDate = Calendar.current.startOfDay(for: start)
  let toDate = Calendar.current.startOfDay(for: end)
  let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)

  return numberOfDays.day! // <1>
}
public func setBorder(viewName: UIView , borderwidth : Float , borderColor: CGColor , cornerRadius: CGFloat)
{
  //    viewName.backgroundColor = UIColor.clear
  viewName.layer.borderWidth = CGFloat(borderwidth)
  viewName.layer.borderColor = borderColor
  viewName.layer.cornerRadius = cornerRadius
}


func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
  let calendar = NSCalendar.current
  let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
  let now = NSDate()
  let earliest = now.earlierDate(date as Date)
  let latest = (earliest == now as Date) ? date : now
  let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)

  if (components.year! >= 2) {
    return "\(components.year!) years ago"
  } else if (components.year! >= 1){
    if (numericDates){
      return "1 year ago"
    } else {
      return "Last year"
    }
  } else if (components.month! >= 2) {
    return "\(components.month!) months ago"
  } else if (components.month! >= 1){
    if (numericDates){
      return "1 month ago"
    } else {
      return "Last month"
    }
  } else if (components.weekOfYear! >= 2) {
    return "\(components.weekOfYear!) weeks ago"
  } else if (components.weekOfYear! >= 1){
    if (numericDates){
      return "1 week ago"
    } else {
      return "Last week"
    }
  } else if (components.day! >= 2) {
    return "\(components.day!) days ago"
  } else if (components.day! >= 1){
    if (numericDates){
      return "1 day ago"
    } else {
      return "Yesterday"
    }
  } else if (components.hour! >= 2) {
    return "\(components.hour!) hours ago"
  } else if (components.hour! >= 1){
    if (numericDates){
      return "1 hour ago"
    } else {
      return "An hour ago"
    }
  } else if (components.minute! >= 2) {
    return "\(components.minute!) minutes ago"
  } else if (components.minute! >= 1){
    if (numericDates){
      return "1 minute ago"
    } else {
      return "A minute ago"
    }
  } else if (components.second! >= 3) {
    return "\(components.second!) seconds ago"
  } else {
    return "Just now"
  }

}


extension UITextField {
  //MARK:- Set Image on the right of text fields
  func setupRightImage(imageName:String){
    let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 16, height: 16))
    imageView.image = UIImage(named: imageName)
    let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    imageContainerView.addSubview(imageView)
    rightView = imageContainerView
    rightViewMode = .always
    self.tintColor = .lightGray
  }

  //MARK:- Set Image on left of text fields

  func setupLeftImage(imageName:String){
    let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
    imageView.image = UIImage(named: imageName)
    let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
    imageContainerView.addSubview(imageView)
    leftView = imageContainerView
    leftViewMode = .always
    self.tintColor = .lightGray
  }

}
