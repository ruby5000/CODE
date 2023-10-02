import UIKit
import Photos

class AlbumCell: UITableViewCell  {
    
    @IBOutlet weak var height_collectionview_album: NSLayoutConstraint!
    @IBOutlet weak var collectionview_albums: UICollectionView!

    var allAssets: [AlbumData] = []
    var didTapCollectionCell: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCollectionView() {
        self.collectionview_albums.delegate = self
        self.collectionview_albums.dataSource = self
        self.collectionview_albums.register(UINib(nibName: "AlbumCollectionCell", bundle: .main), forCellWithReuseIdentifier: "AlbumCollectionCell")
        self.collectionview_albums.reloadData {
            UIView.performWithoutAnimation {
                self.height_collectionview_album.constant = self.collectionview_albums.contentSize.height
            }
        }
    }
    
}

extension AlbumCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionview_albums.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionCell", for: indexPath) as! AlbumCollectionCell
        let model = self.allAssets[indexPath.item]
        cell.lbl_title.text = model.title ?? ""
        cell.img_albums.image = model.image
        cell.lbl_count.text = "\(model.count ?? 0)"
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 5) / 3, height: 165)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapCollectionCell?(indexPath.item)
        
    }
    
}
