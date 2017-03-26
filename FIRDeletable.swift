import Foundation
import Firebase

protocol FIRDeletable
{
	static var COLLECTION_NAME: String { get }
}

extension FIRDeletable where Self: FIRModel
{
	func delete(completion: ((Error?) -> Void)? = nil)
	{
		FIRDatabase.database()
			.reference(withPath: Self.COLLECTION_NAME)
			.child(self.key)
			.removeValue { (e: Error?, ref: FIRDatabaseReference) in
				
				completion?(e)
		}
	}
}
