
import Foundation
import Firebase

class FIRModel: CustomStringConvertible
{
    private var _snapshot: FIRDataSnapshot
    var snapshot: FIRDataSnapshot { get { return self._snapshot } set { self._snapshot = newValue } }
    
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
            
            items.append(T(snapshot: childSnapshot as! FIRDataSnapshot))
        }
        
        return items
    }
    
    func getLinkKeys(for path: String) -> [String]
    {
        return (self.snapshot.childSnapshot(forPath: path).value as? [String : Bool])?.map { (key, val) -> String in
            return key
            } ?? []
    }
}
