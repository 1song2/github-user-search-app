//
//  UserCell.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import UIKit

class UserCell: UITableViewCell {
    static let height = CGFloat(60)
    static let reuseIdentifier = String(describing: UserCell.self)
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    var isStarred: Bool = false {
        didSet {
            if isStarred {
                starButton.setImage(UIImage(named: "star-fill"), for: [])
            } else {
                starButton.setImage(UIImage(named: "star"), for: [])
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        isStarred = !isStarred
    }
    
    static func nib() -> UINib {
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        return nib
    }
}
