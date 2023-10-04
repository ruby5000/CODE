
import UIKit

class cellBanner1: UICollectionViewCell {

}

class cellBanner2: UICollectionViewCell {

}

class cellBanner3: UICollectionViewCell {

}

class cellBanner4: UICollectionViewCell {

}

class cellBanner5: UICollectionViewCell {

}

class cellBanner6: UICollectionViewCell {

}

class cellBanner7: UICollectionViewCell {

}

class HomeVC: UIViewController {

  @IBOutlet weak var collectionView_banner1: UICollectionView!
  @IBOutlet weak var collectionView_banner2: UICollectionView!
  @IBOutlet weak var collectionView_banner3: UICollectionView!
  @IBOutlet weak var collectionView_banner4: UICollectionView!
  @IBOutlet weak var collectionView_banner5: UICollectionView!
  @IBOutlet weak var collectionView_banner6: UICollectionView!
  @IBOutlet weak var collectionView_banner7: UICollectionView!

  override func viewDidLoad() {
        super.viewDidLoad()
    self.collectionView_banner1.reloadData()
    self.collectionView_banner1.delegate = self
    self.collectionView_banner1.dataSource = self

    self.collectionView_banner2.reloadData()
    self.collectionView_banner2.delegate = self
    self.collectionView_banner2.dataSource = self

    self.collectionView_banner3.reloadData()
    self.collectionView_banner3.delegate = self
    self.collectionView_banner3.dataSource = self

    self.collectionView_banner4.reloadData()
    self.collectionView_banner4.delegate = self
    self.collectionView_banner4.dataSource = self

    self.collectionView_banner5.reloadData()
    self.collectionView_banner5.delegate = self
    self.collectionView_banner5.dataSource = self

    self.collectionView_banner6.reloadData()
    self.collectionView_banner6.delegate = self
    self.collectionView_banner6.dataSource = self

    self.collectionView_banner7.reloadData()
    self.collectionView_banner7.delegate = self
    self.collectionView_banner7.dataSource = self
    }
}

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.collectionView_banner1 {
      return 8
    } else if collectionView == self.collectionView_banner2 {
      return 8
    } else if collectionView == self.collectionView_banner3 {
      return 8
    } else if collectionView == self.collectionView_banner4 {
      return 8
    } else if collectionView == self.collectionView_banner5 {
      return 8
    } else if collectionView == self.collectionView_banner6 {
      return 8
    } else if collectionView == self.collectionView_banner7 {
      return 8
    }
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == self.collectionView_banner1 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellBanner1", for: indexPath) as! cellBanner1
      return cell
    }
    else if collectionView == self.collectionView_banner2 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellBanner2", for: indexPath) as! cellBanner2
      return cell
    }
    else if collectionView == self.collectionView_banner3 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellBanner3", for: indexPath) as! cellBanner3
      return cell
    }
    else if collectionView == self.collectionView_banner4 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellBanner4", for: indexPath) as! cellBanner4
      return cell
    }
    else if collectionView == self.collectionView_banner5 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellBanner5", for: indexPath) as! cellBanner5
      return cell
    }
    else if collectionView == self.collectionView_banner6 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellBanner6", for: indexPath) as! cellBanner6
      return cell
    }
    else if collectionView == self.collectionView_banner7 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellBanner7", for: indexPath) as! cellBanner7
      return cell
    }
    return UICollectionViewCell()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == self.collectionView_banner2 {
      return CGSize(width: 350, height: 154)
    }
    else if collectionView == self.collectionView_banner2 {
      return CGSize(width: 195, height: 300)
    }
    else if collectionView == self.collectionView_banner6 {
      return CGSize(width: 350, height: 154)
    }
    else if collectionView == self.collectionView_banner7 {
      return CGSize(width: 195, height: 230)
    }
    return CGSize()
  }
}
