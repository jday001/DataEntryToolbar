Pod::Spec.new do |s|
  s.name             = "DataEntryToolbar"
  s.version          = "0.1.2"
  s.summary          = "A subclass of UIToolbar used to navigate up and down a dynamic tableView's text fields'."
  s.description      = <<-DESC

                    DataEntryToolbar is a subclass of UIToolbar intended for use as the input accessory view of a keyboard or picker, providing Next, Previous, & Done buttons to navigate up and down a dynamic tableView.

                    To set up:
                    - Set a `DataEntryToolbar` instance as the inputAccessoryView of `UITextFields` you want to control
                    - Add textFields to `tableTextFields` in cellForRowAtIndexPath, using the textField's cell's indexPath as a key
                    - If you want to be notified when a user taps one of the navigation buttons, implement the necessary closures
                    - The look and feel of the toolbar and its buttons can be customized as you would with any toolbar (i.e. barStyle, barTintColor, or button tintColor properties)

                       DESC
  s.homepage         = "https://github.com/jday001/DataEntryToolbar"
  s.license          = 'MIT'
  s.author           = { "jeff" => "jday@jdayapps.com" }
  s.source           = { :git => "https://github.com/jday001/DataEntryToolbar.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jday001'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'DataEntryToolbar' => ['Pod/Assets/*.png']
  }
end
