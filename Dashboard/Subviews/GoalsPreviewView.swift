import UIKit

class GoalsPreviewView: UIView {
    
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
        label.text = "Цели"
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
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(CellWithPhoto.self, forCellReuseIdentifier: CellWithPhoto.reuseID)
        tableView.register(GoalsTableViewCell.self, forCellReuseIdentifier: GoalsTableViewCell.reuseID)

        return tableView
    }()
    
    // MARK: - Properties.
    
    private var goals: [Wish] = []
    private var mainGoal: Wish?
    private var timer: Timer?
    private var scrolledToIndexPath = IndexPath(row: 0, section: 0)
    private var isEndScroll = false

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
            $0.leading.equalTo(self).inset(12)
            $0.trailing.equalTo(self)
            $0.top.equalTo(stackView.snp.bottom).inset(-12)
            $0.bottom.equalTo(self).inset(8)
        }
        
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration.
    
    func configure(with goals: [Wish]) {
        subtitleLabel.text = "\(goals.filter({ $0.isCompleted }).count) из \(goals.count) достигнуто"
                
        self.goals = goals.filter({ !$0.isCompleted})
        self.mainGoal = self.goals.first(where: {$0.isMainTarget})
        self.goals = self.goals.filter({ !$0.isMainTarget})
        
        scrolledToIndexPath = IndexPath(row: 0, section: 0)
        tableView.reloadData()
        
        if self.goals.count > 0 || mainGoal != nil {
            tableView.scrollToRow(at: scrolledToIndexPath, at: .none, animated: false)
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(autoscroll), userInfo: nil, repeats: true)
    }
    
    @objc
    private func autoscroll(_ sender: Timer) {
        guard goals.count > 0 else {
            return
        }

        // Main goal is being shown now and we need to scroll to goals.
        
        if scrolledToIndexPath.section == 0 || (scrolledToIndexPath.section == 1 && scrolledToIndexPath.row == 0) {
            let row = min(2, goals.count - 1)
            let indexPath = IndexPath(row: row, section: 1)
            scroll(to: indexPath)
            return
        }

        // We scrolled to the last of goals and need to scroll back to the main goal if it exists or to the first goal if it doesn't
        
        if scrolledToIndexPath.section == 1 && scrolledToIndexPath.row == goals.count - 1 {
            var section: Int {
                return (mainGoal != nil) ? 0 : 1
            }
            
            let indexPath = IndexPath(row: 0, section: section)
            scroll(to: indexPath)
            return
        }
        
        let currentRow = scrolledToIndexPath.row
        let row = min(currentRow + 3, goals.count - 1)
        let indexPath = IndexPath(row: row, section: 1)
        scroll(to: indexPath)
    }
    
    private func scroll(to indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        scrolledToIndexPath = indexPath
    }
    
}

extension GoalsPreviewView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard mainGoal != nil else {
            return goals.count
        }
        switch section {
        case 0:
            return mainGoal != nil ? 1 : 0
        default:
             return goals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard mainGoal != nil else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellWithPhoto.reuseID, for: indexPath) as! CellWithPhoto
            cell.configure(wish: goals[indexPath.row], .empty)
            return cell
        }
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: GoalsTableViewCell.reuseID, for: indexPath) as! GoalsTableViewCell
            if let mainGoal = mainGoal {
                cell.configure(target: mainGoal)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellWithPhoto.reuseID, for: indexPath) as! CellWithPhoto
            cell.configure(wish: goals[indexPath.row], .empty)
            return cell
        }
    }
}

