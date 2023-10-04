import UIKit
import Foundation
import SystemConfiguration
import Alamofire
import SwiftyJSON
import MBProgressHUD


class WebServices: NSObject {
  var operationQueue = OperationQueue()
  func CallGlobalAPI(url:String, headers:NSDictionary, parameters:NSDictionary, httpMethod:String, progressView:Bool, uiView:UIView, networkAlert:Bool, responseDict:@escaping (_ jsonResponce:JSON?, _ strErrorMessage:String) -> Void) {
    if progressView == true {
      self.ProgressViewShow(uiView:uiView)
    }
    let operation = BlockOperation.init {
      DispatchQueue.global(qos: .background).async {
        if isConnectedToNetwork() {
          if (httpMethod == "POST") {
            var req = URLRequest(url: try! url.asURL())
            req.httpMethod = "POST"
            req.allHTTPHeaderFields = headers as? [String:String]
            req.setValue("application/json", forHTTPHeaderField: "content-type")
            req.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
            req.timeoutInterval = 30
            AF.request(req).responseJSON { response in
              switch (response.result) {
                case .success:
                  if((response.value) != nil) {
                    let jsonResponce = JSON(response.value!)
                    DispatchQueue.main.async {
                      self.ProgressViewHide(uiView: uiView)
                      responseDict(jsonResponce,"")
                    }
                  }
                  break
                case .failure(let error):
                  print(error.localizedDescription)
                  self.ProgressViewHide(uiView: uiView)
                  showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Server couldn't responding. Please try again later.")
                  break
              }
            }
          }
          else if (httpMethod == "GET") {
            var req = URLRequest(url: try! url.asURL())
            req.httpMethod = "GET"
            req.allHTTPHeaderFields = headers as? [String:String]
            req.setValue("application/json", forHTTPHeaderField: "content-type")
            req.timeoutInterval = 30
            AF.request(req).responseJSON { response in
              switch (response.result)  {
                case .success:
                  if((response.value) != nil) {
                    let jsonResponce = JSON(response.value!)
                    DispatchQueue.main.async {
                      self.ProgressViewHide(uiView: uiView)
                      responseDict(jsonResponce,"")
                    }
                  }
                  break
                case .failure(let error):
                  print(error.localizedDescription)
                  self.ProgressViewHide(uiView: uiView)
                  showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Server couldn't responding. Please try again later.")
                  break
              }
            }
          }
        }
        else {
          self.ProgressViewHide(uiView: uiView)
          if networkAlert == true {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "No internet connection. Try again.")
          }
        }
      }
    }
    operation.queuePriority = .normal
    operationQueue.addOperation(operation)
  }
  func ProgressViewShow(uiView:UIView) {
    DispatchQueue.main.async {
      MBProgressHUD.showAdded(to: uiView, animated: true)
    }
  }
  func ProgressViewHide(uiView:UIView) {
    DispatchQueue.main.async {
      MBProgressHUD.hide(for:uiView, animated: true)
    }
  }
  func multipartWebService(method:HTTPMethod, URLString:String, encoding:Alamofire.ParameterEncoding, parameters:[String: Any], fileData:Data!, fileUrl:URL?, headers:HTTPHeaders, keyName:String, completion: @escaping (_ response:AnyObject?, _ error: NSError?, _ statusCode:String) -> ()){

    print("Fetching WS : \(URLString)")
    print("With parameters : \(parameters)")

    if  !NetworkReachabilityManager()!.isReachable {
      showAlertMessage(titleStr: "Error!", messageStr: MESSAGE_ERR_NETWORK)
      return
    }

    AF.upload(multipartFormData: { MultipartFormData in
      for (key, value) in parameters {
        MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)

      }
      let name = randomString(length: 8)
      if let data = fileData{
        MultipartFormData.append(data, withName: keyName, fileName: "skillgift_\(name).jpeg", mimeType: "image/jpeg")
      }
    }, to: URLString, method: .post, headers: headers)
      .responseData { (response) in
        if let statusCode = response.response?.statusCode {
          if  statusCode == HttpResponseStatusCode.noAuthorization.rawValue {
            guard let data = response.data
            else {
              showAlertMessage(titleStr: "Error!", messageStr: "Something went wrong.. Try again.")
              return
            }
            do {
              let unparsedObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
              completion(unparsedObject, nil, "\(response.response!.statusCode)")
            }
            catch let exception as NSError {
              completion(nil, exception, "\(response.response!.statusCode)")
            }
          }

        }
        if let error = response.error {
          completion(nil, error as NSError?, "\(response.response!.statusCode)")
        }
        else {
          guard let data = response.data
          else {
            showAlertMessage(titleStr: "Error!", messageStr: "Something went wrong.. Try again.")
            return
          }
          do {
            let unparsedObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
            completion(unparsedObject, nil, "\(response.response!.statusCode)")
          }
          catch let exception as NSError {
            completion(nil, exception, "\(response.response!.statusCode)")
          }
        }
      }
  }
}
