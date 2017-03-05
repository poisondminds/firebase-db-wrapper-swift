# firebase-db-wrapper-swift
An easy-to-use object wrapper for Firebase's Realtime Database

## Usage
Subclass `FIRModel` to make your models serialize & deserialize from objects returned directly from your Firebase Realtime Database. For demonstration purposes, we'll use the database structure defined below, comprised of murals & artists:

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
      "name" : "A really great mural",
      "tags" : 
      {
        "contemporary" : true
      }
    }
  },
  "artists" : 
  {
    "-KbJXK4aoXc6NZ6VwD7W" : 
    {
      "bio" : "Test artist bio",
      "country" : "US",
      "firstName" : "Mary",
      "lastName" : "Smith"
    },
    "-KbJbPknFNECn07m1yzy" : 
    {
      "bio" : "Another artist bio",
      "country" : "US",
      "firstName" : "Kerry",
      "lastName" : "Winston"
    }
}
```

The structure of a simple read-only `FIRModel` representing a mural may look like this:
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
	static var FIELD_BIO = "bio"
	static var FIELD_COUNTRY = "country"

	var firstName: String? { return self.get(ArtistModel.FIELD_FIRSTNAME) }
    var lastName: String? { return self.get(ArtistModel.FIELD_LASTNAME) }
	var bio: String? { return self.get(ArtistModel.FIELD_BIO) }
    var country: String? { return self.get(ArtistModel.FIELD_COUNTRY) }
    var murals: [MuralModel] { return self.get(MuralModel.COLLECTION_NAME) }
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

Properties can be as nested as necessary. Notice that `images` and `artists` in `MuralModel` are of complex object types. These are too subclasses of `FIRModel`. Look back at the database structure. As recommended in [Firebase's database structure guidelines](https://firebase.google.com/docs/database/web/structure-data]), in our database, the `images` and `artists` nodes consist only of keys. Because of this, the `images` node, for example, will consist of a number of `ImageModel`s 
