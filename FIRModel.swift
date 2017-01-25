
import Foundation
import Firebase

class FIRModel: CustomStringConvertible
{
    private let _snapshot: FIRDataSnapshot
    var snapshot: FIRDataSnapshot { return self._snapshot }
    
    var key: String { return self._snapshot.key }
    
    var description: String { return self._snapshot.description }
    
    required init(snapshot: FIRDataSnapshot)
    {
        self._snapshot = snapshot
    }
    
    func get<T>(_ path: String) -> T?
    {
        return self.snapshot.childSnapshot(forPath: path).value as? T
    }
    
    func get<T: FIRModel>(_ path: String) -> T
    {
        return T(snapshot: self.snapshot.childSnapshot(forPath: path))
    }
    
    func get<T: FIRModel>(_ path: String) -> [T]
    {
        var items: [T] = []
        
        self.snapshot.childSnapshot(forPath: path).children.forEach { (childSnapshot) in
            
            print(childSnapshot)
            items.append(T(snapshot: childSnapshot as! FIRDataSnapshot))
        }
        
        return items
    }
    
    func getExternal<T: FIRModel>(_ returningClass: T.Type, from collectionName: String, completion: @escaping (T) -> Void)
    {
        let collectionRef = FIRDatabase.database().reference().child(collectionName)
        
        collectionRef.child(self.key).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            completion(T(snapshot: snapshot))
        }
    }
    
    func getLinkKeys(for path: String) -> [String]
    {
        return (self.snapshot.childSnapshot(forPath: path).value as? [String : Bool])?.map { (key, val) -> String in
            return key
            } ?? []
    }
}
