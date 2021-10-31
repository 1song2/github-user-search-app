//
//  UserCell.swift
//  GithubUserSearchApp
//
//  Created by Song on 2021/10/25.
//

import UIKit
import RxSwift

class UserCell: UITableViewCell {
    static let height = CGFloat(60)
    static let reuseIdentifier = String(describing: UserCell.self)
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    var onToggled: ((Bool) -> Void)?
    private let cellDisposeBag = DisposeBag()
    private var viewModel: UserViewModel?
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        onToggled?(!viewModel.isStarred.value)
    }
    
    static func nib() -> UINib {
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        return nib
    }
    
    func updateAvatarImage(with viewModel: UserViewModel, avatarImagesRepository: AvatarImagesRepository?) {
        avatarImageView.image = nil
        self.viewModel = viewModel
        
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
