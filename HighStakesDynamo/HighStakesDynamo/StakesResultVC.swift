//
//  StakesResultVC.swift
//  HighStakesDynamo
//
//  Created by SunTory on 2024/9/25.
//

import UIKit

class StakesResultVC: UIViewController {

    @IBOutlet weak var lblScore: UILabel!
    
    @IBOutlet weak var fieldFeedBack: UITextView!
    
    var score: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        lblScore.text = score
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func btnFeedBack(_ sender: UIButton) {
        showAlertWithInput(str: "Thank You For Feedback.")
        fieldFeedBack.text = "FEEDBACK:"
    }
    
    func showAlertWithInput(str: String){
        let alertController = UIAlertController(title: str, message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
        })
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnHome(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: false)
    }
}
