import UIKit
import AMTabView
import GoogleMobileAds
import SDWebImage
import NVActivityIndicatorView


class HomeVC: UIViewController, TabItem {
    
    @IBOutlet weak var view_visualBG: UIVisualEffectView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var tableview_games: UITableView!
    @IBOutlet weak var height_tableview: NSLayoutConstraint!
    @IBOutlet weak var view_loader: NVActivityIndicatorView!
    
    var imageURL = ""
    var tabImage: UIImage? {
        return UIImage(named: "ic_Home")
    }
    var arrGamesData: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addecord()
        self.img_user.sd_setImage(with: URL(string: imageURL))
        if CONSTANT.GUEST_USER == true {
            self.lbl_userName.text! = "Hello, Guest User"
        }
        else {
            self.lbl_userName.text! = "Hello," + UserDefaultManager.getStringFromUserDefaults(key: CONSTANT.UD_UserName)
        }
        
        self.tableview_games.reloadData()
        self.tableview_games.delegate = self
        self.tableview_games.dataSource = self
        self.height_tableview.constant = CGFloat(self.arrGamesData.count*225)
        self.tableview_games.register(UINib(nibName: "cellGames", bundle: .main), forCellReuseIdentifier: "cellGames")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view_visualBG.isHidden = false
        DispatchQueue.main.async {
            self.setLoader()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            //self.InterstitialsADsPresent()
        }
    }
    
    func InterstitialsADsPresent() {
        if ADsManager.shared.interstitial != nil {
            ADsManager.shared.interstitial!.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    func show() {
        if ADsManager.shared.rewardedAd != nil {
            ADsManager.shared.rewardedAd!.present(fromRootViewController: self) {
                let reward = ADsManager.shared.rewardedAd
                print(reward!)
            }
        } else {
            print("Ad wasn't ready")
        }
    }
    
    func setLoader() {
        self.view_loader.type = .ballSpinFadeLoader
        self.view_loader.color = UIColor(named: "Primary_color_2")!
        self.view_loader.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view_visualBG.isHidden = true
            self.view_loader.stopAnimating()
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrGamesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellGames") as! cellGames
        let model = self.arrGamesData[indexPath.row]
        
        cell.img_mainImage.image = model.image
        cell.lbl_name.text = model.name
        cell.lbl_categories.text = model.category
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // Color Intensity
            let vc = storyboard?.instantiateViewController(withIdentifier: "LevelsVC") as! LevelsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1 {
            // Find the diffrent number
            let vc = storyboard?.instantiateViewController(withIdentifier: "DifferentNumberVC") as! DifferentNumberVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2 {
            // Remember the image
            let vc = storyboard?.instantiateViewController(withIdentifier: "ImageRememberVC") as! ImageRememberVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HomeVC {
    func addecord() {
        self.arrGamesData = [Game(name: "Color Intensity", image: UIImage(named: "ic_card"), category: "Colors"),
                             Game(name: "Find the different number", image: UIImage(named: "ic_100"), category: "Maths"),
                             Game(name: "Remember the image", image: UIImage(named: "ic_object"), category: "Mind")]
    }
}
