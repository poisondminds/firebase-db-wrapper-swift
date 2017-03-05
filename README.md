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

The structure of a `FIRModel` representing a mural may look like this:
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
