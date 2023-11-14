import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var changeBackgroundColorButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var findPasswordButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stopButton: UIButton!
    
    private var stopProcess = false
    
    private var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.passwordLabel.textColor = .white
                self.activityIndicator.color = .white
                self.view.backgroundColor = .black
            } else {
                self.passwordLabel.textColor = .black
                self.activityIndicator.color = .gray
                self.view.backgroundColor = .white
            }
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedArround()
        setupStopButton()
        setupPasswordTextField()
        setupDelegates()
    }
    
    // MARK: Actions
    
    @IBAction func onChangeBackgroundColorPressed(_ sender: UIButton) {
        isBlack.toggle()
    }
    
    @IBAction func onStopPressed(_ sender: UIButton) {
        stopProcess = true
        findPasswordButton.isHidden = false
        findPasswordButton.titleLabel?.text = "Continue"
    }
    
    @IBAction func onFindPasswordPressed(_ sender: UIButton) {
        if let text = passwordTextField.text, !text.isEmpty {
            passwordLabel.isHidden = false
            activityIndicator.isHidden = false
            passwordTextField.isSecureTextEntry = false
            stopButton.isHidden = false
            findPasswordButton.isHidden = true
            
            let inputPassword = passwordTextField.text ?? ""
            passwordTextField.text = inputPassword
            
            guard let password = passwordTextField.text else { return }
            activityIndicator.startAnimating()
            stopProcess = false
            
            DispatchQueue.global().async { [weak self] in
                self?.bruteForce(passwordToUnlock: password)
            }
        } else {
            print("Text Field is empty")
        }
    }
    
    // MARK: Setup
    
    private func updateUI(with password: String) {
        passwordLabel.text = "Password is \(password)"
    }
    
    private func setupStopButton() {
        stopButton.isHidden = true
    }
    
    private func setupPasswordTextField() {
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.backgroundColor = .white
        passwordTextField.textColor = .black
    }
    
    private func setupDelegates() {
        passwordTextField.delegate = self
    }
    
    // MARK: BruteForce
    
    private func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password: String = ""
        
        while password != passwordToUnlock && !stopProcess {
            password = generateBruteForce(password, fromArray: allowedCharacters)
            
            DispatchQueue.main.async { [weak self] in
                self?.updateUI(with: password)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.passwordTextField.isSecureTextEntry = true
            self?.stopButton.isHidden = true
            self?.findPasswordButton.isHidden = false
        }
    }
}

private func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

private func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
    : Character("")
}

private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    
    var str: String = string
    
    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))
        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }
    return str
}


