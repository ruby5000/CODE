import UIKit
import SDWebImage

class cellCollectionView: UICollectionViewCell {
    @IBOutlet weak var img_apiData: UIImageView!
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView_image: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var a = "abc"
        var b = "asd"
        print("\(a),\(b)")
        self.collectionView_image.reloadData()
        self.collectionView_image.delegate = self
        self.collectionView_image.dataSource = self
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollectionView", for: indexPath) as! cellCollectionView
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 175, height: 268)
    }
}
