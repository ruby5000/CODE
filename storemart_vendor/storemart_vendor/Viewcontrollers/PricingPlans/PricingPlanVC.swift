
import UIKit

class pricingPlans : UITableViewCell {

}

class PricingPlanVC: UIViewController {

  @IBOutlet weak var tableview_pricingPlans: UITableView!
  @IBOutlet weak var height_tableview_pricingPlans: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableview_pricingPlans.reloadData()
    self.tableview_pricingPlans.delegate = self
    self.tableview_pricingPlans.dataSource = self
    self.height_tableview_pricingPlans.constant = CGFloat(230*4)
  }
}

extension PricingPlanVC : UITableViewDelegate, UITableViewDataSource{

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 230
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "pricingPlans") as! pricingPlans
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "PlansVC") as! PlansVC
    self.navigationController?.pushViewController(objVC, animated: true)
  }
}
