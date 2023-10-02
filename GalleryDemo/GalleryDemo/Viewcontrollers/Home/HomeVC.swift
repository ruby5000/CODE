import UIKit
import Photos
import AVFoundation
import AVKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionview_photos: UICollectionView!
    
    var allAssets: [AssetsData] = []
    var noOfCell = 13
    var index: Int = 0
    var AlbumsIndex: Int = 0
    let documentsURL = URL(string: "\(CommonFunction.shared.getPath())")
    var albumName = ""
    var selectedAlbum: Albums? = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeRequest()
        self.collectionview_photos.reloadData()
        collectionview_photos.register(UINib(nibName: "PhotosCell", bundle: .main), forCellWithReuseIdentifier: "PhotosCell")
        
    }
    
    @IBAction func zoomOUT(_ sender: UIButton) {
        if noOfCell == 13 {
            noOfCell = noOfCell + 0
        } else {
            noOfCell = noOfCell + 3
        }
        self.collectionview_photos.reloadData()
    }
    
    @IBAction func zoomIN(_ sender: UIButton) {
        if noOfCell == 1 {
            noOfCell = noOfCell - 0
        } else {
            noOfCell = noOfCell - 3
        }
        self.collectionview_photos.reloadData()
    }
}

extension HomeVC {
    
    // check photos permission
    func makeRequest() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                if self.selectedAlbum == .other {
                    self.OtherAlbums(albumName: self.albumName)
                }
                else if self.selectedAlbum == .recent {
                    self.AllRecent()
                }
                else if self.selectedAlbum == .allPhotos {
                    self.AllPhotos()
                }
                else if self.selectedAlbum == .videos {
                    self.AllVideos()
                }
                else if self.selectedAlbum == .favourite {
                    self.Favourite()
                }
                else if self.selectedAlbum == .portrait {
                    self.Portraits()
                }
                else if self.selectedAlbum == .burst {
                    self.Burst()
                }
                else if self.selectedAlbum == .animated {
                    self.Animated()
                }
                else if self.selectedAlbum == .highDefination {
                    self.HighDefination()
                }
                else if self.selectedAlbum == .screenshots {
                    self.ScreenShot()
                }
                
