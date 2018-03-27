# ReactiveNetwork

[![CI Status](http://img.shields.io/travis/fa35de542d80347b4a3940d4945d1685503dec3d/ReactiveNetwork.svg?style=flat)](https://travis-ci.org/jaumard/ReactiveNetwork.svg?branch=master)
[![Version](https://img.shields.io/cocoapods/v/ReactiveNetwork.svg?style=flat)](http://cocoapods.org/pods/ReactiveNetwork)
[![License](https://img.shields.io/cocoapods/l/ReactiveNetwork.svg?style=flat)](http://cocoapods.org/pods/ReactiveNetwork)
[![Platform](https://img.shields.io/cocoapods/p/ReactiveNetwork.svg?style=flat)](http://cocoapods.org/pods/ReactiveNetwork)

ReactiveNetwork is a small library to make REST JSON API request and parse the result into a Swift object.
Swift 4 is mandatory as it use the native capability of Swift 4 to parse JSON payload with `Codable`.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
You can check the example app, here is a quick example on how using the library to consume a REST JSON API:

Create the `ReactiveNetwork` instance: 
```swift
let reactiveNetwork = ReactiveNetwork.Builder("https://mywebservicebaseurl/").build()
```

This object have the following available method that you can use to make HTTP requests:

Request with body:
```swift
doRequest<T: Codable, R: Codable>(method: String = "POST", 
                                  path: String,
                                  body: T,
                                  queryParams: Dictionary<String, String> = [:],
                                  pathParams: Dictionary<String, String> = [:],
                                  headers: Dictionary<String, String> = [:]) -> Single<R>
                                  
doRequest<T: Codable>(method: String = "POST", 
                      path: String,
                      body: T,
                      queryParams: Dictionary<String, String> = [:],
                      pathParams: Dictionary<String, String> = [:],
                      headers: Dictionary<String, String> = [:]) -> Completable                                   
```

Request without body:
```swift
doRequest<T: Codable>(method: String = "GET", 
                      path: String, 
                      queryParams: Dictionary<String, String> = [:],
                      pathParams: Dictionary<String, String> = [:],
                      headers: Dictionary<String, String> = [:]) -> Single<T>
                      
doRequest(method: String = "DELETE", 
          path: String, 
          queryParams: Dictionary<String, String> = [:],
          pathParams: Dictionary<String, String> = [:],
          headers: Dictionary<String, String> = [:]) -> Completable                       
```

Where:
 - `method` is the http method to use (like GET, POST, PUT, DELETE...)
 - `path` is the sub path to the resource to fetch (list users, users/post...)
 - `body` is the swift object that extend `Codable` to send to the server
 - `queryParams` is a dictionary of key/value to send as query parameters (like ?sort=desc&filter=test)
 - `pathParams` is the url part to replace in case of dynamic `path` (like `path="/users/{subcat}"` then `subcat:mycatvalue` should be pass)
 - `headers` http header to pass to the request as key/value (like `Content-Type:application/json`)

Consider the following payload: 
```json
{
  "id": 1,
  "name": "John",
  "firstName": "Paul",
  "email": "John.Paul@test.com"
}
```

First create your model, it must extend `Codable`
```swift
class User: Codable {
    let id: Int?
    let name: String
    let firstName: String
    let phone: String?
    let email: String
    
    init(id: Int?, name: String, firstName: String, phone: String?, email: String) {
        self.id = id
        self.name = name
        self.firstName = firstName
        self.phone = phone
        self.email = email
    }
}
```

Then create your network data source that will call web services:
```swift
class UserNetworkDataSource {
    private let reactiveNetwork: ReactiveNetwork
    private let basePath: String

    init(_ reactiveNetwork: ReactiveNetwork) {
        self.reactiveNetwork = reactiveNetwork
        self.basePath = "users"
    }

    func get() -> Single<[T]> {
        return reactiveNetwork.doRequest(method: "GET", path: self.basePath)
    }

    func get(_ id: Int) -> Single<T> {
        return reactiveNetwork.doRequest(method: "GET", path: "\(self.basePath)/\(id)")
    }

    func create(_ item: T) -> Single<T> {
        return reactiveNetwork.doRequest(method: "POST", path: self.basePath, body: item)
    }

    func update(_ id: Int, item: T) -> Single<T> {
        return reactiveNetwork.doRequest(method: "PUT", path: "\(self.basePath)/\(id)", body: item)
    }

    func delete(_ id: Int) -> Completable {
        return reactiveNetwork.doRequest(method: "DELETE", path: "\(self.basePath)/\(id)").asCompletable()
    }
}
```

Or you can use the build in one like this: 

```swift
class UserNetworkDataSource: NetworkDataSource<User> {

    init(_ reactiveNetwork: ReactiveNetwork) {
        super.init("users", reactiveNetwork: ReactiveNetwork)
    }
}
```

## Interceptors
Now is you need to modify the request or the response globally here is where the interceptors are useful.
There two build in interceptors, LogInterceptor and HeaderInterceptor. They can be added with the method `addInterceptor` of ReactiveNetwork.Builder.
You can add multiple interceptors, they will be executed in order.

### LogInterceptor
It will log all request and response on the console for you, should be useful to debug your calls.
```swift
LogInterceptor(level: .debug)
```
You have three level: 
- none, will not log information
- info, will log basic information, url, status code...
- debug, will log all information, url, headers, body, status code...

### HeaderInterceptor
It will globally add headers on all your request for you. Just pass them during initialisation.
```swift
HeaderInterceptor(["Content-Type": "application/json", "Accept": "application/json"])
```

### Custom Interceptor
You can create your own interceptors by implementing two protocols, `RequestInterceptor` if your interceptor need to intercept the request and `ResponseInterceptor` to intercept the response.
You can check the code of the built it interceptors as example. 

## Requirements

## Installation

ReactiveNetwork is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ReactiveNetwork'
```

## Release
To deploy this pod:
```ruby
pod lib lint
git tag 'x.x.x'
git push --tags
pod trunk push ReactiveNetwork.podspec
```


## Author

jaumard, jimmy.aumard@gmail.com

## License

ReactiveNetwork is available under the MIT license. See the LICENSE file for more info.
