import UIKit

class ProfileVerificationView: UIView {

    // MARK: - UI Properties.

    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .oswald(withSize: 17, andWeight: .regular)
        label.textColor = .text(.regular)
        label.textAlignment = .left

        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .oswald(withSize: 15, andWeight: .regular)
        label.textColor = .text(.textFieldTitle)
        label.textAlignment = .left

        return label
    }()

    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 2

        return stackView
    }()

    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, vStackView, UIView() ])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10

        return stackView
    }()

    private let shadowView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 5

        return view
    }()

    // MARK: - Initialization.

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 10

        addSubview(hStackView)
        hStackView.snp.makeConstraints {
            $0.leading.equalTo(self).offset(45)
            $0.trailing.equalTo(self).offset(-15)
            $0.centerY.equalTo(self)
        }

        addSubview(shadowView)
        shadowView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods.

    func configure(with icon: UIImage?, title: String?, subTitle: String?) {
        imageView.image = icon
        titleLabel.text = title
        subtitleLabel.text = subTitle
    }
}
