import UIKit
import GoogleMobileAds

class level: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var easy: UIButton!
    @IBOutlet weak var medium : UIButton!
    @IBOutlet weak var hard : UIButton!
    @IBOutlet weak var selectLevel: UILabel!

    //MARK: - Variables
    private var rewardedAd: GADRewardedAd?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        selectLevel.layer.cornerRadius = 10
        selectLevel.layer.masksToBounds = true
        loadRewardedAd()
        show()
    }
    
    //MARK: - ad Create
    func loadRewardedAd() {
      let request = GADRequest()
      GADRewardedAd.load(withAdUnitID:"ca-app-pub-3705116138502345/1731597454",
                         request: request,
                         completionHandler: { [self] ad, error in
        if let error = error {
          print("Failed to load rewarded ad with error: \(error.localizedDescription)")
          return
        }
        rewardedAd = ad
        print("Rewarded ad loaded.")
      })
    }
    
    func show() {
      if let ad = rewardedAd {
        ad.present(fromRootViewController: self) {
          let reward = ad.adReward
          print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
        }
      } else {
        print("Ad wasn't ready")
      }
    }
    
    //MARK: - IBAction
    @IBAction func easy(_ sender: UIButton) {
         nevigationToGame (mode: "Easy")
    }
    @IBAction func medium(_ sender: UIButton) {
      nevigationToGame (mode: "Medium")
    }
    @IBAction func hard(_ sender: UIButton) {
        nevigationToGame (mode: "Hard")
    }
    
// MARK: - Nevigation
    func nevigationToGame (mode: String) {
        let storyBoard  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gamePlays = storyBoard.instantiateViewController(withIdentifier: "gamePlay" ) as! gamePlay
        gamePlays.strLevel = mode
        navigationController?.pushViewController(gamePlays, animated: true)
    }
}
