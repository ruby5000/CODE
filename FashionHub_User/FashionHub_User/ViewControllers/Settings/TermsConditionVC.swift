import WebKit
import UIKit

class TermsConditionVC: UIViewController {

  @IBOutlet weak var webview_TermsAndCondition: WKWebView!

  override func viewDidLoad() {
    super.viewDidLoad()
    let url = "http://192.168.1.28/bookingdo/api/cmspages"
    self.Webservice_TermsCondition(url: url)

  }
  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }
}


extension TermsConditionVC {
  // MARK: - TermsCondition api
  func Webservice_TermsCondition(url:String) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: [:], parameters: [:], httpMethod: "GET", progressView: true, uiView: self.view, networkAlert: true) { jsonResponce, strErrorMessage in
      if strErrorMessage.count != 0 {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
      }
      else {
        let responseCode = jsonResponce!["status"].stringValue
        if responseCode == "1" {
          let header = """
                  <head>
                      <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
                      <style>
                          body {
                              font-size: 14;
                          }
                      </style>
                  </head>
                  <body>
                  """
          self.webview_TermsAndCondition.loadHTMLString(header+jsonResponce!["termscondition"].stringValue, baseURL: nil)
        }
      }
    }
  }
}
