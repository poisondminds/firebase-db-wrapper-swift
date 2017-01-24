//
//  FIRPropertyGettable.swift
//  Mural Test
//
//  Created by Ryan Burns on 1/23/17.
//  Copyright © 2017 Ryan Burns. All rights reserved.
//

import Foundation
import Firebase

protocol FIRPropertyGettable { }

extension FIRPropertyGettable where Self: FIRModel
{
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
