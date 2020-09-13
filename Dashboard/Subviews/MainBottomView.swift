import UIKit

class MainBottomView: UIView {

    // MARK: - UI Properties.

    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "background_main_bottom")

        return imageView
    }()

    let homeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon_home"), for: .normal)
        button.tintColor = UIColor.white
        
        button.snp.makeConstraints {
            $0.size.equalTo(48)
        }

        return button
    }()

    let playButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon_play"), for: .normal)
        button.tintColor = UIColor.white.withAlphaComponent(0.5)

        return button
    }()

    let profileButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "icon_profile_gray"), for: .normal)

        button.snp.makeConstraints {
            $0.size.equalTo(48)
        }

        return button
    }()

    let pinLabel: BadgeSwift = {
        let label = BadgeSwift()
        label.text = "1"
        label.textColor = UIColor.white
        label.isHidden = true
        #warning("pinLabel isHidden = true")
        return label
    }()

    // MARK: - Initialization.

    init() {
        super.init(frame: .zero)

        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }

        addSubview(profileButton)
        profileButton.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.trailing.equalTo(self).offset(-37)
        }

        addSubview(pinLabel)
        pinLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileButton.snp.top)
            $0.centerX.equalTo(profileButton.snp.trailing).inset(-2)
        }

        addSubview(homeButton)
        homeButton.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.leading.equalTo(self).offset(39)
        }

        addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.bottom.equalTo(self).offset(-7)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        pinLabel.cornerRadius = pinLabel.frame.height / 2
    }
}
