//
//  DataEntryToolbar.swift
//
//  Created by Jeff Day on 1/19/15.
//  Copyright (c) 2015 JDay Apps, LLC. All rights reserved.
//

import UIKit

/**
    A subclass of `UIToolbar` intended for use as the input accessory view of a keyboard or picker, providing Next, Previous, & Done buttons to navigate up and down a dynamic tableView.

    To set up:
        - Set a DataEntryToolbar instance as the inputAccessoryView of textFields you want to control
        - Add textFields to `tableTextFields` in cellForRowAtIndexPath, using the textField's cell's indexPath as a key
        - If you want to be notified when a user taps one of the navigation buttons, implement the appropriate didTap... closures
        - The look and feel of the toolbar and its buttons can be customized as you would with any toolbar (i.e. barStyle, barTintColor, or button tintColor properties)
*/
public class DataEntryToolbar: UIToolbar {
    
    /// The direction of the next text field that should become active.
    ///
    /// - Next: The following text field should become firstResponder.
    /// - Previous: The previous text field should become firstResponder.
    /// - Done: The current text field should resign firstResponder status.
    public enum ToolbarTraversalDirection: Int {
        case Next = 0, Previous, Done
    }
    
    
    // -----------------------------------------
    // MARK: - Delegate Closures
    // -----------------------------------------
    
    public typealias ButtonTapped = () -> ()
    public typealias ButtonTappedFromTextField = (UITextField?) -> ()
    
    public var didTapPreviousButton: ButtonTapped?
    public var didTapPreviousButtonFromTextField: ButtonTappedFromTextField?
    public var didTapNextButton: ButtonTapped?
    public var didTapNextButtonFromTextField: ButtonTappedFromTextField?
    public var didTapDoneButton: ButtonTapped?
    public var didTapDoneButtonFromTextField: ButtonTappedFromTextField?
    
    
    // -----------------------------------------
    // MARK: - Public Class Properties
    // -----------------------------------------
    
    /// A button for navigating backwards/upwards through textFields in `tableView`'s cells.
    public var previousButton :UIBarButtonItem!
    
    /// A button for navigating forwards/downwards through textFields in `tableView`'s cells.
    public var nextButton :UIBarButtonItem!
    
    /// A flexible space use to provide separation between previousButton/nextButton and doneButton.
    public var space :UIBarButtonItem!
    
    /// A button used to resign firstResponder status on the active textField contained in a `tableView`'s cell.
    public var doneButton :UIBarButtonItem!
    
    /// The UITableView object for which this toolbar is managing textField navigation.
    public var tableView: UITableView?
    
    /// A property holding the direction in which the user is navigating through textFields in `tableView`'s cells.
    public var toolbarTraversalDirection: ToolbarTraversalDirection!
    
    /// A dictionary containing textFields in `tableView`, identified by the containing cell's index path.
    public var tableTextFields: [NSIndexPath: UITextField] = [:]
    
    
    // -----------------------------------------
    // MARK: - Initializers
    // -----------------------------------------
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    public init(frame: CGRect, table: UITableView) {
        self.tableView = table
        super.init(frame: frame)
        self.setup()
    }
    
    
    // -----------------------------------------
    // MARK: - Private Class Methods
    // -----------------------------------------
    
