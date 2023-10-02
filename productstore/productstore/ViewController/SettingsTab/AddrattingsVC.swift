
import UIKit
import Cosmos

protocol FeedbackDelegate {
    func refreshData(id:String,rating_no:String,title:String,description:String)
}

class AddrattingsVC: UIViewController,UITextViewDelegate {
    @IBOutlet weak var textview_message: UITextView!
    @IBOutlet weak var CosmosViews: CosmosView!
    @IBOutlet weak var txt_title: UITextField!
    var delegate: FeedbackDelegate!
    var product_id = String()
    var rattingscount = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textview_message.text = "Leave a message, if you want"
        self.textview_message.textColor = UIColor.lightGray
        self.textview_message.delegate = self
        CosmosViews.didFinishTouchingCosmos = { rating in
            print(rating)
            self.rattingscount = "\(rating)"
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Leave a message, if you want"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
//MARK: Button Action
extension AddrattingsVC
{
    @IBAction func btnTap_cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnTap_RateNow(_ sender: UIButton) {
        
        if self.textview_message.text == "Leave a message, if you want" || self.txt_title.text == "" || self.rattingscount == ""
        {
            let alertVC = UIAlertController(title: Bundle.main.displayName!, message: "Please enter message", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "okay", style: .default)
            alertVC.addAction(yesAction)
            self.present(alertVC,animated: true,completion: nil)
        }
        else
        {
            if self.textview_message.text == "Leave a message, if you want"
            {
                self.textview_message.text = ""
            }
            self.dismiss(animated: true)
            {
                self.delegate.refreshData(id: self.product_id, rating_no: self.rattingscount, title: self.txt_title.text!, description: self.textview_message.text!)
            }
        }
        
    }
}
