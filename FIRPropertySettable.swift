import Foundation
import Firebase

protocol FIRPropertySettable { }

extension FIRPropertySettable where Self: FIRModel
{
	func set(value: Any?, for key: String)
	{
		self.snapshot.ref.child(key).setValue(value, forKey: key)
	}
}
