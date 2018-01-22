//
//  ElementsTestViewController.swift
//  
//
//  Created by Jaroslaw Oleksy on 15.09.2016.
//
//

import UIKit
import FirebaseAuth
import Firebase

class ElementsTestViewController: UIViewController, UITextFieldDelegate {
    
    var elementsArray = ["srebro": ["Ag", "Łacińska nazwa to Argentum. Srebro to metal szlachetny. Było używane jako waluta, a także do produkcji biżuterii, srebrnych naczyń i sztućców. Obecnie stosuje się do produkcji filmów fotograficznych i luster. Srebro ma też właściwości bakteriobójcze. Jeżeli zjesz dużo srebra, to twój kolor skóry zmieni się na zawsze na niebieskoszary."], "glin": ["Al", "Jego łacińska nazwa to aluminium. Jest to metal. Folie aluminiowe stosowane są do pakowania żywności, a także jako ekrany cieplne zapobiegając utracie ciepła."], "złoto": ["Au", "Złoto po łacinie to aurum. To metal szlachetny używany w biciu monet, jubilerstwie, sztuce i zdobieniach. Na świecie jest wydobywane w Południowej Afryce, Rosji i Australii. W Polsce wydobywano złoto na Dolnym Śląsku, w okolicach Złotego Stoku i Złotoryi."], "węgiel": ["C", "Węgiel po łacinie to carboneum. Jest paliwem kopalnym, a jego spalanie przyczynia się do powstawania efektu cieplarnianego. Grafit oraz diament to najbardziej znane odmiany wegla. Węgiel jest czwartym najczęściej występującym pierwiastkiem we wszechświecie i jest obecny we wszystkich organizmach żywych."], "wapń": ["Ca", "Po łacinie to calcium. Wapń czysty to srebrzystobiały metal. Stosowany jest do produkcji gipsu, zapraw murarskich, nawozów. Wchodzi także w skład kości ludzi i zwierząt dlatego bardzo ważne jest jego spożywanie."], "chlor": ["Cl", "Chlor po łacinie to chlorum. Jest żółtozielonym gazem cięższym od powietrza. Jest silnie trujący o nieprzyjemnym, duszącym zapachu. Jest silnym utleniaczem, wybielaczem i środkiem dezynfekującym. Jest używany w instalacjach do uzdatniania wody. Produktem ubocznym powstającym podczas procesu chlorowania wody jest toksyczny dla ludzi chloroform, który był używany jako środek usypiający podczas zabiegów chirurgicznych. Jest rakotwórczy, więc dzisiaj używane są inne środki."], "chrom": ["Cr", "łac. chrominium. Nazwa wywodzi się od greckiego słowa \"chroma\" oznaczającego \"kolor\". W naturze występuje w drożdżach piekarskich, kolbie kukurydzy, gotowanej wołowinie, jabłkach. Chrom jest srebrzystoszarym metalem, który z tlenem tworzy na metalach powłokę ochronną i zabezpiecza postępowaniu korozji na metalu."], "miedź": ["Cu", "łac. cuprum. Nazwa ta pochodzi od Cypru, gdzie w starożytności wydobywano ten metal. Jest on bardzo miękki o kolorze pomarańczowoczerwonym. Na powietrzu ciemnieje wskutek utlanienia. Po długim czasie pokrywa się zieloną warstwą patyny. Często jest to widoczne na starych kościołach. Statua Wolności w Nowym Jorku ma kolor zielony, ponieważ została pokryta miedzią."], "fluor": ["F", "łac. fluorum. Jest żółtozielonym silnie trującym gazem o ostrym zapachu podobnym do chloru. Używany jest w produkcji cieczy chłodzących, a także w pastach do zębów jako środek wybielający."], "żelazo": ["Fe", "Żelazo po łacinie to ferrum. Ten metal jest znany od czasów starożytnych. Czyste żelazo jest lśniącym, srebrzystym, twardym metalem. Należy także do mikroelementów, które są bardzo ważne dla rozwoju organizmu."], "wodór": ["H", "łac. hydrogenium. Jest najczęściej występującym pierwiaskiem we wszechświecie. Wraz z tlenem tworzy wodę (dwa atomy wodoru i jeden tlenu). Balony aby unosić się w powietrzu były napełniane wodorem, a pierwszy lot takim balonem odbył się w 1783 r. Używany jest także w bombach wodorowych."]]

