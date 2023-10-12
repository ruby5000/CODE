import UIKit

class cellGames: UITableViewCell {

    @IBOutlet weak var img_mainImage: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btn_like: UIButton!
    @IBOutlet weak var lbl_categories: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
