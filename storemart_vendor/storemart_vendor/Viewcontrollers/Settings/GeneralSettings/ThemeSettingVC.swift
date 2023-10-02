import UIKit

class ThemeSettingVC: UIViewController, UIColorPickerViewControllerDelegate {

  var firstColor = true

  @IBOutlet weak var btn_Primarycolor: UIButton!
  @IBOutlet weak var btn_Secondarycolor: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func backBtn(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }

  @IBAction func btnAction_colorPicker(_ sender: UIButton) {
    let colorPicker = UIColorPickerViewController()
    colorPicker.delegate = self
    present(colorPicker, animated: true)
  }

  @IBAction func btnAction_SecondarycolorPicker(_ sender: UIButton) {
    let colorPicker2 = UIColorPickerViewController()
    colorPicker2.delegate = self
    present(colorPicker2, animated: true)
  }

  func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {

    let Primarycolor = viewController.selectedColor
    self.btn_Primarycolor.backgroundColor = Primarycolor

    let secondaryColor = viewController.selectedColor
    self.btn_Secondarycolor.backgroundColor = secondaryColor
  }
}
