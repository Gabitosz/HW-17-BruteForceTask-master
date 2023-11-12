import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var changeBackgroundColor: UIButton!
    @IBOutlet weak var generatedPassword: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var generatePassword: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    }
    
    // MARK: Actions
    
    @IBAction func onChangeBackgroundColorPressed(_ sender: Any) {
        isBlack.toggle()
    }
    
    @IBAction func onGeneratePasswordPressed(_ sender: UIButton) {
        passwordLabel.isHidden = false
        activityIndicator.isHidden = false
        generatedPassword.isSecureTextEntry = false
        passwordLabel.text = "Generating password..."
        generatedPassword.text = randomPassword(length: 3)
        print(generatedPassword.text)
        
        guard let password = generatedPassword.text else { return }
        activityIndicator.startAnimating()
        
        
        DispatchQueue.global().async { [weak self] in
            self?.bruteForce(passwordToUnlock: password)
        }
    
    }
    
    func randomPassword(length: Int) -> String {
        let allowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}|;:',.<>/?`"
        let counfOfAllowedCharacters = UInt32(allowedCharacters.count)
        var randomString = ""
        
        for _ in 0 ..< length {
            let randomNumber = Int(arc4random_uniform(counfOfAllowedCharacters))
            let randomIndex = allowedCharacters.index(allowedCharacters.startIndex, offsetBy: randomNumber)
            let newCharacter = allowedCharacters[randomIndex]
            randomString += String(newCharacter)
        }
        return randomString
    }
    
    
    private func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }

        var password: String = ""

        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: allowedCharacters)
        }

        DispatchQueue.main.async { [weak self] in
            self?.passwordLabel.text = password
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.generatedPassword.isSecureTextEntry = true
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

