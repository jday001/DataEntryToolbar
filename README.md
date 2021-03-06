# DataEntryToolbar

[![CI Status](https://travis-ci.org/jday001/DataEntryToolbar.svg?branch=master)](https://travis-ci.org/jday001/DataEntryToolbar)
[![Version](https://img.shields.io/cocoapods/v/DataEntryToolbar.svg?style=flat)](http://cocoadocs.org/docsets/DataEntryToolbar)
[![License](https://img.shields.io/cocoapods/l/DataEntryToolbar.svg?style=flat)](http://cocoadocs.org/docsets/DataEntryToolbar)
[![Platform](https://img.shields.io/cocoapods/p/DataEntryToolbar.svg?style=flat)](http://cocoadocs.org/docsets/DataEntryToolbar)


DataEntryToolbar is a subclass of UIToolbar intended for use as the input accessory view of a keyboard or picker, providing Next, Previous, & Done buttons to navigate up and down a dynamic tableView.

## Example Setup


Create an instance of `DataEntryToolbar` in your `TableViewController` subclass. Be sure to provide your tableView in the initializer:

```swift
private lazy var dataEntryToolbar: DataEntryToolbar? = {
    if let dataEntryToolbar = DataEntryToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44), 
        table:self.tableView) as DataEntryToolbar? {
            
        // implement closures to be notified when buttons are tapped for additional customization:
        ...
        dataEntryToolbar.didTapDoneButtonFromTextField = { (lastActiveTextField) in
            if let textField = lastActiveTextField {
                self.textFieldShouldReturn(textField)
            }
        }
        ...

        return dataEntryToolbar
    } else {
        return nil
    }
}()
```


In `cellForRowAtIndexPath`, set a `DataEntryToolbar` instance as the `inputAccessoryView` for your cell's text field. Also, add that text field to the `tableTextFields` dictionary using the current indexPath as key:

```swift
override func tableView(tableView: UITableView, cellForRowAtIndexPath 
    indexPath: NSIndexPath) -> UITableViewCell {

    switch (indexPath.section) {

    // first section -- basic info
    case TableSections.BasicInfo.rawValue:
        switch (indexPath.row) {
        case 0:
            let nameCell = tableView.dequeueReusableCellWithIdentifier("NameCell", 
                forIndexPath: indexPath) as JDCustomTextFieldCell
            nameCell.textField.inputAccessoryView = self.dataEntryToolbar
            self.dataEntryToolbar?.tableTextFields[indexPath] = nameCell.textField
            nameCell.textField.text = self.textFieldData[indexPath]
            return nameCell
        }
        `...`
    }
    `...`
}
```


You can customize the appearance of the toolbar in several ways. The height can be specified in the initializer, or you can change the color of the toolbar itself or its buttons:

```swift
// adjust bar's tint color
self.dataEntryToolbar.barTintColor = UIColor.darkGrayColor()

// adjust prev/next button tint colors
self.dataEntryToolbar.previousButton.tintColor = UIColor.blueColor()
```



## Note

If using a subclass of `UITableViewController`, the active text field will always be automatically scrolled into a position above the keyboard so the user can see it. If you are using a `UITableView` inside a regular `UIViewController`, you will have to implement this functionality yourself.


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