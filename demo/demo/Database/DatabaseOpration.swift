import Foundation

func performOpration(query : String) -> Bool{
    print(query)
    let dbObject: FMDatabase = FMDatabase(path: AppDelegate.getDataBase)
    if dbObject.open() {
        let result: Bool = dbObject.executeUpdate(query, withArgumentsIn: [])
        dbObject.close()
        return result
    }
    return false
}
