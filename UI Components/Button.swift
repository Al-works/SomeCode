import UIKit

class Button: UIButton {
    
    // MARK: - UI Properties.
    
    let textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .oswald(withSize: 15, andWeight: .regular)
        label.textColor = .text(.regular)
        
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.startAnimating()
        activityIndicator.color = .tint(.navbar)
        activityIndicator.isHidden = true
        activityIndicator.alpha = 0
        
        return activityIndicator
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.isUserInteractionEnabled = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let iconView = UIImageView(frame: .zero)
    
    // MARK: - Properties.
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    // MARK: - Observed Properties.
    
    var isInProgress: Bool = false {
        didSet {
            isEnabled = !isInProgress
            
            if self.textLabel.isHidden == false {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    self.activityIndicator.isHidden = !self.isInProgress
                    self.activityIndicator.alpha = self.isInProgress
                        ? 1
                        : 0
                })
            }
        }
    }
    
    // MARK: - Initialization.
    
    private init() {
        super.init(frame: .zero)
        clipsToBounds = true
        
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(textLabel)
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.center.equalTo(self)
        }
    }
    
    convenience init(content: Content? = nil, style: Style) {
        self.init()
        
        if let content = content {
            setContent(content)
        }
        
        layer.borderColor = style.borderColor
        layer.borderWidth = style.borderWidth
        backgroundColor = style.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle.
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    // MARK: - Public Methods.
    
    func setContent(_ content: Content) {
        switch content {
        case .title (let title):
            iconView.isHidden = true
            textLabel.text = title.uppercased()
        case .image (let image):
            textLabel.isHidden = true
            iconView.image = image
        case .resendSMSCountdown (let seconds):
            iconView.image = R.image.icon_resendSMSCode()
            
            if let seconds = seconds, seconds > 0 {
                let formattedSeconds = String(format: "%.0f", seconds)
                textLabel.text = R.string.localizable.authorization_sendAgainIn() + " " + "\(formattedSeconds)" + " " + R.string.localizable.abbreviation_seconds()
            }
            else {
                textLabel.text = R.string.localizable.authorization_sendAgain()
            }
        case .sendInvite (let title):
            iconView.image = R.image.icon_send_invite()
            textLabel.text = title.uppercased()
        case .refundWallet (let title):
            iconView.image = R.image.icon_refund()
            textLabel.text = title
        case .turnOnLights:
            iconView.image = R.image.icon_turnOffLights()
            iconView.contentMode = .center
            textLabel.text = R.string.localizable.rent_lightsOff()
            textLabel.font = .oswald(withSize: 17, andWeight: .regular)
        case .turnOffLights:
            iconView.image = R.image.icon_turnOnLights()
            iconView.contentMode = .center
            textLabel.text = R.string.localizable.rent_lightsOn()
            textLabel.font = .oswald(withSize: 17, andWeight: .regular)
        case .toggleSpeed (let gear):
            iconView.image = gear.icon
            iconView.contentMode = .center
            textLabel.text = gear.title
            textLabel.font = .oswald(withSize: 17, andWeight: .regular)
        }
    }
    
}

extension Button {
    enum Content {
        case title (String)
        case image (UIImage)
        case resendSMSCountdown (Seconds?)
        case sendInvite (String)
        case refundWallet (String)
        case turnOnLights
        case turnOffLights
        case toggleSpeed (Gear)
    }
    
    enum Style {
        case bordered (borderColor: UIColor = .border(.button), backgroundColor: UIColor = .clear)
        case filled (backgroundColor: UIColor = .background(.accent))
        
        var borderWidth: CGFloat {
            switch self {
            case .bordered:
                return .px
            case .filled:
                return 0
            }
        }
        
        var borderColor: CGColor? {
            switch self {
            case .bordered (let borderColor, _):
                return borderColor.cgColor
            case .filled:
                return nil
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .bordered (_, let backgroundColor):
                return backgroundColor
            case .filled (let backgroundColor):
                return backgroundColor
            }
        }
    }
}
