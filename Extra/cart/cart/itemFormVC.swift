import UIKit
struct ProductData {
    var itemName: String
    var itemPrice: Double
    var itemQty: Int
}

class itemFormVC: UIViewController {
    
    @IBOutlet weak var txt_itemName: UITextField!
    @IBOutlet weak var txt_itemPrice: UITextField!
    @IBOutlet weak var txt_itemQty: UITextField!
    
    var arrProductsData = [ProductData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.txt_itemName.text! = ""
        self.txt_itemPrice.text! = ""
        self.txt_itemQty.text! = ""
    }
    
    @IBAction func btnTap_Submit(_ sender: UIButton) {
        self.arrProductsData.append(ProductData(itemName: self.txt_itemName.text!,
                                                itemPrice: Double(self.txt_itemPrice.text!)!,
                                                itemQty: Int(self.txt_itemQty.text!)!))
        self.txt_itemName.text! = ""
        self.txt_itemPrice.text! = ""
        self.txt_itemQty.text! = ""
    }
    
    @IBAction func btnTap_cart(_ sender: UIButton) {
        let objVC = self.storyboard!.instantiateViewController(withIdentifier: "cartVC") as! cartVC
        objVC.arrItemData = self.arrProductsData
        navigationController?.pushViewController(objVC, animated: true)
    }
}
