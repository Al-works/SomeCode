import UIKit

class ActionView: UIView {

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
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .text(.regular)
        label.textAlignment = .left
        label.text = "Действия"
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .text(.subTitle)
        label.textAlignment = .right

        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon_header_next")

        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ titleLabel, subtitleLabel, iconImageView ])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 0

        return stackView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .interactive
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        tableView.isScrollEnabled = true
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(TargetTableViewCell.self, forCellReuseIdentifier: TargetTableViewCell.reuseID)

        return tableView
    }()

    // MARK: - Properties.

    private var actions: [Action] = []


    // MARK: - Injected Properties.

    weak var delegate: ActionCellDelegate?

    // MARK: - Initialization.

    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 14

        addSubview(blurredBackgroundView)
        blurredBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(self).inset(16)
            $0.trailing.equalTo(self).offset(-16)
            $0.top.equalTo(self).inset(16)
        }

        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.equalTo(self)
            $0.trailing.equalTo(self)
            $0.top.equalTo(stackView.snp.bottom)
            $0.bottom.equalTo(self)
        }
        tableView.delegate = self
        tableView.dataSource = self
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration.

    func configure(with actions: [Action]) {
        subtitleLabel.text = "\(actions.filter({ $0.isCompleted }).count) из \(actions.count) достигнуто"
        self.actions = actions.filter({ !$0.isCompleted})
        tableView.reloadData()
    }
}

extension ActionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tapAction()
    }
}

extension ActionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TargetTableViewCell.reuseID, for: indexPath) as! TargetTableViewCell
        cell.configure(action: actions[indexPath.row])
        cell.delegate = self
        return cell
    }

}

extension ActionView: CheckActionDelegate {
    func check(action: Action) {
        if let index = actions.firstIndex(where: { $0.id == action.id}) {
            actions.remove(at: index)
            tableView.reloadData()
            delegate?.didCompleteAction(action)
        }
        
        ActionManager().completeAction(with: action.wishID, action: action) { (newAction) in }
    }
}

protocol ActionCellDelegate: AnyObject {
    func tapAction()
    func didCompleteAction(_ action: Action)
}
