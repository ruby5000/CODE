//
//  second.swift
//  urlSEssion
//
//  Created by DARSHAN on 26/04/22.
//

import UIKit
import Alamofire

struct FekingData : Codable{
    var id : Int
    var title : String
    var price : Double
    var description : String
    var category : String
    var image : String
    var rating : RatingDAta
}
struct RatingDAta : Codable {
    var rate : Float
    var count : Int
}

class second: UIViewController {

    var arrrDATa : [FekingData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAPIWithAlamofire()
    }
    func callAPIWithAlamofire() {
        Alamofire.request(URL(string: "https://fakestoreapi.com/products")!).responseJSON {(response) in
            if response.result.isSuccess {
                do {
                    let json = try JSONDecoder().decode([FekingData].self, from: response.data!)
                    self.arrrDATa = json
                    dump(json)
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

