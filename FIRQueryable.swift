import Foundation
import Firebase

protocol FIRQueryable
{
    static var COLLECTION_NAME: String { get }
}

extension FIRQueryable where Self: FIRModel
{
    func getExternal(completion: @escaping () -> Void)
    {
        let collectionRef = FIRDatabase.database().reference().child(Self.COLLECTION_NAME)
        
        collectionRef.child(self.key).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            self.snapshot = snapshot
            completion()
        }
    }
    
    static func All(completion: @escaping ([Self]) -> Void)
    {
        self.GetCollectionRef().child(COLLECTION_NAME).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            completion(self.GetModels(fromContainerSnapshot: snapshot))
        }
    }
    
    static func From(key: String, completion: @escaping (Self) -> Void)
    {
        self.GetCollectionRef().child(key).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            completion(Self(snapshot: snapshot))
        }
    }
    
    static func Top(completion: @escaping (Self) -> Void)
    {
        self.GetCollectionRef().queryLimited(toFirst: 1).observeSingleEvent(of: .childAdded) { (snapshot: FIRDataSnapshot) in
            
            completion(Self(snapshot: snapshot))
        }
    }
    
    static func TopWhere(child path: String, equals value: Any?, completion: @escaping (Self) -> Void)
    {
        self.GetCollectionRef()
            .queryOrdered(byChild: path)
            .queryEqual(toValue: value)
            .queryLimited(toFirst: 1)
            .observeSingleEvent(of: .childAdded) { (snapshot: FIRDataSnapshot) in
            
                completion(Self(snapshot: snapshot))
        }
    }
    
    private static func GetModels(fromContainerSnapshot snapshot: FIRDataSnapshot) -> [Self]
    {
        var models: [Self] = []
        
        for obj in snapshot.children where obj is FIRDataSnapshot
        {
            models.append(Self.init(snapshot: obj as! FIRDataSnapshot))
        }
        
        return models
    }
    
    private static func GetCollectionRef() -> FIRDatabaseReference
    {
        return FIRDatabase.database().reference().child(COLLECTION_NAME)
    }
}
