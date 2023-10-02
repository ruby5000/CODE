import UIKit

class gamePlay: UIViewController {
    
    @IBOutlet weak var btnCollection: UICollectionView!
    @IBOutlet weak var scoreLable: UILabel!
    @IBOutlet weak var timerView: UIProgressView!
    
    private var edgeInset : UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    var add : Int  = 0
    var highestScore : Int = Int()
    var colorIndexOne : Int = Int()
    var colorIndexTwo : Int = Int()
    var strLevel : String = ""
    var count : Float = 0
    var timer : Timer = Timer()
    var seconds : Float = 0.0
    let  sectionInsets = UIEdgeInsets(top: 16.0, left:  16.0, bottom: 0.0, right: 16.0)
    let  itemsPerRow : CGFloat = 3
    var numberOfItemsInRow : Int = 3
    var timeIntervals : Double = 0.0
    var meximumColor : Int = Int()
    var minimumColor : Int = Int()
    var arrCurrentColor : NSMutableArray = NSMutableArray()
    var arrCurrentColorUI : NSMutableArray = NSMutableArray()
    var arrDisplayColor : NSMutableArray = NSMutableArray()
    var arrDisplayColorUI : NSMutableArray = NSMutableArray()
    var arrNineColor : NSMutableArray = ["Red","Blue","Green","Yellow","Orange","Black","Brown","Purple","Cyan"]
    var arrNineColorUI : NSMutableArray = [UIColor.red,UIColor.blue,UIColor.green,UIColor.yellow,UIColor.orange,UIColor.black,UIColor.brown,UIColor.purple,UIColor.cyan]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimerforProgressView()
        btnCollection.register(UINib(nibName: "colorIntensityVC", bundle: nil), forCellWithReuseIdentifier: "colorIntensityVC")
        getRandomColor()
    }
    @IBAction func back(_ sender: UIButton) {
        
        let storyBoard  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let  PlayViewController = storyBoard.instantiateViewController(withIdentifier: "PlayViewController" ) as!  PlayViewController
        navigationController?.popToViewController(  PlayViewController, animated: true)
    }
    // MARK: - Timer
    func setupTimerforProgressView() {
        count = 0
        timer.invalidate()
        
        if strLevel == "Easy" {
            seconds = 0.03
        }
        else if strLevel == "Medium" {
            seconds = 0.04
        }
        else {
            seconds = 0.06
        }
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer (){
        if count > 10{
            timer.invalidate()
            showAlert()
        } else {
            count = count + seconds
            timerView.progress = count/10
        }
    }
    // MARK: - Get Random Color
    
    func getRandomColor () {
        
        meximumColor = Int(arc4random_uniform(9))
        
        minimumColor = (meximumColor == 8) ? 2 : ((meximumColor == 9) ? 3 : (meximumColor + 1))
        arrCurrentColor = [arrNineColor[meximumColor] as! String,arrNineColor[minimumColor] as! String]
        
        arrCurrentColorUI = [arrNineColorUI[meximumColor] as! UIColor,arrNineColorUI[minimumColor] as! UIColor]
        
        arrDisplayColor = NSMutableArray()
        arrDisplayColorUI = NSMutableArray()
        
        for _ in 0..<9 {
            let colorIndex : Int = Int(arc4random_uniform(2))
            
            arrDisplayColor.add(arrCurrentColor[colorIndex])
            arrDisplayColorUI.add(arrCurrentColorUI[colorIndex])
        }
        setupTimerforProgressView()
        btnCollection.reloadData()
    }
    // MARK: - GameOver Pop-up Alert
    
    func showAlert() {
        
        let  alrert  : UIAlertController = UIAlertController(title: "Game Over", message: "Score : \(add) \nHigh Score : \(highestScore)", preferredStyle: .alert)
        let  rePlayButton  : UIAlertAction = UIAlertAction(title: "replay", style: .default) {  (_) in
            playSound()
            self.setupTimerforProgressView()
            self.scoreLable.text = "0"
            self.add = 0
            self.getRandomColor()
        }
        let homeButton : UIAlertAction = UIAlertAction(title: "home", style: .default) { (_) in
            playSound()
            self.navigateTOhome()
        }
        alrert.addAction(rePlayButton)
        alrert.addAction(homeButton)
        present(alrert,animated: true,completion: nil)
    }
    
    func navigateTOhome () {
        let storyBoard  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainScreen = storyBoard.instantiateViewController(withIdentifier: "mainScreen" ) as! mainScreen
        navigationController?.pushViewController(mainScreen, animated: true)
    }
}
//MARK: - UICollectionViewDelegate and UICollectionViewDataSource

extension gamePlay : UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDisplayColorUI.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let btnCell : colorIntensityVC = collectionView.dequeueReusableCell(withReuseIdentifier: "colorIntensityVC", for: indexPath) as! colorIntensityVC
        btnCell.lable.backgroundColor = arrDisplayColorUI[indexPath.row] as? UIColor
        buttonSetup(element: btnCell.lable, CornerRadius: 25, ShadowColor: .brown, ShadowRadius: 4, ShadowOpacity: 0.5, ShadowOffset: CGSize(width: 0, height: 0), ShadowOffsetWidth: 0, ShadowOffsetHeight: 0)
        return btnCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectColor : String = arrDisplayColor[indexPath.row] as! String
        
        if (arrDisplayColor.filter {($0 as! String) == selectColor } as NSArray).count > 4 {
            add += 1
            scoreLable.text = String(add)
            getRandomColor()
        }
        else {
            timer.invalidate()
            GameoverSound()
            showAlert()
            if add >= highestScore {
                highestScore = add
            }
        }
    }
}
// MARK: - UICollectionView Delegate and FlowLayout

extension gamePlay : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize{
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = (collectionView.frame.width) - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: Int(widthPerItem), height: Int(widthPerItem-50))
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
