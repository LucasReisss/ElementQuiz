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
}

enum Mode {
    case flashCard
    case quiz
}

class ViewController: UIViewController {
    
    let elementList = ["Carbono", "Ouro", "Cloro", "Sódio"]
    
    var currentElementIndex = 0
    
    var mode: Mode = .flashCard
    
    var state: State = .question
    

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
        }
        
        state = .question
        
        updateUI()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateUI()
    }
    
    // Atualiza a UI do app no modo ficha de estudo
    func updateFlashCardUI() {
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        if state == .answer {
            answerLabel.text = elementName
        }else{
            answerLabel.text = "?"
        }
    }
    
    // Atualiza a UI do app no modo teste
    func updateQuizUI() {
        
    }
    
    // Atualiza a UI do app com base no seu modo e estado.
    func updateUI() {
        switch mode {
        case .flashCard:
            updateFlashCardUI()
        case .quiz:
            updateQuizUI()
        }
    }


}

