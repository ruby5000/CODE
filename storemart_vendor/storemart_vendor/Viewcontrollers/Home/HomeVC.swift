import Charts
import UIKit


class HomeVC: UIViewController{

  @IBOutlet weak var btn_SelecYear: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setPopUpButton()
  }

  func setPopUpButton() {
    let optionClouser = {(action :UIAction) in }
    btn_SelecYear.menu = UIMenu(children : [
      UIAction(title: "2022",state: .on, handler: optionClouser),
      UIAction(title: "2023",state: .on, handler: optionClouser)])

    btn_SelecYear.showsMenuAsPrimaryAction = true
    btn_SelecYear.changesSelectionAsPrimaryAction = true
  }
}
