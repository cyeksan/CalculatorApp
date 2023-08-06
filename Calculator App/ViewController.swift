import UIKit

class ViewController: UIViewController {
    var result: Float = 0
    var isResetNumberOnScreen = false
    var currentOperation: String? = nil
    var lastNumberOnScreen: Float? = nil // Store the last value for the next operation
    var isOperationAvailable = true
    
    @IBOutlet weak var numberOnScreen: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNumberButtons()
        setupOperationButtons()
    }
    
    func setupNumberButtons() {
        for tag in 1...11 {
            if let button = view.viewWithTag(tag) as? UIButton {
                button.addTarget(self, action: #selector(onNumberButtonPressed(_:)), for: .touchUpInside)
            }
        }
    }
    
    func setupOperationButtons() {
        for tag in 13...16 {
            if let button = view.viewWithTag(tag) as? UIButton {
                button.addTarget(self, action: #selector(onOperationPressed(_:)), for: .touchUpInside)
            }
        }
    }
    
    @IBAction func onNumberButtonPressed(_ sender: UIButton) {
        isOperationAvailable = true
        if (isResetNumberOnScreen == true) {
            numberOnScreen.text = "0"
            isResetNumberOnScreen = false
        }
        
        if let buttonText = sender.titleLabel?.text {
            if (buttonText == ".") {
                if(numberOnScreen.text!.contains(".") == false) {
                    numberOnScreen.text! += buttonText
                }
                return
            }
            if (numberOnScreen.text == "0") {
                numberOnScreen.text = buttonText
                return
            }
            numberOnScreen.text! += buttonText
        }
    }
    
    @IBAction func onOperationPressed(_ sender: UIButton) {
        if let operation = sender.titleLabel?.text {
            if lastNumberOnScreen != nil && isOperationAvailable == true {
                calculate()
            }
            currentOperation = operation
            lastNumberOnScreen = Float(numberOnScreen.text!)
            isResetNumberOnScreen = true
            isOperationAvailable = false
        }
    }
    
    @IBAction func onEqualPressed(_ sender: Any) {
        if(lastNumberOnScreen != nil) {
            calculate()
            lastNumberOnScreen = nil
        }
        isResetNumberOnScreen = true
    }
    
    
    @IBAction func onPlusMinusPressed(_ sender: Any) {
        if(Float(numberOnScreen.text!) != nil) {
            result = -Float(numberOnScreen.text!)!
            displayResult(result: result)
        }
    }
    
    
    @IBAction func onClearPressed(_ sender: Any) {
        result = 0
        displayResult(result: result)
        setupInitialValues()
    }
    
    @IBAction func onPercentagePressed(_ sender: Any) {
        if(Float(numberOnScreen.text!) != nil) {
            result = Float(numberOnScreen.text!)!/100
            displayResult(result: result)
        }
    }
    
    func setupInitialValues() {
        isResetNumberOnScreen = false
        currentOperation = nil
        lastNumberOnScreen = nil
        isOperationAvailable = true
    }
    
    func displayResult(result: Float) {
        print("Result: \(result)")
        if (result == -Float.infinity) {
            numberOnScreen.text = "-Inf"
            return
        }
        
        if(result == Float.infinity) {
            numberOnScreen.text = "+Inf"
            return
        }
        numberOnScreen.text = formatFloat(result)
    }
    
    func calculate() {
        if let operation = currentOperation,
           let floatValue = Float(numberOnScreen.text!),
           let lastValue = lastNumberOnScreen {
            switch operation {
            case "+":
                result = lastValue + floatValue
            case "-":
                result = lastValue - floatValue
            case "×":
                result = lastValue * floatValue
            case "÷":
                result = lastValue / floatValue
            default:
                break
            }
        }
        
        displayResult(result: result)
    }
    
    func formatFloat(_ value: Float) -> String {
        let largeNumberThreshold: Float = 1_000_000.0 // Define the threshold for large numbers
        let smallNumberThreshold: Float = 0.000001 // Define the threshold for small numbers
        let absoluteValue = abs(value)
        
        if(value == 0.0) {
           return "0"
        }
        
        if absoluteValue >= largeNumberThreshold || absoluteValue <= smallNumberThreshold {
            return String(value)
        } else {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = numberOfDecimalPoints(absoluteValue)
            let formattedString = formatter.string(from: NSNumber(value: absoluteValue)) ?? ""
            return value < 0 ? "-" + formattedString : formattedString
        }
    }
    
    
    func numberOfDecimalPoints(_ floatValue: Float) -> Int {
        let stringValue = String(floatValue)
        if let dotIndex = stringValue.firstIndex(of: ".") {
            return stringValue.distance(from: dotIndex, to: stringValue.endIndex) - 1
        }
        return 0
    }
}


