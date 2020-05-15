# gRPC Objective-C example

This is an gRPC objective-c example, the java server example can be found in [gRPC-Java-Test-Demo](<https://github.com/yulin-liang/gRPC-Java-Test-Demo>).

### Prerequisites

* xcode
* Cocoapods

### Running the app

* Before running the app, make sure you've already ran an greet server with port 50051.
* Clone this repo and cd into this directory.
* Run `pod install` to add grpc dependencies.
* Open the project by running `open grpc-ios-client.xcworkspace`.
* Build and run the app.

---

#### Notes

- After modifying .proto file, need to rerun `pod install` to regenerate its `.pbobjc` file and `.pbrpc` file. And when rebuild our project in xcode successfully, we can find our newly added apis in `.pbrpc.h` files.