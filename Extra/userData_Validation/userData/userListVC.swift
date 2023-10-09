import UIKit

class cellUserData: UITableViewCell {
    @IBOutlet weak var lbl_firstName: UILabel!
    @IBOutlet weak var lbl_lastName: UILabel!
    @IBOutlet weak var lbl_dob: UILabel!
    @IBOutlet weak var btn_delete: UIButton!
}

class userListVC: UIViewController {
    
    @IBOutlet weak var tableview_userdata: UITableView!
    
    var arrUserData = UserDefaults.standard.object(forKey: "USER_ARRAY")! as! [[String:Any]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview_userdata.reloadData()
        self.tableview_userdata.dataSource = self
        self.tableview_userdata.delegate = self
        print(UserDefaults.standard.object(forKey: "USER_ARRAY")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview_userdata.reloadData()
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
        cell.lbl_firstName.text! = arrUserData[indexPath.row]["fName"]!as! String
        cell.lbl_lastName.text! = arrUserData[indexPath.row]["lName"]! as! String
        cell.lbl_dob.text! = arrUserData[indexPath.row]["dob"]! as! String
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(btnDelete), for: .touchUpInside)
        return cell
    }
    
    @objc func btnDelete(_ sender:UIButton) {
        self.arrUserData.remove(at: sender.tag)
        self.tableview_userdata.reloadData()
        UserDefaults.standard.set(self.arrUserData, forKey: "USER_ARRAY")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "profileVC") as! profileVC
        vc.firstName = self.arrUserData[indexPath.row]["fName"]! as! String
        vc.lastName = self.arrUserData[indexPath.row]["lName"]! as! String
        vc.email = self.arrUserData[indexPath.row]["email"]! as! String
        vc.dob = self.arrUserData[indexPath.row]["dob"]! as! String
        vc.password = self.arrUserData[indexPath.row]["password"]! as! String
        UserDefaults.standard.set(self.arrUserData[indexPath.row]["img"], forKey: "IMG")
        print(self.arrUserData[indexPath.row]["img"]!)
        
        vc.index = indexPath.row
        vc.arrUserData = arrUserData
        navigationController?.pushViewController(vc, animated: true)
    }
}
