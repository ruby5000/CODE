
import UIKit

class languageCell : UITableViewCell{
    @IBOutlet weak var btn_select: UIButton!
    @IBOutlet weak var lbl_name: UILabel!
}

class LanguageMenuVC: UIViewController {

    @IBOutlet weak var tableview_lannguage: UITableView!
    //@IBOutlet weak var height_tableview: NSLayoutConstraint!
    
    var arrLaungage = ["English","Hindi","Gujrati"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview_lannguage.reloadData()
        self.tableview_lannguage.delegate = self
        self.tableview_lannguage.dataSource = self
        //self.height_tableview.constant = CGFloat(self.arrLaungage.count*113)
    }
    @IBAction func btnTap_close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LanguageMenuVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrLaungage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell") as! languageCell
        cell.lbl_name.text = self.arrLaungage[indexPath.row]
        return cell
    }
}
