import UIKit

class DashboardView: BackgroundView {

    // MARK: - UI Properties.

    let collectionView: UICollectionView = {

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .flowLayout(direction: .vertical))
        collectionView.alwaysBounceVertical = true
        collectionView.register(cellWithReusableView: ProfileInMainView.self)
        collectionView.register(cellWithReusableView: ActionView.self)
        collectionView.register(cellWithReusableView: GoalsPreviewView.self)
        collectionView.register(MainCVCell.self, forCellWithReuseIdentifier: MainCVCell.reuseID)
        collectionView.backgroundColor = UIColor.clear

        return collectionView
    }()

    let mainBottomView: MainBottomView = {
        let mainBottomView = MainBottomView()
        mainBottomView.homeButton.setImage(UIImage(named: "icon_home_white"), for: .normal)
        mainBottomView.profileButton.setImage(UIImage(named: "icon_profile_gray"), for: .normal)
        return mainBottomView
    }()

    let noInternetEmptyCashView = NoInternetEmptyCashView()

    // MARK: - Initialization.

    init() {
        super.init(frame: .zero)
        backgroundColor = .background(.regular)

        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(self)
            $0.trailing.equalTo(self)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self).inset(84)
        }

        addSubview(mainBottomView)
        mainBottomView.snp.makeConstraints {
            $0.leading.equalTo(self)
            $0.trailing.equalTo(self)
            $0.bottom.equalTo(self)
            $0.height.equalTo(84)
        }

        addSubview(noInternetEmptyCashView)
        noInternetEmptyCashView.snp.makeConstraints {
            $0.leading.equalTo(self)
            $0.trailing.equalTo(self)
            $0.top.equalTo(self)
            $0.bottom.equalTo(self).inset(114)
        }
        noInternetEmptyCashView.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
