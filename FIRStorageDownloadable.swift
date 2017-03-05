import Foundation
import Firebase

protocol FIRStorageDownloadable
{
    var location: String? { get }
}

extension FIRStorageDownloadable
{
    func getDownloadURL(completion: @escaping (URL?, Error?) -> Void)
    {
        guard let ref = self.getStorageRef() else
        {
            completion(nil, NSError(domain: "No storage reference found", code: 0, userInfo: nil))
            return
        }
        
        ref.downloadURL(completion: completion)
    }
    
    func getData(withMaxSize maxSize: Int64, completion: @escaping (Data?, Error?) -> Void)
    {
        guard let ref = self.getStorageRef() else
        {
            completion(nil, NSError(domain: "No storage reference found", code: 0, userInfo: nil))
            return
        }
        
        ref.data(withMaxSize: maxSize, completion: completion)
    }
    
    fileprivate func getStorageRef() -> FIRStorageReference?
    {
        guard let loc = location else
        {
            return nil
        }
        
        return FIRStorage.storage().reference(withPath: loc)
    }
}
