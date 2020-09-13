
import UIKit

class ProfileInMainView: UIView {
    
    // MARK: - UI Properties.
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.width.equalTo(36)
        }
        
        return imageView
    }()
    
    private let iconPlaceholderImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "icon_profile_small")
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .text(.regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .text(.subTitle)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ nameLabel, subtitleLabel ])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        
        return stackView
    }()
    
    private lazy var hstackView: UIStackView = {
        let hstackView = UIStackView(arrangedSubviews: [ iconImageView, stackView ])
        hstackView.distribution = .fill
        hstackView.alignment = .fill
        hstackView.axis = .horizontal
        hstackView.spacing = 8
        
        return hstackView
    }()
    
    // MARK: - Initialization.
    
    init() {
        super.init(frame: .zero)
        
        iconImageView.addSubview(iconPlaceholderImageView)
        iconPlaceholderImageView.snp.makeConstraints {
            $0.center.equalTo(iconImageView)
        }
        
        addSubview(hstackView)
        hstackView.snp.makeConstraints {
            $0.leading.equalTo(self)
            $0.trailing.equalTo(self)
            $0.centerY.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods.
    
    func configure() {
        if let profile = Profile.current {
            nameLabel.text = profile.name
            subtitleLabel.text = (profile.rank?.name ?? "") + " • " + profile.points.miracle()
            
            if let url = profile.avatar {
                ImageLoader().fetchImage(from: url) { [weak self] (image) in
                    self?.iconImageView.image = image
                    self?.iconPlaceholderImageView.isHidden = image != nil
                }
            }
            else {
                iconImageView.image = nil
                iconPlaceholderImageView.isHidden = false
            }
        }
    }
}
