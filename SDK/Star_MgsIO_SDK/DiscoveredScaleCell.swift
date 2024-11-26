//
//  DiscoveredScaleCellTableViewCell.swift
//  StarMgsIO_SDK_iOS_Swift
//
//  Created by Star Micronics on 2023/07/25.
//

import UIKit

class DiscoveredScaleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func create(title: String , subtitle:String){
        titleLabel.text = title
        subTitleLabel.text = subtitle
    }
    

}
