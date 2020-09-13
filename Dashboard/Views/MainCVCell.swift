import UIKit

class MainCVCell: UICollectionViewCell {

    // MARK: - UI Properties.

   private let blurredBackgroundView: UIView = {
        let view = UIVisualEffectView(frame: .zero)
        if #available(iOS 13.0, *) {
            view.effect = UIBlurEffect(style: .systemChromeMaterialDark)
        } else {
            view.effect = UIBlurEffect(style: .dark)
        }
        view.clipsToBounds = true
        view.layer.cornerRadius = 14

        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .text(.regular)
        label.textAlignment = .left
        label.numberOfLines = 3

        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit

        imageView.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(44)
        }

        return imageView
    }()

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ titleLabel, iconImageView ])
        stackView.isUserInteractionEnabled = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 0

        return stackView
    }()

    private let countLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 32, weight: .regular)
        label.textColor = .text(.regular)
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return label
    }()

    private let countAllLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .text(.regular)
        label.textAlignment = .left

        return label
    }()

    private lazy var countstackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ countLabel, countAllLabel ])
        stackView.isUserInteractionEnabled = false
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        stackView.axis = .horizontal
        stackView.spacing = 4

        return stackView
    }()

    private let actionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .text(.subTitle)
        label.textAlignment = .left

        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, countstackView ,actionLabel ])
        stackView.isUserInteractionEnabled = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 4

        return stackView
    }()

    // MARK: - Initialization.

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 14

        contentView.addSubview(blurredBackgroundView)
        blurredBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(12)
            $0.trailing.equalTo(contentView).offset(-12)
            $0.top.equalTo(contentView).inset(12)
            $0.bottom.equalTo(contentView).inset(8)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods.

    func configure(with type: TypeCell) {
        titleLabel.text = type.title
        iconImageView.image = type.icon
        actionLabel.text = type.subTitle

        switch type {
        case .wishes:
            countLabel.text = "\(Wish.completed.count)"
            countAllLabel.text = "из \(Wish.isWish.count)"
        case .statistic:
            if let month = StatsClass.current?.month {
                countLabel.text = "\(month.count)"
                countAllLabel.text = ""
                actionLabel.text = month.count.practice() + " за месяц"
            }
        case .merits:
            countLabel.text = "\(Merit.completed.count)"
            countAllLabel.text = "из \(Merit.current.count)"
        case .emotions:
            countLabel.text = "\(Emotion.completed.count)"
            countAllLabel.text = "из \(Emotion.current.count)"
        }
    }
}

extension MainCVCell {
    enum TypeCell: Int {
        case wishes
        case statistic
        case merits
        case emotions

        var title: String {
            switch self {
            case .wishes:
                return "Желания"
            case .statistic:
                return "Статистика"
            case .merits:
                return "Позитивные качества"
            case .emotions:
                return "Негативные эмоции"
            }
        }

        var subTitle: String {
            switch self {
            case .wishes:
                return "выполнено"
            case .statistic:
                return "практик за месяц"
            case .merits:
                return "проработано"
            case .emotions:
                return "проработано"
            }
        }

        var icon: UIImage? {
            switch self {
            case .wishes:
                return UIImage(named: "icon_wishes")
            case .statistic:
                return UIImage(named: "icon_statistic")
            case .merits:
                return UIImage(named: "icon_qualities")
            case .emotions:
                return UIImage(named: "icon_emotions")
            }
        }
    }
}
