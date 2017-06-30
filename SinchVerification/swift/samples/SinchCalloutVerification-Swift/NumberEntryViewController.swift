import UIKit;
import SinchVerification;

func PhoneNumberUtil() -> PhoneNumberUtil {
    return SharedPhoneNumberUtil();
}

class NumberEntryViewController: UIViewController {
    
    @IBOutlet var countryButton: UIButton!
    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var verifyButton: UIButton!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var isoCountryCode: String!
    var formatter: TextFieldPhoneNumberFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad();
      
        self.isoCountryCode = DeviceRegion.currentCountryCode();
        
        self.formatter = TextFieldPhoneNumberFormatter(countryCode: isoCountryCode);
        formatter.textField = numberTextField;
        formatter.onTextFieldTextDidChange = { (textField: UITextField) -> Void in
            self.onTextFieldTextDidChange(textField);
        }
        
        updateFormatter();
        updateCountrySelection();
        
        initAppearance(self);
    }
    
    func updateFormatter() {
        formatter.countryCode = isoCountryCode;
        numberTextField.placeholder = formatter.exampleNumber(PhoneNumberFormat.national)
    }
    
    func updateCountrySelection() {
        let regions = PhoneNumberUtil().regionList(forLocale: Locale.current);
        let displayName = regions.displayName(forRegion: isoCountryCode);
        let callingCode = regions.countryCallingCode(forRegion: isoCountryCode);
        countryButton.setTitle(String(format:"(+%@) %@", callingCode!, displayName), for: .normal);
    }
    
    func onTextFieldTextDidChange(_ textField: UITextField) {
        let update = {(enabled: Bool, color:UIColor) -> Void in
            self.verifyButton.isEnabled = enabled;
            self.numberTextField.backgroundColor = color;
        }
        
        let text = textField.text != nil ? textField.text! : "";
        let isPossibleNumber = PhoneNumberUtil().isPossibleNumber(text, fromRegion: isoCountryCode);

        if (textField.text!.isEmpty) {
            update(false, UIColor.clear);
        } else if (isPossibleNumber.possible){
            update(true, colorForPossiblePhoneNumber());
        } else {
            update(false, colorForNotPossiblePhoneNumber());
            print(isPossibleNumber.error!);
        }
        
    }
    
    @IBAction
    func verify(_ sender:AnyObject?) {
        _ = sender?.resignFirstResponder();
        
        let text = numberTextField.text != nil ? numberTextField.text! : "";
        
        do {
            let phoneNumber = try PhoneNumberUtil().parse(text, defaultRegion:isoCountryCode);
            
            let phoneNumberE164 = PhoneNumberUtil().format(phoneNumber, format: PhoneNumberFormat.e164);
            
            let verification = CalloutVerification("<APP KEY>", phoneNumber: phoneNumberE164);
          
            verification.initiate({ (result: InitiationResult, error: Error?) -> Void in
                if(result.success){
                    self.setStatusText("Verification Successful");
                } else {
                    self.setStatusText("Verification Failed");
                    showError(error! as NSError);
                }
            });
            
        } catch let error as PhoneNumberParseError {
            showError("Invalid phone number: " + String(describing: error));
        } catch {
            print(error);
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? CountrySelectionViewController {
            controller.isoCountryCode = isoCountryCode;
            controller.onCompletion = {(selectedCountryCode: String) -> Void in
                controller.dismiss(animated: true, completion: nil);
                self.isoCountryCode = selectedCountryCode;
                self.updateCountrySelection();
                self.updateFormatter();
            }
        }
    }
    
    func setStatusText(_ text:String) {
        statusLabel.text = text;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        numberTextField.becomeFirstResponder();
    }
    
}
