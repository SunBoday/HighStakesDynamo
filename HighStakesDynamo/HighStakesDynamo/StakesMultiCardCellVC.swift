//
//  StakesMultiCardCellVC.swift
//  HighStakesDynamo
//
//  Created by SunTory on 2024/9/25.
//

import UIKit

class StakesMultiCardCellVC: UICollectionViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func btn(_ sender: UIButton) {
        img.isHidden = true
    
    }
}
