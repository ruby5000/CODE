import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class cellProduct:UITableViewCell {
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var img_product: UIImageView!
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableview_product: UITableView!
    
    var arrProductData = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = API_URL + categorys_product_guest
        let params = ["theme_id":THEME_ID] as NSDictionary
        self.callProductAPI(url: url, parameter: params)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrProductData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview_product.dequeueReusableCell(withIdentifier: "cellProduct") as! cellProduct
        let data = self.arrProductData[indexPath.row]
        cell.lbl_name.text! = data["name"].stringValue
        cell.img_product.sd_setImage(with: URL(string: IMG_URL + data["cover_image_path"].stringValue), placeholderImage: UIImage(named: ""))
        return cell
    }
}

extension ViewController {
    func callProductAPI(url:String, parameter:NSDictionary) {
        APIService().CallGlobalAPI(url: url, httpMethod: "POST", headers: [:], parameters: parameter) {(_ jsonResponse:JSON? , _ statusCode:String) in
            let status = jsonResponse!["status"].stringValue
            if status == "1" {
                let json = jsonResponse!["data"].dictionaryValue
                let productData = json["data"]?.arrayValue
                self.arrProductData = productData!
                self.insertDATA()
                self.tableview_product.delegate = self
                self.tableview_product.dataSource = self
                self.tableview_product.reloadData()
            }
        }
    }
}

extension ViewController {
    func insertDATA(){
        for i in self.arrProductData {
            let result : Bool = performOpration(query: "insert into ProductDB('name') values ('\(i["name"].stringValue)');")
            print(result)
        }
    }
}
