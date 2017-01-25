import Foundation
import Firebase

protocol FIRPropertyWritable { }

extension FIRPropertyWritable where Self: FIRModel
{
    func set(value: Any?, for key: String)
    {
        self.snapshot.ref.child(key).setValue(value, forKey: key)
    }
    
    func add(key: String, forNode nodePath: String, completion: ((Error?) -> Void)? = nil)
    {
        self.snapshot.ref.child(nodePath).updateChildValues([key : true]) { (error: Error?, ref: FIRDatabaseReference) in
            
            completion?(error)
        }
    }
}
