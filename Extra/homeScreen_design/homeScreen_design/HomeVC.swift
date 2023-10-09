import UIKit

class cell_product: UICollectionViewCell {
    
    @IBOutlet weak var view_btn: UIView!
    @IBOutlet weak var view_background: UIView!
}

class HomeVC: UIViewController {

    @IBOutlet weak var collectionView_product: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView_product.reloadData()
        self.collectionView_product.delegate = self
        self.collectionView_product.dataSource = self
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_product", for: indexPath) as! cell_product
        cell.view_background.layer.cornerRadius = 12
        cell.view_btn.layer.cornerRadius = 10
        cell.view_background.layer.borderWidth = 1
        cell.view_background.layer.borderColor = (UIColor.init(named: "app_color") as! CGColor)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 361, height: 587)
    }
}
