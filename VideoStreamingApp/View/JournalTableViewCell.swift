//
//  JournalTableViewCell.swift
//  VideoStreamingApp
//
//  Created by Preeti Priyam on 5/6/21.
//

import UIKit

class JournalTableViewCell: UITableViewCell {
    @IBOutlet weak var chapterLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!
    
    static let identifier = "JournalTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func getNib() -> UINib{
        return UINib(nibName: JournalTableViewCell.identifier, bundle: nil)
    }
    
}
