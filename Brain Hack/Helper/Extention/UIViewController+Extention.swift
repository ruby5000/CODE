import UIKit
import Foundation

extension UIViewController {
    func showToast(backgroundColor:UIColor, textColor:UIColor, message:String){

        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.text = message
        label.font = UIFont(name: "", size: 15)
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor =  backgroundColor //UIColor.whiteColor()
        label.textColor = textColor //TEXT COLOR
        label.sizeToFit()
        label.numberOfLines = 4
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOffset = CGSize(width: 4, height: 3)
        label.layer.shadowOpacity = 0.3
        label.frame = CGRect(x: self.view.frame.size.width, y: 64, width: self.view.frame.size.width, height: 44)

        label.alpha = 1

        self.view.addSubview(label)

        var basketTopFrame: CGRect = label.frame;
        basketTopFrame.origin.x = 0;

        UIView.animate(withDuration :1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                label.frame = basketTopFrame
            },  completion: {
                (value: Bool) in
                UIView.animate(withDuration:0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                        label.alpha = 0
                    },  completion: {
                        (value: Bool) in
                            label.removeFromSuperview()
                    })
            })
        }
    
        func showCustomAlertWith(okButtonAction: (() ->())? = {}, message: String,itemimage: UIImage?, actions: [[String: () -> Void]]?) {
               let alertVC = CommonAlertVC.init(nibName: "CommonAlertVC", bundle: nil)
               alertVC.message = message
               alertVC.arrayAction = actions
               alertVC.imageItem = itemimage
               alertVC.okButtonAct = okButtonAction
            
               //Present
               alertVC.modalTransitionStyle = .crossDissolve
               alertVC.modalPresentationStyle = .overCurrentContext
               self.present(alertVC, animated: true, completion: nil)
           }
        func showCustomAlertWith(okButtonAction: (() ->())? = {}, message: String,itemimage: UIColor?, actions: [[String: () -> Void]]?) {
            let alertVC = CommonAlertVC.init(nibName: "CommonAlertVC", bundle: nil)
            alertVC.message = message
            alertVC.arrayAction = actions
            alertVC.okButtonAct = okButtonAction
            alertVC.image = itemimage
            //Present
            alertVC.modalTransitionStyle = .crossDissolve
            alertVC.modalPresentationStyle = .overCurrentContext
            self.present(alertVC, animated: true, completion: nil)
        }
}
