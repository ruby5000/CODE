
import UIKit

class CommonAlertVC: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonOkay: UIButton!
    @IBOutlet weak var imageViewItem: UIImageView!
    
    @IBOutlet weak var heightViewContainer: NSLayoutConstraint!
    
    var message: String = ""
    var imageItem: UIImage?
    var image : UIColor?
    var arrayAction: [[String: () -> Void]]?
    var okButtonAct: (() ->())?

    var isContactNumberHidden: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewContainer.layer.cornerRadius = 20.0
        viewContainer.layer.masksToBounds = true
        // buttonOkay.addCornerRadiusWithShadow(color: .lightGray, borderColor: .clear, cornerRadius: 25)
        //buttonCancel.setCornerRadiusWith(radius: 25, borderWidth: 1.0, borderColor: #colorLiteral(red: 0.03529411765, green: 0.2274509804, blue: 0.9333333333, alpha: 1))
        
        let strokeTextAttributes = [
                 NSAttributedString.Key.strokeColor : UIColor.white,
                 NSAttributedString.Key.foregroundColor : UIColor.white,
                 NSAttributedString.Key.strokeWidth : -5.0,
                 NSAttributedString.Key.font : UIFont(name: "ChalkboardSE-Bold", size: 22)!]
                 as [NSAttributedString.Key : Any]
      
        self.labelMessage.attributedText = NSMutableAttributedString(string: "\(message)", attributes: strokeTextAttributes)
        self.labelMessage.backgroundColor = UIColor.clear
      
        self.labelMessage.layer.shadowColor = UIColor.black.cgColor
        self.labelMessage.layer.shadowRadius = 3.0
        self.labelMessage.layer.shadowOpacity = 1.0
        self.labelMessage.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.labelMessage.layer.masksToBounds = false

//        self.labelMessage.text = message
        
        if imageItem != nil {
            imageViewItem.image = imageItem!
        }
        
        if image != nil {
            imageViewItem.backgroundColor = image
        }
       
        if arrayAction == nil {
            buttonCancel.isHidden = true
        } else {
            var count = 0
            for dic in arrayAction! {
                if count > 1 {
                    return
                }
                let allKeys = Array(dic.keys)
                let buttonTitle: String = allKeys[0].uppercased()
                if count == 0 {
                    buttonOkay.setTitle(buttonTitle, for: .normal)
                } else {
                    buttonCancel.setTitle(buttonTitle, for: .normal)
                }
                count += 1
            }
        }       
    }
  
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if arrayAction != nil {
            let dic = arrayAction![1]
            for (_, value) in dic {
                let action: () -> Void = value
                action()
            }
        } else {
            okButtonAct?()
        }
    }
    
    @IBAction func okayButtonAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if arrayAction != nil {
            let dic = arrayAction![0]
            for (_, value) in dic {
                let action: () -> Void = value
                action()
            }
        } else {
            okButtonAct?()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    static func showAlertWithTitle(_ title: String?, message : String?, actionDic : [String: (UIAlertAction) -> Void]) {
        var alertTitle : String = title!
        if title == nil {
            alertTitle = ""
        }
        let alert : UIAlertController = UIAlertController.init(title: alertTitle, message: message, preferredStyle: .alert)
        
        for (key, value) in actionDic {
            let buttonTitle : String = key
            let action: (UIAlertAction) -> Void = value
            alert.addAction(UIAlertAction.init(title: buttonTitle, style: .default, handler: action))
        }
        UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true, completion: nil)
    }

}
