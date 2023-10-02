import UIKit
import SwiftyJSON
import RangeSeekSlider

protocol FilterDelegate {
  func filterData(tag:String,min_price:String,max_price:String,rating:String,isfilter:String)
}

class FilterVC: UIViewController {
  @IBOutlet weak var tagListView: TagListView!
  @IBOutlet weak var rangeSlider: RangeSeekSlider!
  @IBOutlet weak var btn_check1: UIButton!
  @IBOutlet weak var btn_check2: UIButton!
  @IBOutlet weak var btn_check3: UIButton!
  @IBOutlet weak var btn_check4: UIButton!
  @IBOutlet weak var btn_check5: UIButton!
  @IBOutlet weak var lbl_maxPrice: UILabel!
  @IBOutlet weak var lbl_minPrice: UILabel!
  @IBOutlet weak var Height_TagView: NSLayoutConstraint!

  var CategoriesArray = [JSON]()
  var selectedid = [String]()
  var selectedName = [String]()
  var rating = String()
  var Min_price = String()
  var Max_price = String()
  var delegate: FilterDelegate!
  var isfilter = String()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.rangeSlider.delegate = self
    self.btn_check1.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check2.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check3.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check4.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check5.setImage(UIImage.init(named: "ic_square"), for: .normal)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let urlString = API_URL + "category-list"
    let headers:NSDictionary = ["Content-type": "application/json","Authorization":"\(UserDefaultManager.getStringFromUserDefaults(key: UD_TokenType)) \(UserDefaultManager.getStringFromUserDefaults(key: UD_BearerToken))"]
    let params: NSDictionary = ["theme_id":APP_THEME]
    print(headers)
    self.Webservice_category(url: urlString, params: params, header: headers)
  }
}
//MARK: Button Action
extension FilterVC {
  @IBAction func btnTap_back(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }

  @IBAction func btnTap_Filter(_ sender: UIButton) {

    self.dismiss(animated: true) {
      if self.rating == "" {
        self.rating = "0"
      }
      self.isfilter = "1"
      self.delegate.filterData(tag: self.selectedid.joined(separator: ","), min_price: self.Min_price.replacingOccurrences(of: ",", with: ""), max_price: self.Max_price.replacingOccurrences(of: ",", with: ""), rating: self.rating,isfilter: self.isfilter)
    }
  }

  @IBAction func btnTap_Delete(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }

  @IBAction func btn_Tapcheck1(_ sender: UIButton) {
    self.rating = "1"
    self.btn_check1.setImage(UIImage.init(named: "ic_squarefill"), for: .normal)
    self.btn_check2.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check3.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check4.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check5.setImage(UIImage.init(named: "ic_square"), for: .normal)
  }
  @IBAction func btn_Tapcheck2(_ sender: UIButton) {
    self.rating = "2"
    self.btn_check1.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check2.setImage(UIImage.init(named: "ic_squarefill"), for: .normal)
    self.btn_check3.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check4.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check5.setImage(UIImage.init(named: "ic_square"), for: .normal)
  }
  @IBAction func btn_Tapcheck3(_ sender: UIButton) {
    self.rating = "3"
    self.btn_check1.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check2.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check3.setImage(UIImage.init(named: "ic_squarefill"), for: .normal)
    self.btn_check4.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check5.setImage(UIImage.init(named: "ic_square"), for: .normal)
  }
  @IBAction func btn_Tapcheck4(_ sender: UIButton) {
    self.rating = "4"
    self.btn_check1.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check2.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check3.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check4.setImage(UIImage.init(named: "ic_squarefill"), for: .normal)
    self.btn_check5.setImage(UIImage.init(named: "ic_square"), for: .normal)
  }
  @IBAction func btn_Tapcheck5(_ sender: UIButton) {
    self.rating = "5"
    self.btn_check1.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check2.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check3.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check4.setImage(UIImage.init(named: "ic_square"), for: .normal)
    self.btn_check5.setImage(UIImage.init(named: "ic_squarefill"), for: .normal)
  }
}