    var shouldChooseNextElement = false
    var elementsNames = [String]()
    var elementsSymbols = [String]()
    var elementsDescription = [String]()
    var symbolNumber = Int()
    var correctAnswersCount = 0.0
    var totalAnswers = 0.0
    
    @IBAction func goToMenu(_ sender: AnyObject) {
        
        //revealViewController().revealToggle(sender)
        //sender.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        
        
    }
    @IBAction func logout(_ sender: AnyObject) {
        
        //try! FIRAuth.auth()!.signOut()
        
    }
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var elementNameLabel: UILabel!
    @IBOutlet var symbolTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var thumbImage: UIImageView!
    @IBOutlet var checkSymbolButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    
    @IBAction func checkSymbol(_ sender: AnyObject) {
        
        if totalAnswers == 0 {
            
            restartGame()
            
        }
            
        if totalAnswers >= 5 {
                
            let note = Int(100*(correctAnswersCount / totalAnswers))
            headerLabel.text = "Twoja ocena to:"
            elementNameLabel.text = String(note) + "%"
            checkSymbolButton.setTitle("Jeszcze raz", for: [])
            symbolTextField.isHidden = true
            commentLabel.text = ""
            descriptionTextView.text = ""
            thumbImage.image = nil
                
            totalAnswers = 0
            correctAnswersCount = 0
                
        } else if shouldChooseNextElement {
                
                chooseElement()
                shouldChooseNextElement = false
                
            } else {
                
                if let givenSymbol = symbolTextField.text {
                    
                    if(givenSymbol.caseInsensitiveCompare(elementsSymbols[symbolNumber]) == ComparisonResult.orderedSame) {
                        
                        commentLabel.text = "Brawo Jasiu! Będzie z Ciebie niezły Chemik"
                        checkSymbolButton.setTitle("Następny", for: [])
                        descriptionTextView.text = elementsDescription[symbolNumber]
                        thumbImage.image = UIImage(named: "thumb-up.png")
                        
                        elementsNames.remove(at: symbolNumber)
                        elementsSymbols.remove(at: symbolNumber)
                        elementsDescription.remove(at: symbolNumber)

                        
                        correctAnswersCount += 1
                        totalAnswers += 1
                        
                        shouldChooseNextElement = true
                        view.endEditing(true)
                        
                    } else {
                        
                        commentLabel.text = "Źle. Prawidłowa odpowiedź to \(elementsSymbols[symbolNumber])"
                        
                        checkSymbolButton.setTitle("Następny", for: [])
                        descriptionTextView.text = elementsDescription[symbolNumber]
                        thumbImage.image = UIImage(named: "thumb-down.png")
                        
                        elementsNames.remove(at: symbolNumber)
                        elementsSymbols.remove(at: symbolNumber)
                        elementsDescription.remove(at: symbolNumber)

                        
                        totalAnswers += 1
                        shouldChooseNextElement = true
                        view.endEditing(true)
                        
                    }
                }
                
            }
            
        }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        symbolTextField.delegate = self
        symbolTextField.layer.borderWidth = 1
        let myColor: UIColor = UIColor.white
        symbolTextField.layer.borderColor = myColor.cgColor
        symbolTextField.layer.cornerRadius = 30.0
        
        nextButton.backgroundColor = UIColor(white: 1.0, alpha: 0.22)
        nextButton.layer.cornerRadius = 5.0
    
        for (name, symbolAndDescriptionArray) in elementsArray {
            
            elementsNames.append(name)
            elementsSymbols.append(symbolAndDescriptionArray[0])
            elementsDescription.append(symbolAndDescriptionArray[1])
            
        }
        
        chooseElement()
        
        // setting the sidebar menu
        if self.revealViewController() != nil {
            
            //.target = self.revealViewController()
            //menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }
    }

    func chooseElement() {
        
        symbolNumber = Int(arc4random_uniform(UInt32(elementsNames.count)))
        elementNameLabel.text = elementsNames[symbolNumber]
        checkSymbolButton.setTitle("Sprawdzamy", for: [])
        symbolTextField.text = ""
        commentLabel.text = ""
        thumbImage.image = nil
        descriptionTextView.text = ""
    }
    
    func restartGame() {
        
        headerLabel.text = "Jaki symbol chemiczny ma"
        symbolTextField.isHidden = false
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkSymbol(self)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
