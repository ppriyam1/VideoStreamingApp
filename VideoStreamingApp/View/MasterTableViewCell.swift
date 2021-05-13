//
//  MasterTableViewCell.swift
//  VideoStreamingApp
//
//  Created by Preeti Priyam on 5/3/21.
//

import UIKit

class MasterTVCell: UITableViewCell {
    
    @IBOutlet weak var textUiLabel: UILabel!
    
    static let identifier = "masterCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func getNib() -> UINib{
        return UINib(nibName: MasterTVCell.identifier, bundle: nil)
    }
    
}
