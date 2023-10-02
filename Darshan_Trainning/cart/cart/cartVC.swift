import UIKit
class cellCart: UITableViewCell {
    @IBOutlet weak var lbl_itemName: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_qty: UILabel!
    @IBOutlet weak var btn_minus: UIButton!
    @IBOutlet weak var btn_plus: UIButton!
}

class cartVC: UIViewController {
    
    @IBOutlet weak var lbl_totalPrice: UILabel!
    @IBOutlet weak var tableview_cart: UITableView!
    @IBOutlet weak var height_tableview: NSLayoutConstraint!
    
    var arrItemData : [ProductData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview_cart.delegate = self
        self.tableview_cart.dataSource = self
        self.tableview_cart.reloadData()
        self.height_tableview.constant = CGFloat(self.arrItemData.count*110)
    }
    
    func totalValueChanged() {
        var finalTotal = 0
        for i in arrItemData {
            finalTotal += Int(Double(i.itemQty) * i.itemPrice)
        }
        self.lbl_totalPrice.text! = String(finalTotal)
    }
    
    @IBAction func btnTap_back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension cartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrItemData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCart") as! cellCart
        let data = self.arrItemData[indexPath.row]
        cell.lbl_itemName.text! = data.itemName
        
        let total = Double(data.itemQty) * data.itemPrice
        cell.lbl_price.text! = "$"+String(total)
        cell.lbl_qty.text! = String(data.itemQty)
        cell.btn_plus.tag = indexPath.row
        cell.btn_minus.tag = indexPath.row
        if data.itemQty == 1 {
            cell.btn_minus.isHidden = true
        } else {
            cell.btn_minus.isHidden = false
        }
        cell.btn_minus.addTarget(self, action: #selector(btn_minus), for: .touchUpInside)
        cell.btn_plus.addTarget(self, action: #selector(btn_plus), for: .touchUpInside)
        return cell
    }
    
    @objc func btn_minus(_ sender:UIButton) {
        var data = self.arrItemData[sender.tag]
        data.itemQty -= 1
        self.arrItemData.remove(at: sender.tag)
        self.arrItemData.insert(data, at: sender.tag)
        self.totalValueChanged()
        self.tableview_cart.reloadData()
    }
    
    @objc func btn_plus(_ sender:UIButton) {
        let cell = tableview_cart.cellForRow(at: IndexPath(row: sender.tag, section: 0) as IndexPath) as! cellCart
        var data = self.arrItemData[sender.tag]
        data.itemQty += 1
        self.arrItemData.remove(at: sender.tag)
        self.arrItemData.insert(data, at: sender.tag)
        if data.itemQty == 1 {
            cell.btn_minus.isHidden = true
        } else {
            cell.btn_minus.isHidden = false
        }
        self.totalValueChanged()
        self.tableview_cart.reloadData()
    }
}
