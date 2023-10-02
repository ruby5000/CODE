import UIKit

class spalshScreen: UIViewController {
    
    @IBOutlet weak var timerView: UIProgressView!
    
    var count : Float = 1
    var timer : Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimerforProgressView()
        navigationController?.navigationBar.isHidden = true
    }
// MARK: - Timer
    func setupTimerforProgressView() {
        count = 1
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer () {
        if count > 8{
            timer.invalidate()
            navigation()
        } else {
            count = count + 0.03
            timerView.progress = count/8
        }
    }
// MARK: - Nevigation
    private func navigation() {
        let storyBoard  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let MainScreen = storyBoard.instantiateViewController(withIdentifier: "mainScreen" ) as! mainScreen
        navigationController?.pushViewController(MainScreen, animated: true)
    }
}

