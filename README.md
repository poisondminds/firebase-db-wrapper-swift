# firebase-db-wrapper-swift
An easy-to-use object wrapper for Firebase's Realtime Database

**Dependencies:** FirebaseDatabase, FirebaseStorage

For demonstration purposes, we'll use the database structure defined below, comprised of murals & artists:

```json
{
  "murals" : 
  {
    "-KaQYfs3kbt4XgDY0ftb" : {
      "artists" : 
      {
        "-KbJbPknFNECn07m1yzy" : true,
        "-KbJXK4aoXc6NZ6VwD7W" : true
      },
      "description" : "A beautiful mural in Orange, CA",
      "images" : 
      {
        "m1" : 
        {
          "location" : "/murals/m1.jpg"
        },
        "m2" : 
        {
          "location" : "/murals/m2.jpg"
        }
      },
      "location" : {
        "city" : "Orange",
        "lat" : 55,
        "long" : 3543.2,
        "name" : "Some building",
        "state" : "CA"
      },
      "name" : "A really great mural"
    }
  },
  "artists" : 
  {
    "-KbJXK4aoXc6NZ6VwD7W" : 
    {
      "country" : "US",
      "firstName" : "Mary",
      "lastName" : "Smith"
    },
    "-KbJbPknFNECn07m1yzy" : 
    {
      "country" : "US",
      "firstName" : "Kerry",
      "lastName" : "Winston"
    }
}
```
## `FIRModel` Usage
Subclass `FIRModel` to make your models serialize & deserialize from objects returned directly from your Firebase Realtime Database. The structure of a simple read-only `FIRModel` representing a mural may look like this:

```swift
class MuralModel: FIRModel
{	
	static var FIELD_NAME = "name"
	static var FIELD_DESCRIPTION = "description"
	static var FIELD_IMAGES = "images"
	static var FIELD_ARTISTS = "artists"
	
	var name: String? { return self.get(MuralModel.FIELD_NAME) }
	var desc: String? { return self.get(MuralModel.FIELD_DESCRIPTION) }
	
	var images: [ImageModel] { return self.get(MuralModel.FIELD_IMAGES) }
	var artists: [ArtistModel] { return self.get(MuralModel.FIELD_ARTISTS) }
}
```
Artist:
```swift
class ArtistModel: FIRModel
{	
	static var FIELD_FIRSTNAME = "firstName"
	static var FIELD_LASTNAME = "lastName"
	static var FIELD_COUNTRY = "country"

	var firstName: String? { return self.get(ArtistModel.FIELD_FIRSTNAME) }
    var lastName: String? { return self.get(ArtistModel.FIELD_LASTNAME) }
    var country: String? { return self.get(ArtistModel.FIELD_COUNTRY) }
}
```
Image:
```swift
class ImageModel: FIRModel
{
	static var FIELD_LOCATION = "location"
	var location: String? { return self.get(ImageModel.FIELD_LOCATION) }
}
```

`FIRModel` mirrors the functionality of Firebase's `FIRDataSnapshot`, and is therefore constructed using one:
```swift
let mural = MuralModel(snapshot: muralSnapshot)
```

Properties can be as nested as necessary. Notice that `images` and `artists` in `MuralModel` are of complex object types. These are too subclasses of `FIRModel`. Look back at the database structure. As recommended in [Firebase's database structure guidelines](https://firebase.google.com/docs/database/web/structure-data]), in our database, the `artists` node consists only of keys. Because of this, the `artists` node, for example, will consist of a number of `ArtistModel`, but only the `key` property will be populated. This is where `FIRQueryable` comes in. 

## `FIRQueryable` Usage
`FIRQueryable` is a protocol that can be adopted by any `FIRModel` that belongs to a top level collection in the Firebase database. By adopting this protocol, you'll simply need to define which collection your model belongs to. See example below of `ArtistModel`.

```swift
class ArtistModel: FIRModel, FIRQueryable
{	
	static var COLLECTION_NAME = "artists"
	
	...
}
```

When `FIRQueryable` is adopted, you may use `getExternal(completion: () -> ())` to retrieve a partially populated model. See example below.

```swift
let firstArtist = self.mural.artists[0]
firstArtist.getExternal {
    self.artistLabel.text = firstArtist.firstName
}
```

`FIRQueryable` additionally contains several static query-convenience functions. `FIRQueryable.Where()` is demonstrated below.

```swift
MuralModel.Where(child: MuralModel.FIELD_NAME, equals: "Some value", limit: 1000) { (murals: [MuralModel]) in
            
    // Do something
}
```

## `FIRPropertyWritable` Usage
By nature, `FIRModel` is a read-only model. `FIRPropertyWritable` can be adopted to allow modifying properties in a `FIRModel`. A more sophisticated `MuralModel` is demonstrated below.

```swift
class MuralModel: FIRModel, FIRPropertyWritable
{	
	static var FIELD_NAME = "name"
	static var FIELD_DESCRIPTION = "description"
    static var FIELD_IMAGES = "images"
    static var FIELD_ARTISTS = "artists"
	
	var name: String? {
		get { return self.get(MuralModel.FIELD_NAME) }
		set { self.set(value: newValue, for: MuralModel.FIELD_NAME) }
	}
	var desc: String? {
		get { return self.get(MuralModel.FIELD_DESCRIPTION) }
		set { self.set(value: newValue, for: MuralModel.FIELD_DESCRIPTION) }
	}
	
	var images: [ImageModel] { return self.get(MuralModel.FIELD_IMAGES) }
	var artists: [ArtistModel] { return self.get(MuralModel.FIELD_ARTISTS) }
}
```

## `FIRInsertable` Usage
`FIRInsertable` can be adopted by a `FIRModel` that belongs to a database collection that can be written to.
```swift
class ArtistModel: FIRModel, FIRInsertable
{
    static var COLLECTION_NAME = "artists"
	
	static var FIELD_FIRSTNAME = "firstName"
	static var FIELD_LASTNAME = "lastName"
	static var FIELD_COUNTRY = "country"

	var firstName: String? { return self.get(ArtistModel.FIELD_FIRSTNAME) }
	var lastName: String? { return self.get(ArtistModel.FIELD_LASTNAME) }
	var country: String? { return self.get(ArtistModel.FIELD_COUNTRY) }

    class func Create(firstName: String, lastName: String, bio: String, country: String, completion: @escaping (ArtistModel) -> Void)
    {
        let data = [
            FIELD_FIRSTNAME: firstName,
            FIELD_LASTNAME: lastName,
            FIELD_COUNTRY: country
        ]
        
        self.Insert(data: data, completion: completion)
    }
}
```
`FIRInsertable.Insert()` can also be used statically outside of a class.
```swift
let data = [
    FIELD_FIRSTNAME: firstName,
    FIELD_LASTNAME: lastName,
    FIELD_COUNTRY: country
]

ArtistModel.Insert(data: data) { (createdArtist: ArtistModel) in
    
    // Handle completion
}
```

## `FIRStorageDownloadable` Usage
Any `FIRModel` that has a `location: String` pointing to a location in Firebase Storage can instead adopt `FIRStorageDownloadable` to provide a seamless integration. In our case:
```swift
class ImageModel: FIRModel, FIRStorageDownloadable { }
```
Then from here,
```swift
let image: ImageModel = mural.images[0]
image.getData(withMaxSize: 1 * 1024 * 1024, completion: { (d: Data?, e: Error?) in
    
    if let error = e
    {
        print("Woops: \(error)")
    }
    else if let data = d
    {
        self.imageView.image = UIImage(data: data)
    }
})
```

Enjoy!
