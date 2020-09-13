import UIKit

class TitleView: UIView {

    // MARK: - UI Properties.

    private let blurredBackgroundView: UIView = {
        let view = UIVisualEffectView(frame: .zero)
        view.effect = UIBlurEffect(style: .extraLight)
        view.clipsToBounds = true

        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.isUserInteractionEnabled = false
        label.font = .oswald(withSize: 20, andWeight: .regular)
        label.textColor = .text(.regular)
        label.textAlignment = .center

        return label
    }()

    private let dropdownImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .right
        imageView.image = R.image.icon_dropdown()

        return imageView
    }()

    // MARK: - Properties.

    private weak var delegate: TitleViewDelegate?

    // MARK: - Initialization.

    init(title: String, content: Content = .title, addsBackgroundBlur: Bool = false) {
        super.init(frame: .zero)
        titleLabel.text = title

        if addsBackgroundBlur {
            addSubview(blurredBackgroundView)
            blurredBackgroundView.snp.makeConstraints {
                $0.leading.equalTo(self).offset(-15)
                $0.trailing.equalTo(self).offset(15)
                $0.top.equalTo(self).offset(-1)
                $0.bottom.equalTo(self).offset(2)
            }
        }

        switch content {
        case .title:
            configureAsTitle()
        case .titleWithDropdown (let delegate):
            configureAsTitleWithDropdown()
            self.delegate = delegate
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAsTitle() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self)
            $0.trailing.equalTo(self)
            $0.top.equalTo(self)
            $0.bottom.equalTo(self)
        }
    }

    private func configureAsTitleWithDropdown() {
        addSubview(dropdownImageView)
        dropdownImageView.snp.makeConstraints {
            $0.trailing.equalTo(self)
            $0.top.equalTo(self).offset(8)
            $0.bottom.equalTo(self)
            $0.width.equalTo(25)
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self)
            $0.trailing.equalTo(dropdownImageView.snp.leading)
            $0.top.equalTo(self)
            $0.bottom.equalTo(self)
        }
    }

    // MARK: - Lifecycle.

    override func layoutSubviews() {
        super.layoutSubviews()
        blurredBackgroundView.layer.cornerRadius = blurredBackgroundView.bounds.height / 2
    }

    // MARK: - User Interaction.

    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        delegate?.didTapTitleView(self)
    }

}

extension TitleView {
    enum Content {
        case title
        case titleWithDropdown (delegate: TitleViewDelegate)
    }
}

protocol TitleViewDelegate: AnyObject {
    func didTapTitleView(_ titleView: TitleView)
}
