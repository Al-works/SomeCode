import UIKit

class CollectionViewCell<CustomView>: UICollectionViewCell where CustomView: UIView {
    
    // MARK: - UI Properties.
    
    let customView = CustomView()
    
    // MARK: - Initialization.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = false
        
        addSubview(customView)
        customView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle.
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customView.prepareForReuse()
    }
    
}
