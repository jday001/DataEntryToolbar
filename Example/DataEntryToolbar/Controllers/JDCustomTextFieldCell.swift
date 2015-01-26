//
//  JDCustomTextFieldCell.swift
//  DataEntryToolbar
//
//  Created by Jeff Day on 1/25/15.
//  Copyright (c) 2015 jeff. All rights reserved.
//

import UIKit

class JDCustomTextFieldCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textField.text = ""
        self.textField.inputView = nil
        self.textField.inputAccessoryView = nil
    }

}
