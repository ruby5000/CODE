import UIKit

class cellTableview: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var colllectionVieW: UICollectionView!
    override class func awakeFromNib() {
        
    }
    var tableIndex : Int!
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 125)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollectionView", for: indexPath) as! cellCollectionView
        cell.view_random.backgroundColor = .random()
        cell.lbl_number.text = "\(self.tableIndex!) \(indexPath.item)"
        return cell
    }
}

class cellCollectionView: UICollectionViewCell {
    @IBOutlet weak var view_random: UIView!
    @IBOutlet weak var lbl_number: UILabel!
    var collectionIndex : Int!
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableVieW: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVieW.reloadData()
        self.tableVieW.delegate = self
        self.tableVieW.dataSource = self
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTableview") as! cellTableview
        cell.colllectionVieW.reloadData()
        cell.tableIndex = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
        )
    }
}
