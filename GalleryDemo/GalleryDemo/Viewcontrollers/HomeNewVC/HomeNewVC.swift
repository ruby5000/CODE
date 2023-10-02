import UIKit
import Photos
import MapKit

class HomeNewVC: UIViewController {
    
    @IBOutlet weak var tableview_home: UITableView!
    
    var height = CGFloat()
    var allAssets: [AssetsData] = []
    var arrData1: [StoriesData] = []
    var arrData2: [AlbumData] = []
    var arrData3: [AlbumData] = []
    var arrData4: [AlbumData] = []
    var arrData5: [MediaData] = []
    let documentsURL = URL(string: "\(CommonFunction.shared.getPath())")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeRequest()
        self.RecordData()
        self.tableview_home.delegate = self
        self.tableview_home.dataSource = self
        self.tableview_home.register(UINib(nibName: "StoriesCell", bundle: .main), forCellReuseIdentifier: "StoriesCell")
        self.tableview_home.register(UINib(nibName: "AlbumCell", bundle: .main), forCellReuseIdentifier: "AlbumCell")
        self.tableview_home.register(UINib(nibName: "MediaCell", bundle: .main), forCellReuseIdentifier: "MediaCell")
        self.assetData()
        self.otherAlbums()
        self.placesLocation()
        self.tableview_home.reloadData()
    }
    
    func RecordData() {
        let story1 = StoriesData(image: UIImage(named: "ic_placeholder"), title: "test1")
        let story2 = StoriesData(image: UIImage(named: "ic_placeholder"), title: "test2")
        let story3 = StoriesData(image: UIImage(named: "ic_placeholder"), title: "test3")
        let story4 = StoriesData(image: UIImage(named: "ic_placeholder"), title: "test4")
        arrData1 = [story1, story2, story3, story4]
        
        let albumData1 = AlbumData(image: UIImage(named: "ic_placeholder"), title: "Recent Photos", count: 0)
        let albumData2 = AlbumData(image: UIImage(named: "ic_placeholder"), title: "All Photos", count: 0)
        let albumData3 = AlbumData(image: UIImage(named: "ic_placeholder"), title: "All Videos", count: 0)
        let albumData4 = AlbumData(image: UIImage(named: "ic_placeholder"), title: "Favorites", count: 0)
        let albumData5 = AlbumData(image: UIImage(named: "ic_placeholder"), title: "Screen shots", count: 0)
        arrData2 = [albumData1, albumData2, albumData3, albumData4, albumData5]
        
        let placeData = AlbumData(image: UIImage(named: "ic_placeholder"), title: "Place", count: 0)
        arrData4 = [placeData]
        
        let mediaData1 = MediaData(icon: UIImage(named: "cube"), title: "Portrait")
        let mediaData2 = MediaData(icon: UIImage(named: "hd"), title: "High Defination")
        let mediaData3 = MediaData(icon: UIImage(named: "image"), title: "Burst")
        let mediaData4 = MediaData(icon: UIImage(named: "icons8-animated-24"), title: "Animated")
        arrData5 = [mediaData1, mediaData2, mediaData3, mediaData4]
    }
    
}