extension FilterVC : TagListViewDelegate {
  // MARK: TagListViewDelegate
  func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
    if tagView.isSelected == true {
      if selectedName.contains(title) == true {
        let index = selectedName.firstIndex(of: title)
        self.selectedid.remove(at: index!)
        self.selectedName.remove(at: index!)
      }
    }
    else {
      for data in self.CategoriesArray {
        if data["name"].stringValue == title {
          self.selectedid.append(data["id"].stringValue)
          self.selectedName.append(data["name"].stringValue)
        }
      }
    }
    tagView.isSelected = !tagView.isSelected
  }

  func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
    sender.removeTagView(tagView)
  }
}

extension FilterVC {

  // MARK: - category api calling
  func Webservice_category(url:String, params:NSDictionary, header:NSDictionary) -> Void {
    WebServices().CallGlobalAPI(url: url, headers: header, parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ statusCode:String) in
      let status = jsonResponse!["status"].stringValue
      if status == "1" {
        let jsondata = jsonResponse!["data"].arrayValue
        let MaxPrice = formatter.string(for: jsonResponse!["max_price"].stringValue.toDouble)
        self.Max_price = MaxPrice!
        self.lbl_minPrice.text = "Min. Price: 0 \(UserDefaultManager.getStringFromUserDefaults(key: UD_currency_Name))"
        self.lbl_maxPrice.text = "Max. price: \(MaxPrice!) \(UserDefaultManager.getStringFromUserDefaults(key: UD_currency_Name))"
        self.rangeSlider.minValue = 0.0
        self.rangeSlider.maxValue = CGFloat(jsonResponse!["max_price"].floatValue)
        self.rangeSlider.selectedMinValue = 0.0
        self.rangeSlider.selectedMaxValue = CGFloat(jsonResponse!["max_price"].floatValue)

        self.CategoriesArray = jsondata
        var categories = [String]()
        for data in jsondata {
          let tags = data["name"].stringValue
          categories.append(tags)
        }
        self.tagListView.delegate = self
        self.tagListView.addTags(categories)
        self.tagListView.alignment = .left
        self.tagListView.textFont = UIFont(name: "Outfit-Medium", size: 14)!
        self.tagListView.borderWidths = 1
        self.tagListView.layer.borderWidth = 0.0
        self.Height_TagView.constant = CGFloat(categories.count * (55 / 3))
      }
      else if status == "9" {
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_userId)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_BearerToken)
        UserDefaultManager.setStringToUserDefaults(value: "", key: UD_TokenType)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        let nav : UINavigationController = UINavigationController(rootViewController: objVC)
        nav.navigationBar.isHidden = true
        keyWindow?.rootViewController = nav
      }
      else {
        showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["data"]["message"].stringValue.replacingOccurrences(of: "\\n", with: "\n"))
      }
    }
  }
}

extension Sequence where Element: Hashable {
  func uniqued() -> [Element] {
    var set = Set<Element>()
    return filter { set.insert($0).inserted }
  }
}

extension FilterVC: RangeSeekSliderDelegate {

  // MARK: - rangeSeekSilder 
  func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
    if slider === rangeSlider {
      let MinPrice = formatter.string(for: "\(minValue)".toDouble)
      self.Min_price = MinPrice!
      self.lbl_minPrice.text = "Min. Price: \(MinPrice!) \(UserDefaultManager.getStringFromUserDefaults(key: UD_currency_Name))"

      let MaxPrice = formatter.string(for: "\(maxValue)".toDouble)
      self.Max_price = MaxPrice!
      self.lbl_maxPrice.text = "Max. price: \(MaxPrice!) \(UserDefaultManager.getStringFromUserDefaults(key: UD_currency_Name))"

      print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
    }
  }

  func didStartTouches(in slider: RangeSeekSlider) {
    print("did start touches")
  }

  func didEndTouches(in slider: RangeSeekSlider) {
    print("did end touches")
  }
}
