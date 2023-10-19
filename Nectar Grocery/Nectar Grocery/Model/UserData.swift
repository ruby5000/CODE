import Foundation

class UserDataModel {
    
    var id: String?
    var name: String?
    var email: String?
    var password: String?
    
    init(id: String?, name: String?, email: String?, password: String?){
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
}
