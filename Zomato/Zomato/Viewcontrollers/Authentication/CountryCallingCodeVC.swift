import UIKit
import SwiftyJSON

class cellCountry: UITableViewCell {
    @IBOutlet weak var img_flag: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
}

class CountryCallingCodeVC: UIViewController {
    
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var tableview_countryCode: UITableView!
    @IBOutlet weak var height_tableview: NSLayoutConstraint!
    
    var arrCountryCode = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url  = "https://cdn.jsdelivr.net/npm/country-flag-emoji-json@2.0.0/dist/index.json"
        self.callCountryCodeApi(url: url)
    }
    
    
    @IBAction func btnTap_back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CountryCallingCodeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCountryCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCountry") as! cellCountry
        let data = self.arrCountryCode[indexPath.row]
        cell.lbl_name.text = data["name"].stringValue
        cell.img_flag.sd_setImage(with: URL(string: data["emoji"].stringValue), placeholderImage: UIImage(named: ""))
        return cell
    }
}

extension CountryCallingCodeVC {
    func callCountryCodeApi(url:String) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters: [:], httpMethod: "GET", progressView: true, uiView: self.view, networkAlert: true) { jsonResponce, statusCode in
            let data = jsonResponce!.arrayValue
            self.tableview_countryCode.reloadData()
            self.tableview_countryCode.delegate = self
            self.tableview_countryCode.dataSource = self
            self.height_tableview.constant = CGFloat(self.arrCountryCode.count*80)
            print(data)
        }
    }
}
