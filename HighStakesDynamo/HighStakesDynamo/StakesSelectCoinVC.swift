//
//  StakesSelectCoinVC.swift
//  HighStakesDynamo
//
//  Created by SunTory on 2024/9/25.
//

import UIKit
import Foundation

class StakesSelectCoinVC: UIViewController {
    
    let stakes_dateFormatter = DateFormatter()
    let stakes_start = Date()
        
    @IBOutlet weak var stakes_cvList: UICollectionView!
    @IBOutlet weak var stakes_lblCard: UILabel!
    @IBOutlet weak var stakes_btnScore: UIButton!
        
        let arrCards: [StakesPokerCoinModel] = [
            //.
            StakesPokerCoinModel(
                symbolText: "➊",
                id: 1),
            StakesPokerCoinModel(
                symbolText: "➋",
                id: 2),
            StakesPokerCoinModel(
                symbolText: "➌",
                id: 3),
            StakesPokerCoinModel(
                symbolText: "➍",
                id: 4),
            StakesPokerCoinModel(
                symbolText: "➎",
                id: 5),
            StakesPokerCoinModel(
                symbolText: "➏",
                id: 6),
            StakesPokerCoinModel(
                symbolText: "➐",
                id: 7),
            StakesPokerCoinModel(
                symbolText: "➑",
                id: 8),
            StakesPokerCoinModel(
                symbolText: "➒",
                id: 9),
            StakesPokerCoinModel(
                symbolText: "⓿",
                id: 10)
        ]
        
        var arrList: [StakesPokerCoinModel]? = nil{
            didSet{
                stakes_cvList.reloadData()
            }
        }
        
        var VisibleCard: StakesPokerCoinModel?{
            didSet{
                stakes_lblCard.text = VisibleCard?.symbolText
            }
        }
        
        var score: Int = 0 {
            didSet{
                
                if score > 500{
                    playWin()
                    if #available(iOS 15, *) {
                        let tm = Calendar.current.dateComponents([.hour, .minute, .second], from: stakes_start, to: .now)
                        
                        let vc = storyboard?.instantiateViewController(withIdentifier: "ResultVC")as! StakesResultVC
                        vc.score = """
                    Congratulations...
                    Your Score is \(score).
                    Completed in: \(tm.hour ?? 00):\(tm.minute ?? 00):\(tm.second ?? 00)
                    """
                        navigationController?.pushViewController(vc, animated: true)
                        return
                        
                    }
                    
                    let vc = storyboard?.instantiateViewController(withIdentifier: "ResultVC")as! StakesResultVC
                    vc.score = """
                Congratulations...
                Your Score is \(score).
                """
                    navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                stakes_btnScore.setTitle("\(score)", for: .normal)
                
            }
        }
        
//    var audioPlayer: AVAudioPlayer?

    
        //MARK: did load
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            VisibleCard = arrCards.randomElement()
            arrList = arrCards.shuffled()
            
        }
    }

extension StakesSelectCoinVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = stakes_cvList.dequeueReusableCell(withReuseIdentifier: "MultiCardCellVC", for: indexPath)as! StakesMultiCardCellVC
        
        cell.lbl.text = arrList?[indexPath.row].symbolText
        cell.btn.tag = arrList?[indexPath.row].id ?? 1
        cell.btn.addTarget(self, action: #selector(CellCelected(_:)), for: .touchUpInside)
        cell.img.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4){
            cell.img.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizer = CGSize(width: stakes_cvList.bounds.width/2, height: stakes_cvList.bounds.height/5)
        return sizer
    }
    
    @objc func CellCelected(_ sender: UIButton){
        
        if sender.tag == VisibleCard?.id ?? 0{
            
            score += 40
            playSound()
            VisibleCard = arrCards.randomElement()
            arrList = arrCards.shuffled()
            
        }else{
            playWrong()
            score -= 10
            
        }
    }
    
}
