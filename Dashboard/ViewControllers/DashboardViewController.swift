import UIKit

class DashboardViewController: UIViewController {

    // MARK: - UI Properties.

    private let ui = DashboardView()

    // MARK: - Properties.

    private var targets = Wish.isTarget
    private var actions: [Action] = Action.current.sorted
    let countCellTargetVisible: CGFloat = 3.0
    let countCellActionVisible: CGFloat = 8.0

    // MARK: - Initialization.

    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        ui.collectionView.delegate = self
        ui.mainBottomView.profileButton.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        ui.mainBottomView.playButton.addTarget(self, action: #selector(openMeditation), for: .touchUpInside)
        ui.noInternetEmptyCashView.sendButton.addTarget(self, action: #selector(loadData), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(profileDidChange), name: NSNotification.Name("profileDidChange"), object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle.

    override func loadView() {
        view = ui
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true

         NotificationCenter.default.addObserver(self, selector: #selector(showInternalServerError), name: Notification.Name("internalServerError"), object: nil)

        loadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ui.collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: NSNotification.Name("MeditationDismiss"), object: nil)
    }

    // MARK: - Notifications.
    
    @objc
    private func profileDidChange() {
        ui.collectionView.reloadData()
    }
    
    // MARK: - User Interaction.

    @objc
    private func loadData() {
        WishManager().fetchWishes { [weak self] (_) in
            self?.targets = Wish.isTarget
            self?.ui.collectionView.reloadData()
        }

        ProfileManager()?.fetchCurrent(then: { [weak self] (profile) in
            self?.ui.collectionView.reloadData()
        })

        EmotionsManager().fetch { (_) in
            self.ui.collectionView.reloadData()
        }

        MeritsManager().fetch { (_) in
            self.ui.collectionView.reloadData()
        }

        ActionManager().fetch { (_) in
            self.actions = Action.current.sorted
            self.ui.collectionView.reloadData()
        }
    }

    private func checkEmty() {
        if Wish.current.isEmpty || Merit.current.isEmpty || Emotion.current.isEmpty {
            ui.noInternetEmptyCashView.isHidden = false
            ui.collectionView.isHidden = true
        } else {
            ui.noInternetEmptyCashView.isHidden = true
            ui.collectionView.isHidden = false
        }
    }

    @objc
    private func showInternalServerError() {
        if Wish.current.isEmpty || Merit.current.isEmpty || Emotion.current.isEmpty {
            ui.noInternetEmptyCashView.isHidden = false
            ui.collectionView.isHidden = true
        } else {
            if let navigationController = navigationController {
                if !navigationController.viewControllers.contains(where: { $0.isKind(of: SmallNotificationViewController.self)}) {
                    showSmallNotification(style:.error)
                }
            }
        }
    }

    @objc
    private func updateProfile() {
        ProfileManager()?.fetchCurrent(then: { [weak self] (profile) in
            self?.ui.collectionView.reloadData()
        })
    }

    @objc
    private func openProfile(_ sender: UIButton) {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: false)
    }

    @objc
    private func openMeditation(_ sender: UIButton) {
        let vc = MeditationListViewController()
        if #available(iOS 13.0, *) {
            vc.modalPresentationStyle = .automatic
        }
        let nc = NavigationController(rootViewController: vc, configuration: .default)
        present(nc, animated: true, completion: nil)
    }

}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var goals = targets.filter({ !$0.isCompleted})
        
        guard
            let mainGoal = goals.first(where: {$0.isMainTarget}),
            indexPath.section == 0
            else {
                goals = goals.filter({ !$0.isMainTarget})
                let vc = AddGoalViewController(wish: goals[indexPath.row], state: .edit)
                navigationController?.pushViewController(vc, animated: true)
                return
        }
        let vc = AddGoalViewController(wish: mainGoal, state: .edit)
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard Wish.isTarget.filter({!$0.isCompleted}).first(where: {$0.isMainTarget}) != nil  else {
            return 56
        }
        switch indexPath.section {
        case 0:
            return 168
        default:
            return 56
        }
    }
}

extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)!

        switch section {
        case .profile:
            break
        case .target:
            let vc = GoalsViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .action:
            let vc = ActionsViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .some:
            let type = MainCVCell.TypeCell(rawValue: indexPath.row)!

            switch type {
            case .wishes:
                let vc = WishesListViewController()
                navigationController?.pushViewController(vc, animated: true)
            case .statistic:
                let vc = ProfileViewController()
                navigationController?.pushViewController(vc, animated: false)
            case .merits:
                let vc = EmotionsMeritsViewController(type: .merits)
                navigationController?.pushViewController(vc, animated: true)
            case .emotions:
                let vc = EmotionsMeritsViewController(type: .emotions)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension DashboardViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = Section(rawValue: section)!

        switch section {
        case .profile:
            return 1
        case .some:
            return 4
        case .target:
            return 1
        case .action:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!

        switch section {
        case .profile:
            let cell = collectionView.dequeueCell(withReusableView: ProfileInMainView.self, forIndexPath: indexPath)
            cell.customView.configure()
            return cell
        case .some:
            let type = MainCVCell.TypeCell(rawValue: indexPath.row)!
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCVCell.reuseID, for: indexPath) as! MainCVCell
            cell.configure(with: type)
            return cell
        case .target:
            let cell = collectionView.dequeueCell(withReusableView: GoalsPreviewView.self, forIndexPath: indexPath)
            cell.customView.tableView.delegate = self
            cell.customView.configure(with: targets)
            return cell
        case .action:
            let cell = collectionView.dequeueCell(withReusableView: ActionView.self, forIndexPath: indexPath)
            cell.customView.configure(with: actions)
            cell.customView.delegate = self
            return cell
        }
    }
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.size
        let section = Section(rawValue: indexPath.section)!

        switch section {
        case .profile:
            return CGSize(width: size.width - 32, height: 60.0)
        case .some:
            return CGSize(width: ((size.width - 48) / 2), height: 128)
        case .target:
            return CGSize(width: size.width - 32, height: 57 + 58 * countCellTargetVisible)
        case .action:
            return CGSize(width: size.width - 32, height: 48 + 44 * countCellActionVisible)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = Section(rawValue: section)!

        switch section {
        case .profile:
            return UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16)
        case .some:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        case .target:
            return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        case .action:
            return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        }
    }
}

extension DashboardViewController: ActionCellDelegate {
    func tapAction() {
        let vc = ActionsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didCompleteAction(_ action: Action) {
        actions.removeAll(where: { $0.id == action.id })
    }
}

extension DashboardViewController {
    enum Section: Int {
        case profile
        case some
        case target
        case action
    }
}
