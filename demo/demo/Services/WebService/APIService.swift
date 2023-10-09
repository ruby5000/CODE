import Alamofire
import Foundation
import SwiftyJSON

class APIService: NSObject {
    
    func CallGlobalAPI(url:String, httpMethod:String, headers:HTTPHeaders, parameters:NSDictionary, responseDict:@escaping (_ jsonResponce:JSON?, _ statusCode:String) -> Void) {
        AF.request(url,method: .post, parameters: parameters as? Parameters, headers: headers) .responseData { response in
            switch (response.result) {
            case .success:
                if((response.value) != nil) {
                    let jsonResponce = JSON(response.value!)
                    print("Responce: \n\(jsonResponce)")
                    DispatchQueue.main.async {
                        let httpStatusCode = response.response?.statusCode
                        responseDict(jsonResponce,"\(httpStatusCode!)")
                    }
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
