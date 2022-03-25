//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Lucas da Silva Reis on 14/03/22.
//

import UIKit

enum State {
    case question
    case answer
    case score
}

enum Mode {
    case flashCard
    case quiz
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    let fixedElementList = ["Carbono", "Ouro", "Cloro", "Sódio"]
    var elementList: [String] = []
    
    var currentElementIndex = 0
    
    var mode: Mode = .flashCard {
        didSet {
            switch mode {
            case .flashCard:
                setupFlashCards()
            case .quiz:
                setupQuiz()
            }
            
            updateUI()
        }
    }
    
    var state: State = .question
    
    //Estado específico de teste
    var answerIsCorrect = false
    var correctAnswerCount = 0
    

    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBAction func showAnswer(_ sender: Any) {
        state = .answer
        
        updateUI()
    }
    @IBAction func next(_ sender: Any) {
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
        }
        
        state = .question
        
        updateUI()
    }
                       
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        }else {
            mode = .quiz
        }
    }
                       
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mode = .flashCard
    }
    
    // Atualiza a UI do app no modo ficha de estudo
    func updateFlashCardUI(elementName: String) {
        
        // Campo de texto e teclado
        textField.isHidden = true
        textField.resignFirstResponder()
        
        //Botões
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Proximo elemento", for: .normal)
        
        // Rótulo da resposta
        if state == .answer {
            answerLabel.text = elementName
        }else{
            answerLabel.text = "?"
        }
        
        //Controle segmentado
        modeSelector.selectedSegmentIndex = 0
    }
    
    // Atualiza a UI do app no modo teste
    func updateQuizUI(elementName: String) {
        
        // Campo de texto e teclado
        textField.isHidden = false
        switch state {
        case .question:
            textField.isEnabled = true
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.isEnabled = false
            textField.resignFirstResponder()
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
        
        // Rótulo de resposta
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect{
                answerLabel.text = "Correto"
            }else{
                answerLabel.text = "❌\nResposta correta: " + elementName
            }
        case .score:
            answerLabel.text = ""
        }
        //Exibir pontuação
        if state == .score {
            displayScoreAlert()
        }
        
        //Controle segmentado
        modeSelector.selectedSegmentIndex = 1
        
        //Botões
        showAnswerButton.isHidden = true
        if currentElementIndex == elementList.count - 1 {
            nextButton.setTitle("Mostrar pontuação", for: .normal)
        }else {
            nextButton.setTitle("Próxima pergunta", for: .normal)
        }
        switch state {
        case .question:
            nextButton.isEnabled = false
        case .answer:
            nextButton.isEnabled = true
        case .score:
            nextButton.isEnabled = false
        }
    }
    
    // Atualiza a UI do app com base no seu modo e estado.
    func updateUI() {
        
        //Código compartilhado: atualização de imagem
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        //As atualizações de UI de um modo específico se dividem em dois
        // métodos para facilitar a leitura.
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            updateQuizUI(elementName: elementName)
        }
    }
    
    //Executa após o usuário pressionar a tecla Return no telado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Pega o texto do campo de texto
        let textFieldContents = textField.text!
        
        // Determina se o usuário rspondeu corretamente e atualiza o estado de teste
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
            answerIsCorrect = true
            correctAnswerCount += 1
        }else {
            answerIsCorrect = false
        }
        
        // O aplicativo agora deve mostrar a resposta ao usuário
        
        state = .answer
        
        updateUI()
        
        if answerIsCorrect {
            print("Correto")
        }else {
            print("❌")
        }
        
        return true
    }
    
    //Mostrar um alerta no IOS com a pontuação do teste do usuário
    func displayScoreAlert() {
        let alert = UIAlertController(title: "Quiz Socore", message: "Sua pontuação é \(correctAnswerCount) de \(elementList.count).", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func scoreAlertDismissed(_ action: UIAlertAction){
        mode = .flashCard
    }
    
    // Abre uma nova sessão de ficha de estudo.
    func setupFlashCards() {
        
        state = .question
        currentElementIndex = 0
        elementList = fixedElementList
        
    }
    
    // Abre um novo teste.
    func setupQuiz(){
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        correctAnswerCount = 0
        elementList = fixedElementList.shuffled()
    }


}

