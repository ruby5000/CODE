//
//  Constant.swift
//

import Foundation
import UIKit
import SystemConfiguration
import CoreLocation


// MARK:- All Alert Messages

let MESSAGE_ERR_NETWORK = "No internet connection. Try again.."
let ALL_MESSAGE = "Please enter all details."
let EMAIL_MESSAGE = "Please enter the email address."
let PASSWORD_MESSAGE = "Please enter password."
let CONFIRMPASSWORD_MESSAGE = "Please enter confirm password."
let FIRST_MESSAGE = "Please enter first name."
let LASTNAME_MESSAGE = "Please enter last name."
let PHONE_MESSAGE = "Please enter phone number."
let OTP_MESSAGE = "Please enter otp."
let VALID_EMAIL_MESSAGE = "Please enter the valid email address."
let VALID_MOBILE_MESSAGE = "Please enter the valid phone number."
let PASSWORD_CONFIRM_MESAAGE = "Password & confirm password must be same."

let CART_CONFIRM_MESAAGE = "Product added successfully in cart."
let ALREADYCART_CONFIRM_MESSAGE = "Product already in the cart! Do you want to add it again?"
let SELECT_ADDRESS_MESAAGE = "Please select address."
let ENTER_ADDRESS_MESAAGE = "Please enter address."
let ENTER_CITY_MESAAGE = "Please enter city."
let ENTER_POSTCODE_MESAAGE = "Please enter postcode."
let ENTER_COUNTRY_MESAAGE = "Please enter country."
let ENTER_STATE_MESAAGE = "Please enter region / state."
let ENTER_COMPANY_MESAAGE = "Please enter company."
let ENTER_TYPE_MESAAGE = "Please enter save address."
let PROMOCODE_MESAAGE = "Please enter promocode."
let VALID_POSTCODE_MESSAGE = "Please enter valid promocode."


let ENTER_DELIVERY_ADDRESS_MESAAGE = "Please enter delivery address."
let ENTER_DELIVERY_CITY_MESAAGE = "Please enter delivery city."
let ENTER_DELIVERY_POSTCODE_MESAAGE = "Please enter delivery postcode."
let ENTER_DELIVERY_COUNTRY_MESAAGE = "Please enter delivery country."
let ENTER_DELIVERY_STATE_MESAAGE = "Please enter delivery region / state."
let SELECT_TERMSCONDITION_MESAAGE = "Please agree to the Terms & Conditions."



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