extension HomeNewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1//(self.arrData[section] as? [StoriesData])?.count ?? 0
        }
        else if section == 1 {
            return 1//(self.arrData[section] as? [AlbumData])?.count ?? 0
        }
        else if section == 2 {
            return 1//(self.arrData[section] as? [AlbumData])?.count ?? 0
        }
        else if section == 3 {
            return 1//(self.arrData[section] as? [AlbumData])?.count ?? 0
        }
        else  {
            return self.arrData5.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        }
        else if indexPath.section == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.tableview_home.beginUpdates()
                self.tableview_home.layoutIfNeeded()
                self.tableview_home.endUpdates()
            })
        }
        else if indexPath.section == 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                UIView.performWithoutAnimation {
                    self.tableview_home.beginUpdates()
                    self.tableview_home.layoutIfNeeded()
                    self.tableview_home.endUpdates()
                }
            })
        }
        else if indexPath.section == 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                UIView.performWithoutAnimation {
                    self.tableview_home.beginUpdates()
                    self.tableview_home.layoutIfNeeded()
                    self.tableview_home.endUpdates()
                }
            })
        }
        else if indexPath.section == 4 {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let StoriesCell = self.tableview_home.dequeueReusableCell(withIdentifier: "StoriesCell") as! StoriesCell
            
            return StoriesCell
        }
        
        else if indexPath.section == 1 {
            let AlbumCell = self.tableview_home.dequeueReusableCell(withIdentifier: "AlbumCell") as! AlbumCell
            let model = self.arrData2
            AlbumCell.allAssets = model
            AlbumCell.setupCollectionView()
            AlbumCell.didTapCollectionCell = { index in
                DispatchQueue.main.async {
                    
                    let obj = self.storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
                    if index == 0 {
                        obj.selectedAlbum = .recent
                    }
                    else if index == 1 {
                        obj.selectedAlbum = .allPhotos
                    }
                    else if index == 2 {
                        obj.selectedAlbum = .videos
                    }
                    else if index == 3 {
                        obj.selectedAlbum = .favourite
                    }
                    else if index == 4 {
                        obj.selectedAlbum = .screenshots
                    }
                    self.navigationController?.pushViewController(obj, animated: true)
                }
            }
            return AlbumCell
        }
        
        else if indexPath.section == 2 {
            let AlbumCell = self.tableview_home.dequeueReusableCell(withIdentifier: "AlbumCell") as! AlbumCell
            let model = self.arrData3
            AlbumCell.allAssets = model
            AlbumCell.setupCollectionView()
            AlbumCell.didTapCollectionCell = { index in
                let obj = self.storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
                obj.albumName = model[index].title ?? ""
                obj.selectedAlbum = .other
                self.navigationController?.pushViewController(obj, animated: true)
            }
            return AlbumCell
        }
        
        else if indexPath.section == 3 {
            let AlbumCell = self.tableview_home.dequeueReusableCell(withIdentifier: "AlbumCell") as! AlbumCell
            let model = self.arrData4
            AlbumCell.allAssets = model
            AlbumCell.setupCollectionView()
            AlbumCell.didTapCollectionCell = { index in
                DispatchQueue.main.async {
                    self.placesLocation()
                }
            }
            return AlbumCell
        }
        
        else if indexPath.section == 4 {
            let mediaCell = self.tableview_home.dequeueReusableCell(withIdentifier: "MediaCell") as! MediaCell
            let model = self.arrData5[indexPath.row]
            mediaCell.img_icon.image = model.icon
            mediaCell.lblTitle.text = model.title ?? ""
            
            return mediaCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        }
        else if indexPath.section == 1 {
            return UITableView.automaticDimension
        }
        else if indexPath.section == 2 {
            return UITableView.automaticDimension
        }
        else if indexPath.section == 3 {
            return UITableView.automaticDimension
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        view.backgroundColor = .clear
        let lblTitle = UILabel(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 20, height: 40))
        view.addSubview(lblTitle)
        if section == 0 {
            lblTitle.text = ""
        }
        else if section == 1 {
            lblTitle.text = ""
        }
        else if section == 2 {
            lblTitle.text = "My Albums"
        }
        else if section == 3 {
            //lblTitle.text = "Media Type"
        }
        else if section == 4 {
            lblTitle.text = "Media Type"
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 3 {
            let v = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 1.0))
            v.backgroundColor = .darkGray
            let label = UILabel(frame: CGRect(x: 8.0, y: 4.0, width: v.bounds.size.width - 16.0, height: 1))
            label.text = ""
            v.addSubview(label)
            return v
        } else if section == 1 {
            let v = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 1.0))
            v.backgroundColor = .darkGray
            let label = UILabel(frame: CGRect(x: 8.0, y: 4.0, width: v.bounds.size.width - 16.0, height: 1))
            label.text = ""
            v.addSubview(label)
            return v
        } else if section == 0 {
            let v = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 1.0))
            v.backgroundColor = .darkGray
            let label = UILabel(frame: CGRect(x: 8.0, y: 4.0, width: v.bounds.size.width - 16.0, height: 1))
            label.text = ""
            v.addSubview(label)
            return v
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 40.0
        }
        if section == 3 {
            return 0
        }
        if section == 4 {
            return 40.0
        }
        return CGFloat()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 1.0
        } else if section == 1 {
            return 1.0
        } else if section == 0 {
            return 1.0
        }
        return CGFloat()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 4 {
            let obj = self.storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
            obj.selectedAlbum = .portrait
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 1 && indexPath.section == 4 {
            let obj = self.storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
            obj.selectedAlbum = .highDefination
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 2 && indexPath.section == 4 {
            let obj = self.storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
            obj.selectedAlbum = .burst
            self.navigationController?.pushViewController(obj, animated: true)
        }
        else if indexPath.row == 3 && indexPath.section == 4 {
            let obj = self.storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
            obj.selectedAlbum = .animated
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
}


extension HomeNewVC {
    func makeRequest() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Authorized")
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
}

extension HomeNewVC {
    
    func assetData() {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        let allPhoto = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        let names = allPhoto.firstObject?.localIdentifier.components(separatedBy: "/").first ?? ""
        let photosPath = URL(string: "\(names).JPG")!
        
        if let pathComponent = documentsURL?.appendingPathComponent("\(photosPath)") {
            if pathComponent.isURLAvailable() {
                
            }
            else {
                allPhotos.firstObject?.getURL(completionHandler: { responseURL in
                    let data = try? Data(contentsOf: responseURL!)
                    let img = UIImage(data: data!)
                    self.arrData2[1].image = img
                    self.reloadSection(sections: [1])
                })
            }
        }
        
        
        
        let allVideos = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        let name = allVideos.firstObject?.localIdentifier.components(separatedBy: "/").first ?? ""
        let videoPath = URL(string: "\(name).png")!
        if let pathComponent = documentsURL?.appendingPathComponent("\(videoPath)") {
            if pathComponent.isURLAvailable() {
                
            }
            else {
                allVideos.firstObject?.getURL(completionHandler: { responseURL in
                    if let thumbnailImage = self.getThumbnailImage(forUrl: responseURL ?? URL(fileURLWithPath: "")) {
                        DispatchQueue.main.async {
                            let resizeImage = thumbnailImage.resizeWithWidth(width: 500)
                            self.arrData2[2].image = resizeImage
                            self.reloadSection(sections: [1])
                        }
                    }
                })
            }
        }
        
        let albumsRecentPhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: nil)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        albumsRecentPhoto.enumerateObjects({(collection, index, object) in
            let RecentPhoto = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            let names = RecentPhoto.firstObject?.localIdentifier.components(separatedBy: "/").first ?? ""
            let photosPath = URL(string: "\(names).JPG")!
            self.arrData2[0].count = RecentPhoto.count
            
            
            if let pathComponent = URL(string: "\(CommonFunction.shared.getPath())")?.appendingPathComponent("\(photosPath)") {
                if pathComponent.isURLAvailable() {
                    
                }
                else {
                    RecentPhoto.firstObject?.getURL(completionHandler: { responseURL in
                        DispatchQueue.main.async {
                            let data = try? Data(contentsOf: responseURL!)
                            let img = UIImage(data: data!)
                            let resizeImg = img?.resizeWithWidth(width: 200)
                            self.arrData2[0].image = resizeImg
                            self.reloadSection(sections: [1])
                        }
                    })
                }
            }
            self.reloadSection(sections: [1])
        })
        
        
        let albumsFavouritePhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        
        albumsFavouritePhoto.enumerateObjects({(collection, index, object) in
            let favouritePhotos = PHAsset.fetchAssets(in: collection, options: nil)
            let names = favouritePhotos.firstObject?.localIdentifier.components(separatedBy: "/").first ?? ""
            let photosPath = URL(string: "\(names).JPG")!
            if let pathComponent = URL(string: "\(CommonFunction.shared.getPath())")?.appendingPathComponent("\(photosPath)") {
                if pathComponent.isURLAvailable() {
                    
                }
                else {
                    favouritePhotos.firstObject?.getURL(completionHandler: { responseURL in
                        DispatchQueue.main.async {
                            let data = try? Data(contentsOf: responseURL!)
                            let img = UIImage(data: data!)
                            let resizeImg = img?.resizeWithWidth(width: 200)
                            self.arrData2[3].image = resizeImg
                            self.reloadSection(sections: [3])
                        }
                    })
                }
            }
            self.arrData2[3].count = favouritePhotos.count
        })
        
        
        let screenShotPhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil)
        
        screenShotPhoto.enumerateObjects({(collection, index, object) in
            let screenShot = PHAsset.fetchAssets(in: collection, options: nil)
            let names = screenShot.firstObject?.localIdentifier.components(separatedBy: "/").first ?? ""
            let photosPath = URL(string: "\(names).JPG")!
            
            if let pathComponent = URL(string: "\(CommonFunction.shared.getPath())")?.appendingPathComponent("\(photosPath)") {
                if pathComponent.isURLAvailable() {
                    
                }
                else {
                    screenShot.firstObject?.getURL(completionHandler: { responseURL in
                        DispatchQueue.main.async {
                            let data = try? Data(contentsOf: responseURL!)
                            let img = UIImage(data: data!)
                            let resizeImg = img?.resizeWithWidth(width: 200)
                            self.arrData2[4].image = resizeImg
                            self.reloadSection(sections: [1])
                        }
                    })
                }
            }
        })
        
        self.arrData2[1].count = allPhotos.count
        self.arrData2[2].count = allVideos.count
        self.reloadSection(sections: [1])
    }
    
    func reloadSection(sections: IndexSet) {
        DispatchQueue.main.async {
            self.tableview_home.reloadSections(sections, with: .none)
        }
    }
    
}

