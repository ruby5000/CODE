
import UIKit

struct FakeData : Codable{
    var id : Int
    var title : String
    var price : Double
    var description : String
    var category : String
    var image : String
    var rating : Rating
}
struct Rating : Codable {
    var rate : Float
    var count : Int
}

class ViewController: UIViewController {

    var arrDATAsss = [FakeData]()
    
    @IBOutlet weak var dataTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        CallApiWithURLsession()
        
        dataTableView.register(UINib(nibName: "CeLL", bundle: nil), forCellReuseIdentifier: "CeLL")
    }
    @IBAction func next(_ sender: UIBarButtonItem) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let second = storyBoard.instantiateViewController(withIdentifier: "second") as! second
        navigationController?.pushViewController(second, animated: true)
    }
    
    func CallApiWithURLsession() {
        let url = URL(string: "https://fakestoreapi.com/products")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let json = try JSONDecoder().decode([FakeData].self, from: data!)
                self.arrDATAsss = json
                DispatchQueue.main.async {
                    self.dataTableView.reloadData()
                }
                dump(json)
            }
            catch{
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

extension  ViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDATAsss.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CeLL = tableView.dequeueReusableCell(withIdentifier: "CeLL", for: indexPath) as! CeLL
        let objCell = arrDATAsss[indexPath.row]
        
        cell.title.text = objCell.title
        cell.name.text = objCell.category
        cell.iddd.text = objCell.description
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
