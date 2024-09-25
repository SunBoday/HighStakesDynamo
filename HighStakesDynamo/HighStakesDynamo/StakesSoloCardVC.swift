//
//  StakesSoloCardVC.swift
//  HighStakesDynamo
//
//  Created by SunTory on 2024/9/25.
//

import UIKit

class StakesSoloCardVC: UIViewController {

    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var sldrTimer: UISlider!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblCorrect: UILabel!
    @IBOutlet weak var lblWrong: UILabel!
    @IBOutlet weak var lblCard1: UILabel!
    @IBOutlet weak var lblCard2: UILabel!
    
    let arrCards: [StakesCard] = [
    StakesCard(
        name: "2",
        value: 2),
    StakesCard(
        name: "3",
        value: 3),
    StakesCard(
        name: "4",
        value: 4),
    StakesCard(
        name: "5",
        value: 5),
    StakesCard(
        name: "6",
        value: 6),
    StakesCard(
        name: "7",
        value: 7),
    StakesCard(
        name: "8",
        value: 8),
    StakesCard(
        name: "9",
        value: 9),
    StakesCard(
        name: "10",
        value: 10),
    StakesCard(
        name: "J",
        value: 11),
    StakesCard(
        name: "Q",
        value: 12),
    StakesCard(
        name: "K",
        value: 13),
    StakesCard(
        name: "A",
        value: 14),
    
    ]
    
    var timer: Timer?{
        didSet{
            if timer != nil{
                print("Timer Started")
            }else{
                print("Timer Stoped")
            }
        }
    }
    
    var counter = 20{
        didSet{
            lblTimer.text = "\(counter)"
            sldrTimer.value = Float(counter)/100
        }
    }
    var score = 0{
        didSet{
            print(score,"....score")
            lblScore.text = """
            SCORE
            \(score)
            """
        }
    }
    
    var correct = 0{
        didSet{
            lblCorrect.text = """
            CORRECT
            \(correct)
            """
        }
    }
    
    var wrong = 0{
        didSet{
            lblWrong.text = """
            WRONG
            \(wrong)
            """
        }
    }
    
    var card1: StakesCard?{
        didSet{
            lblCard1.text = card1?.name
        }
    }
    
    var card2: StakesCard?{
        didSet{
            lblCard2.text = card2?.name
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timer?.invalidate()
        self.timer = nil
        self.counter = 100
        self.score = 0
        self.correct = 0
        self.wrong = 0
        
        card1 = arrCards.randomElement()
        card2 = arrCards.randomElement()
        
        
            let alertController = UIAlertController(title: "Press Ok To Start.", message: "You have 100 seconds to play game, right attempt increase points also wrong remove points from existing.", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
                self.startTimer()
            })
            alertController.addAction(saveAction)
            present(alertController, animated: true, completion: nil)
        
            
    }
    
    

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    @objc func updateCounter() {
        
        counter -= 1
//        print(counter)
        
        if counter>10{
            lblTimer.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            lblTimer.textColor = .red
        }

        if counter <= 0 {
            timer?.invalidate()
            timer = nil
            ShowAlertFinish()
        }
    }
    
    
    @IBAction func btnAlert(_ sender: Any) {
        ShowAlertFinish()
    }
    
    func ShowAlertFinish(){
        
        let alertController = UIAlertController(title: "Time Over.", message: "Well Played..", preferredStyle: .alert)
        
        let actHome = UIAlertAction(title: "Go Home", style: .default, handler: { alert -> Void in
            self.navigationController?.popToRootViewController(animated: false)
        })
        let actRest = UIAlertAction(title: "Restart Game", style: .default, handler: { alert -> Void in
            self.viewDidLoad()
        })
        
        alertController.addAction(actHome)
        alertController.addAction(actRest)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnAns(_ sender: UIButton) {
        
        if card1?.value ?? 0 > card2?.value ?? 0{
            if sender.tag == 1{
                print("correct")
                correct += 1
                score += 10
            }else{
                print("Wrong")
                wrong += 1
                score -= 5
            }
        }else if card1?.value ?? 0 < card2?.value ?? 0{
            if sender.tag == 2{
                print("correct")
                correct += 1
                score += 10
            }else{
                print("Wrong")
                wrong += 1
                score -= 5
            }
        }else if card1?.value ?? 0 == card2?.value ?? 1{
            print("Both Are Same...")
            correct += 1
            score += 10
            
        }
        
        card1 = arrCards.randomElement()
        card2 = arrCards.randomElement()
        
    }
    
    
}