extension HomeNewVC {
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

extension HomeNewVC {
    func otherAlbums() {
        let albumsPhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumUserLibrary, options: nil)
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        albumsPhoto.enumerateObjects({(collection, index, object) in
            let photoInAlbum = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            
            
            let names = photoInAlbum.firstObject?.localIdentifier.components(separatedBy: "/").first ?? ""
            let photosPath = URL(string: "\(names).JPG")!
            
            if let pathComponent = URL(string: "\(CommonFunction.shared.getPath())")?.appendingPathComponent("\(photosPath)") {
                if pathComponent.isURLAvailable() {
                    
                }
                else {
                    photoInAlbum.firstObject?.getURL(completionHandler: { responseURL in
                        DispatchQueue.main.async {
                            let imgData = try? Data(contentsOf: responseURL!)
                            let img = UIImage(data: imgData!)
                            let resizeImg = img?.resizeWithWidth(width: 200)
                            let data = AlbumData(image: resizeImg, title: collection.localizedTitle, count: collection.estimatedAssetCount)
                            self.arrData3.append(data)
                            self.tableview_home.reloadData()
                        }
                    })
                }
            }
        })
    }
}

extension HomeNewVC {
    func placesLocation() {
        var count = 0
        let locatedPhotos = PHAsset.fetchAssets(with: .image, options: nil)
        for i in 0..<locatedPhotos.count {
            let asset = locatedPhotos[i]
            if let location = asset.location?.coordinate.latitude {
                let lat = asset.location?.coordinate.latitude
                let long = asset.location?.coordinate.longitude
                let location = CLLocation(latitude: lat!, longitude: long!)
                count = count + 1
                location.fetchCityAndCountry { city, country, error in
                    guard let city = city, error == nil else { return }
                    print(city)
                }
            }
        }
        let placeData = AlbumData(image: UIImage(named: "ic_placeholder"), title: "Place", count: count)
        self.arrData4 = [placeData]
    }
}
