import UIKit

class cellUserData: UITableViewCell {
    @IBOutlet weak var lbl_firstName: UILabel!
    @IBOutlet weak var lbl_dob: UILabel!
}

class userListVC: UIViewController {

    @IBOutlet weak var tableview_userdata: UITableView!
    
    var arrUserData = UserDefaults.standard.object(forKey: "USER_ARRAY")! as! [[String:String]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview_userdata.reloadData()
        self.tableview_userdata.dataSource = self
        self.tableview_userdata.delegate = self
        print(UserDefaults.standard.object(forKey: "USER_ARRAY")!)
    }
    
    @IBAction func btnTap_back(_ sender: UIButton) {
        let welcomeVC = self.storyboard!.instantiateViewController(withIdentifier: "welcomeVC") as! welcomeVC
        navigationController?.pushViewController(welcomeVC, animated: true)
    }
}

extension userListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 95
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUserData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUserData") as! cellUserData
        cell.lbl_firstName.text! = arrUserData[indexPath.row]["fName"]!
        cell.lbl_dob.text! = arrUserData[indexPath.row]["dob"]!
        return cell
    }
}
