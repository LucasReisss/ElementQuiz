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
    
    let elementList = ["Carbono", "Ouro", "Cloro", "Sódio"]
    
    var currentElementIndex = 0
    
    var mode: Mode = .flashCard {
        didSet {
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
                       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateUI()
    }
    
    // Atualiza a UI do app no modo ficha de estudo
    func updateFlashCardUI(elementName: String) {
        
        // Campo de texto e teclado
        textField.isHidden = true
        textField.resignFirstResponder()
        
        // Rótulo da resposta
        if state == .answer {
            answerLabel.text = elementName
        }else{
            answerLabel.text = "?"
        }
    }
    
    // Atualiza a UI do app no modo teste
    func updateQuizUI(elementName: String) {
        // Campo de texto e teclado
        textField.isHidden = false
        switch state {
        case .question:
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
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
                answerLabel.text = "❌"
            }
        case .score:
            answerLabel.text = ""
            print("Your score is \(correctAnswerCount) out of \(elementList.count).")
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


}

