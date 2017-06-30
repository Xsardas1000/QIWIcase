# Sinch Verification iOS SDK

Welcome to Sinch Verification iOS SDK,
[https://www.sinch.com/products/verification/]
(https://www.sinch.com/products/verification/)

## Features

* Verification of phone numbers via SMS and callout
* Simple authentication scheme to get started quickly
* Server integration via REST-API callbacks for advanced setups

Should you encounter any bugs, glitches, lack of functionality or
other problems using our SDK, please send us an email to
dev@sinch.com. Your help in this regard is greatly appreciated.

## Quick start

- Install Sinch via CocoaPod (pod 'SinchVerification' or pod 'SinchVerification-Swift')
  or download it on [https://www.sinch.com/downloads/](https://www.sinch.com/downloads/)

- Read the User Guide for an introduction and the Reference docs for details

- Look at the sample apps for inspiration

## Documentation

The User Guide is available in `docs/` (or
[https://www.sinch.com/docs/verification/ios/](https://www.sinch.com/docs/verification/ios/))

Reference docs for the Objective-C APIs: `objc/docs/reference/html/index.html`

Reference docs for the Swift APIs: `swift/docs/reference/html/index.html`

## Objective-C and Swift

The SDK package contains two different `SinchVerification.framework`
bundles, one in the directory `objc/`, and one in `swift/`.

The framework bundle in `objc/` contains a _static library framework_
(only Objective-C, no Swift modules), and the framework bundle in `swift/` is a
_dynamic framework_ for use with Swift applications and iOS deployment
target >= iOS 8.0. See the User Guide for more details on how to use
the different flavors of the Sinch Verification SDK.

There are also Swift bindings available as source, with support for
both Swift language level 2 and 3, please see `swift2/` and
`swift3/`. (Xcode 7 defaults to using Swift 2.x, and Xcode 8 defaults
to using Swift 3.x)

## Copyright

Copyright 2014-2016, Sinch AB (reg. no 556969-5397)
