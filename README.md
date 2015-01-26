# DataEntryToolbar

[![CI Status](http://img.shields.io/travis/jeff/DataEntryToolbar.svg?style=flat)](https://travis-ci.org/jeff/DataEntryToolbar)
[![Version](https://img.shields.io/cocoapods/v/DataEntryToolbar.svg?style=flat)](http://cocoadocs.org/docsets/DataEntryToolbar)
[![License](https://img.shields.io/cocoapods/l/DataEntryToolbar.svg?style=flat)](http://cocoadocs.org/docsets/DataEntryToolbar)
[![Platform](https://img.shields.io/cocoapods/p/DataEntryToolbar.svg?style=flat)](http://cocoadocs.org/docsets/DataEntryToolbar)


DataEntryToolbar is a subclass of UIToolbar intended for use as the input accessory view of a keyboard or picker, providing Next, Previous, & Done buttons to navigate up and down a dynamic tableView.

To set up:
- Set a `DataEntryToolbar` instance as the inputAccessoryView of `UITextFields` you want to control
- Add textFields to `tableTextFields` in cellForRowAtIndexPath, using the textField's cell's indexPath as a key
- If you want to be notified when a user taps one of the navigation buttons, implement the necessary `toolbarDelegate` methods
- The look and feel of the toolbar and its buttons can be customized as you would with any toolbar (i.e. barStyle, barTintColor, or button tintColor properties)

Suggestions or improvements always welcome!

![Alt text](dataEntryToolbar.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

DataEntryToolbar is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "DataEntryToolbar"

## Author

jeff, jday@jdayapps.com

## License

DataEntryToolbar is available under the MIT license. See the LICENSE file for more info.