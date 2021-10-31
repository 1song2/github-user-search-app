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
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        isStarred = !isStarred
    }
    
    static func nib() -> UINib {
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        return nib
    }
    
    func updateAvatarImage(with viewModel: UserViewModel, avatarImagesRepository: AvatarImagesRepository?) {
        avatarImageView.image = nil
        
        avatarImagesRepository?.fetchImage(with: viewModel.avatarUrl)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.avatarImageView.layer.masksToBounds = true
                self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
                self.avatarImageView.image = UIImage(data: $0)
            })
            .disposed(by: cellDisposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
