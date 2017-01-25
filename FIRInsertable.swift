
import Foundation
import Firebase

protocol FIRInsertable
{
    static var COLLECTION_NAME: String { get }
}

extension FIRInsertable where Self: FIRModel
{
    static func Insert(data: [String: Any], completion: @escaping (Self) -> Void)
    {
        let ref = FIRDatabase.database().reference().child(COLLECTION_NAME).childByAutoId()
        ref.updateChildValues(data)
        
        ref.observe(.value) { (snapshot: FIRDataSnapshot) in completion(Self.init(snapshot: snapshot)) }
    }
}