            case .denied, .restricted:
                print("Not Allowed")
            case .notDetermined:
                print("Not Determined yet")
            case .limited:
                break
            @unknown default:
                break
            }
        }
    }
    
    // Fetch all photos
    func AllPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        for i in 0..<allPhotos.count {
            let asset = allPhotos[i]
            let data = AssetsData(asset: asset)
            self.allAssets.append(data)
        }
        DispatchQueue.main.async {
            self.collectionview_photos.reloadData()
        }
    }
    
    // Fetch all Videos
    func AllVideos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allVideos = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        for i in 0..<allVideos.count {
            let asset = allVideos[i]
            let data = AssetsData(asset: asset)
            self.allAssets.append(data)
        }
        DispatchQueue.main.async {
            self.collectionview_photos.reloadData()
        }
    }
    
    // AllRecent
    func AllRecent() {
        let albumsPhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: nil)
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        albumsPhoto.enumerateObjects({(collection, index, object) in
            let photoInAlbum = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            for i in 0..<photoInAlbum.count {
                let asset = photoInAlbum[i]
                let data = AssetsData(asset: asset)
                self.allAssets.append(data)
            }
            DispatchQueue.main.async {
                self.collectionview_photos.reloadData()
            }
        })
    }
    
    // Favourite
    func Favourite() {
        let favouritePhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        favouritePhoto.enumerateObjects({(collection, index, object) in
            let favPhotos = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            for i in 0..<favPhotos.count {
                let asset = favPhotos[i]
                let data = AssetsData(asset: asset)
                self.allAssets.append(data)
            }
            DispatchQueue.main.async {
                self.collectionview_photos.reloadData()
            }
        })
    }
    
    // ScreenShot
    func ScreenShot() {
        let favouritePhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil)
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        favouritePhoto.enumerateObjects({(collection, index, object) in
            let screenShots = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            print("Found \(screenShots.count) \(collection.localizedTitle!)")
            
            for i in 0..<screenShots.count {
                let asset = screenShots[i]
                let data = AssetsData(asset: asset)
                self.allAssets.append(data)
            }
            DispatchQueue.main.async {
                self.collectionview_photos.reloadData()
            }
        })
    }
    
    // OtherAlbums
    func OtherAlbums(albumName:String) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let otherPhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
        otherPhoto.enumerateObjects({(collection, index, object) in
            let albumPhotos = PHAsset.fetchAssets(in: collection, options: nil)
            
            for i in 0..<albumPhotos.count {
                let asset = albumPhotos[i]
                let data = AssetsData(asset: asset)
                self.allAssets.append(data)
            }
            DispatchQueue.main.async {
                self.collectionview_photos.reloadData()
            }
        })
    }
    
    // Portraits
    func Portraits() {
        let fetchOptions = PHFetchOptions()
        let albumsPhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: nil)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        albumsPhoto.enumerateObjects({(collection, index, object) in
            let PortraitsAlbum = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            print("Found \(PortraitsAlbum.count) \(collection.localizedTitle!)")
            for i in 0..<PortraitsAlbum.count {
                let asset = PortraitsAlbum[i]
                let data = AssetsData(asset: asset)
                self.allAssets.append(data)
            }
            DispatchQueue.main.async {
                self.collectionview_photos.reloadData()
            }
        })
    }
    
    // Burst
    func Burst() {
        let fetchOptions = PHFetchOptions()
        let albumsPhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumBursts, options: nil)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        albumsPhoto.enumerateObjects({(collection, index, object) in
            let BurstAlbum = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            print("Found \(BurstAlbum.count) \(collection.localizedTitle!)")
            for i in 0..<BurstAlbum.count {
                let asset = BurstAlbum[i]
                let data = AssetsData(asset: asset)
                self.allAssets.append(data)
            }
            DispatchQueue.main.async {
                self.collectionview_photos.reloadData()
            }
        })
    }
    
    // Animated
    func Animated() {
        let fetchOptions = PHFetchOptions()
        let albumsPhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumAnimated, options: nil)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        albumsPhoto.enumerateObjects({(collection, index, object) in
            let AnimatedAlbum = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            print("Found \(AnimatedAlbum.count) \(collection.localizedTitle!)")
            for i in 0..<AnimatedAlbum.count {
                let asset = AnimatedAlbum[i]
                let data = AssetsData(asset: asset)
                self.allAssets.append(data)
            }
            DispatchQueue.main.async {
                self.collectionview_photos.reloadData()
            }
        })
    }
    
    // High Defination
    func HighDefination() {
        let fetchOptions = PHFetchOptions()
        let hdPhoto = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        for i in 0..<hdPhoto.count {
            let asset = hdPhoto[i]
            if asset.pixelWidth >= 720 {
                let data = AssetsData(asset: asset)
                self.allAssets.append(data)
            }
        }
        DispatchQueue.main.async {
            self.collectionview_photos.reloadData()
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionview_photos.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
        let asset = self.allAssets[indexPath.item]
        
        if asset.localImage != nil {
            cell.img_photos.image = asset.localImage
        }
        else if asset.localURL != nil {
            let image = UIImage(contentsOfFile: asset.localURL?.path ?? "")
            cell.img_photos.image = image
            self.allAssets[indexPath.item].localImage = image
        }
        else {
            let imageName = asset.asset?.localIdentifier.components(separatedBy: "/").first ?? ""
            let imagePath = URL(string: "\(imageName).png")!
            
            if let pathComponent = documentsURL?.appendingPathComponent("\(imagePath)") {
                if pathComponent.isURLAvailable() {
                    self.collectionview_photos.reloadData()
                    self.allAssets[indexPath.item].localURL = pathComponent
                    let image = UIImage(contentsOfFile: pathComponent.path)
                    cell.img_photos.image = image
                    
                    asset.asset?.getURL { responseURL in
                        self.allAssets[indexPath.item].url = responseURL
                    }
                } else {
                    asset.asset?.getURL { responseURL in
                        self.allAssets[indexPath.item].url = responseURL
                        let image = UIImage(contentsOfFile: responseURL?.path ?? "")
                        self.allAssets[indexPath.item].image = image
                        
                        let newImage = image?.resizeWithWidth(width: 200)
                        self.allAssets[indexPath.item].localImage = newImage
                        DispatchQueue.main.async {
                            cell.img_photos.image = newImage
                        }
                        
                        if let thumbnailImage = self.getThumbnailImage(forUrl: responseURL ?? URL(fileURLWithPath: "")) {
                            DispatchQueue.main.async {
                                let resizeImage = thumbnailImage.resizeWithWidth(width: 500)
                                cell.img_photos.image = resizeImage
                                self.allAssets[indexPath.item].localImage = resizeImage
                            }
                        }
                        
                        if let jpegData = newImage?.jpegData(compressionQuality: 1) {
                            try? jpegData.write(to: pathComponent)
                        }
                    }
                }
            }
            if selectedAlbum == .videos {
                if asset.localImage != nil {
                    cell.img_photos.image = asset.localImage
                }
                else if asset.localURL != nil {
                    let image = UIImage(contentsOfFile: asset.localURL?.path ?? "")
                    cell.img_photos.image = image
                    self.allAssets[indexPath.item].localImage = image
                }
                else {
                    let videoName = asset.asset?.localIdentifier.components(separatedBy: "/").first ?? ""
                    let videoPath = URL(string: "\(videoName).png")!
                    
                    if let pathComponent = documentsURL?.appendingPathComponent("\(videoPath)") {
                        if pathComponent.isURLAvailable() {
                            self.collectionview_photos.reloadData()
                            self.allAssets[indexPath.item].localURL = pathComponent
                            let video = UIImage(contentsOfFile: pathComponent.path)
                            cell.img_photos.image = video
                            asset.asset?.getURL { responseURL in
                                self.allAssets[indexPath.item].url = responseURL
                            }
                        } else {
                            asset.asset?.getURL { responseURL in
                                self.allAssets[indexPath.item].url = responseURL
                                let video = UIImage(contentsOfFile: responseURL?.path ?? "")
                                self.allAssets[indexPath.item].image = video
                                
                                if let thumbnailImage = self.getThumbnailImage(forUrl: responseURL ?? URL(fileURLWithPath: "")) {
                                    DispatchQueue.main.async {
                                        let resizeImage = thumbnailImage.resizeWithWidth(width: 500)
                                        cell.img_photos.image = resizeImage
                                        self.allAssets[indexPath.item].localImage = resizeImage
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCell - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCell))
        
        if noOfCell == 1 {
            if index == 0 {
                guard let imageDATA = self.allAssets[indexPath.item].localImage else {
                    return .zero
                }
                let width = collectionView.bounds.width
                let heightOnWidthRatio = imageDATA.size.height / imageDATA.size.width
                let height = width * heightOnWidthRatio
                return CGSize(width: width, height: height)
            }
            else if index == 1 {
                guard let imageDATA = self.allAssets[indexPath.item].localImage else {
                    return .zero
                }
                let width = collectionView.bounds.width
                let heightOnWidthRatio = imageDATA.size.height / imageDATA.size.width
                let height = width * heightOnWidthRatio
                return CGSize(width: width, height: height)
            }
            else if index == 2 {
                return CGSize(width: size, height: size)
            }
            else if index == 3 {
                guard let imageDATA = self.allAssets[indexPath.item].localImage else {
                    return .zero
                }
                let width = collectionView.bounds.width
                let heightOnWidthRatio = imageDATA.size.height / imageDATA.size.width
                let height = width * heightOnWidthRatio
                return CGSize(width: width, height: height)
            }
        }
        else {
            return CGSize(width: size, height: size)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? PhotosCell
        let asset = self.allAssets[indexPath.item]
        if self.noOfCell == 1 {
            if asset.image != nil {
                cell?.img_photos.image = asset.image
            }
            else {
                asset.asset?.getURL { responseURL in
                    let image = asset.asset?.getAssetThumbnail()
                    DispatchQueue.main.async {
                        cell?.img_photos.image = image
                    }
                    self.allAssets[indexPath.item].image = image
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? PhotosCell
        let asset = self.allAssets[indexPath.item]
        if self.noOfCell == 1 {
            cell?.img_photos.image = asset.localImage
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.allAssets[indexPath.item]
        if asset.localImage != nil {
            let image = UIImage(contentsOfFile: asset.url?.path ?? "")
            self.imageTapped(image: image ?? UIImage())
        }
        else {
            let image = UIImage(contentsOfFile: asset.url?.path ?? "")
            self.imageTapped(image: image ?? UIImage())
            
        }
        if selectedAlbum == .videos {
            let url = asset.url
            self.playVideo(url: url!)
        }
        if selectedAlbum == .animated {
            let url = asset.url
            let imageURL = UIImage.gifImageWithURL("\(url!)")
            let imageView3 = UIImageView(image: imageURL)
            imageView3.frame = CGRect(x:0,y:0,width:200,height:300)
            imageView3.contentMode = .scaleAspectFill
            //            view.addSubview(imageView3)
        }
    }
    
    func imageTapped(image:UIImage){
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
}



extension HomeVC {
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
}

extension HomeVC {
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
    }
}
