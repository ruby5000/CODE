import UIKit

class StoriesCell: UITableViewCell {

    @IBOutlet weak var collectionview_stories: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionview_stories.reloadData()
        self.collectionview_stories.delegate = self
        self.collectionview_stories.dataSource = self
        self.collectionview_stories.register(UINib(nibName: "StoriesCollectionCell", bundle: .main), forCellWithReuseIdentifier: "StoriesCollectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension StoriesCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionview_stories.dequeueReusableCell(withReuseIdentifier: "StoriesCollectionCell", for: indexPath) as! StoriesCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 110)
    }
    
}
