import UIKit

class cellCarDetails: UITableViewCell {
    @IBOutlet weak var lbl_mfgYear: UILabel!
    @IBOutlet weak var lbl_carPrice: UILabel!
    @IBOutlet weak var lbl_carName: UILabel!
    @IBOutlet weak var img_car: UIImageView!
    @IBOutlet weak var btn_detail: UIButton!
    @IBOutlet weak var view_background: UIView!
}

class carListVC: UIViewController {

    @IBOutlet weak var tableview_carListing: UITableView!
    @IBOutlet weak var height_tableview: NSLayoutConstraint!
    
    var arrCarDetails = [CarData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview_carListing.delegate = self
        self.tableview_carListing.dataSource = self
        self.tableview_carListing.reloadData()
    }
    
    @IBAction func btnTap_back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension carListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCarDetails.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCarDetails") as! cellCarDetails
        let data = self.arrCarDetails[indexPath.row]
        cell.lbl_carName.text! = data.name
        cell.lbl_mfgYear.text! = data.mfgYear
        cell.lbl_carPrice.text! = data.price
        cell.img_car.image! = data.img!
        cell.btn_detail.tag = indexPath.row
        cell.btn_detail.addTarget(self, action: #selector(btn_details), for: .touchUpInside)
        cell.btn_detail.layer.cornerRadius = 6
        cell.view_background.layer.cornerRadius = 8
        return cell
    }
    
    @objc func btn_details(_ sender:UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "carDetailsVC") as! carDetailsVC
        let data = self.arrCarDetails[sender.tag]
        vc.indexValue = sender.tag
        vc.company = data.company
        vc.name = data.name
        vc.price = data.price
        vc.color = data.color
        vc.mfgYear = data.mfgYear
        vc.img = data.img!
        navigationController?.pushViewController(vc, animated: true)
    }
}