    /// A method to create and setup bar button items, and add them to the toolbar.
    private func setup() {
        
        // setup the bar and buttons, with a flexible space between prev/next and done
        self.barStyle = .Default
        self.barTintColor = UIColor.darkGrayColor()
        self.previousButton = UIBarButtonItem(title: "Prev", style: .Plain, target: self, action: "previousButtonTapped")
        self.previousButton.tintColor = UIColor.whiteColor()
        self.nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextButtonTapped")
        self.nextButton.tintColor = UIColor.whiteColor()
        self.doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "doneButtonTapped")
        self.doneButton.tintColor = UIColor.greenColor()
        self.space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        // add buttons to the toolbar
        self.items = [self.previousButton, self.nextButton, self.space, self.doneButton]
    }
    
    /**
    findPreviousValidIndexPath is a recursive function that steps backward through the tableView's rows and sections
    until it finds a row with a textField in the `tableTextFields` dictionary.
    
    If a valid textField is found, it is activated as first responder.
    
    :param: indexPath The current index path being checked for a valid text field.
    :returns: Either the index path of a valid UITextField or nil.
    */
    private func findPreviousValidIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
        
        // if the current indexPath row is the first of a section, need to go back a section
        if indexPath.row > 0 {
            
            // search the current section
            let previousIndexPath: NSIndexPath = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
            if let foundTextField: UITextField = self.tableTextFields[previousIndexPath] {
                foundTextField.becomeFirstResponder()
                return previousIndexPath
            } else {
                self.findPreviousValidIndexPath(previousIndexPath)
            }
        } else {
            
            // need to go back a section
            if indexPath.section > 0 {
                let previousSection: Int = indexPath.section - 1
                
                // make sure there is a section before this one to go back to
                if let previousSectionRows = self.tableView?.numberOfRowsInSection(previousSection) {
                    if let previousIndexPath = NSIndexPath(forRow: previousSectionRows - 1, inSection: previousSection) {
                        
                        // make sure the preceding section has rows
                        if previousSectionRows > 0 {
                            if let foundPrevPath: UITextField = self.tableTextFields[previousIndexPath] {
                                foundPrevPath.becomeFirstResponder()
                                return previousIndexPath
                            } else {
                                self.findPreviousValidIndexPath(previousIndexPath)
                            }
                        } else {
                            self.findPreviousValidIndexPath(previousIndexPath)
                        }
                    }
                }
            }
        }
        return nil
    }
    
    /**
    findNextValidIndexPath is a recursive function that steps foward through the tableView's rows and sections
    until it finds a row with a textField in the `tableTextFields` dictionary.
    
    If a valid textField is found, it is activated as first responder.
    
    :param: indexPath The current index path being checked for a valid text field.
    :returns: Either the index path of a valid UITextField or nil.
    */
    private func findNextValidIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
        
        // if the current indexPath is the last of a section, need to go up a section
        if let lastRowOfSectionIndex = self.tableView?.numberOfRowsInSection(indexPath.section) {
            if indexPath.row < lastRowOfSectionIndex - 1 {
                
                // search the current section
                let nextIndexPath: NSIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                if let foundTextField: UITextField = self.tableTextFields[nextIndexPath] {
                    foundTextField.becomeFirstResponder()
                    return nextIndexPath
                } else {
                    self.findNextValidIndexPath(nextIndexPath)
                }
            } else {
                
                // need to go up a section
                if let lastTableSection = self.tableView?.numberOfSections() {
                    let nextTableSection = indexPath.section + 1
                    
                    // make sure there is a section after this one
                    if nextTableSection < lastTableSection - 1 {
                        if let nextIndexPath = NSIndexPath(forRow: 0, inSection: nextTableSection) {
                            
                            // make sure the next section has rows
                            if self.tableView?.numberOfRowsInSection(nextTableSection) > 0 {
                                if let foundTextField: UITextField = self.tableTextFields[nextIndexPath] {
                                    foundTextField.becomeFirstResponder()
                                    return nextIndexPath
                                } else {
                                    self.findNextValidIndexPath(nextIndexPath)
                                }
                            } else {
                                self.findNextValidIndexPath(nextIndexPath)
                            }
                        }
                    }
                }
            }
        }
        return nil
    }
    
    /// Sets the buttonTraversalDirection to .Previous, activates the previous textField in `tableTextFields`, and calls the delegate's previousButtonTapped method for any custom behavior.
    @objc private func previousButtonTapped() {
        
        // set property for the direction a user is navigating
        self.toolbarTraversalDirection = .Previous
        
        // move back to the previous textField or resign firstResponder status if already at first textField
        var lastActiveTextField: UITextField?
        for (indexPath, textField) in self.tableTextFields {
            
            // found the currently active textField -- dismiss it and look for the previous textField or just resign if we are at the beginning
            if textField.isFirstResponder() {
                lastActiveTextField = textField
                textField.resignFirstResponder()
                
                if let prevPath: NSIndexPath = findPreviousValidIndexPath(indexPath) {}
                break
            }
        }
        
        // call the closure method for any further customization
        if let textFieldToReturn = lastActiveTextField {
            self.didTapPreviousButtonFromTextField?(lastActiveTextField)
        } else {
            self.didTapPreviousButton?()
        }
    }
    
    /// Sets the buttonTraversalDirection to .Next, activates the next textField in `tableTextFields`, and calls the delegate's nextButtonTapped method for any custom behavior.
    @objc private func nextButtonTapped() {
        
        // set property for the direction a user is navigating
        self.toolbarTraversalDirection = .Next
        
        // move forward to the next textfield or resign firstResponder status if already at last textField
        var lastActiveTextField: UITextField?
        for (indexPath, textField) in self.tableTextFields {
            
            // found the currently active textField -- dismiss it and look for the next textField or just resign if we are at the end
            if textField.isFirstResponder() {
                lastActiveTextField = textField
                textField.resignFirstResponder()
                
                if let nextPath: NSIndexPath = findNextValidIndexPath(indexPath) {}
                break
            }
        }
        
        // call the closure method for any further customization
        if let textFieldToReturn = lastActiveTextField {
            self.didTapNextButtonFromTextField?(lastActiveTextField)
        } else {
            self.didTapNextButton?()
        }
    }
    
    /// Sets the buttonTraversalDirection to .Done and calls the delegate's doneButtonTapped method.
    @objc private func doneButtonTapped() {
        
        // set property for the direction a user is navigating
        self.toolbarTraversalDirection = .Done
        
        // resign firstResponder status on the active textField
        var lastActiveTextField: UITextField?
        for (indexPath, textField) in self.tableTextFields {
            
            // found the currently active textField -- dismiss it and look for the next textField or just resign if we are at the end
            if textField.isFirstResponder() {
                lastActiveTextField = textField
                textField.resignFirstResponder()
                break
            }
        }
        
        // call the closure method for any further customization
        if let textFieldToReturn = lastActiveTextField {
            self.didTapNextButtonFromTextField?(lastActiveTextField)
        } else {
            self.didTapNextButton?()
        }
    }
}