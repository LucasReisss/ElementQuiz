//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Lucas da Silva Reis on 14/03/22.
//

import UIKit

enum Mode {
    case flashCard
    case quiz
}

class ViewController: UIViewController {

    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBAction func showAnswer(_ sender: Any) {
        answerLabel.text = elementList[currentElementIndex]
    }
    @IBAction func next(_ sender: Any) {
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
        }
        
        updateElement()
    }
    
    let elementList = ["Carbono", "Ouro", "Cloro", "Sódio"]
    
    var currentElementIndex = 0
    
    var mode: Mode = .flashCard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateElement()
    }
    
    func updateElement() {
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        answerLabel.text = "?"
    }


}

