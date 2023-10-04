import WebKit
import UIKit

class AboutVC: UIViewController {

  @IBOutlet weak var webview_AboutUsData: WKWebView!

  override func viewDidLoad() {
    super.viewDidLoad()
    let url = "http://192.168.1.28/bookingdo/api/cmspages"
    self.Webservice_AboutUs(url: url)

  }

  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }
}


extension AboutVC {
  // MARK: - AboutUs
  func Webservice_AboutUs(url:String) -> Void {
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
          self.webview_AboutUsData.loadHTMLString(header+jsonResponce!["aboutus"].stringValue, baseURL: nil)
        }
      }
    }
  }
}
