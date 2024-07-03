import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import SwiftUI

final class NotificationViewModel {
    // 데이터를 관리하는 PublishSubject
    let notificationItems = PublishSubject<[NotificationItem]>()
}

struct NotificationItem {
    let title: String
    let detail: String?
    let hasSwitch: Bool
}

final class NotificationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = NotificationViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components

    private let headerView = UIView().then {
        $0.backgroundColor = .white
    }

    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "back"), for: .normal)
        $0.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }

    private let titleLabel = UILabel().then {
        $0.text = "알림 설정"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textAlignment = .center
    }
    
    private let rootView = NotificationView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setUI()
        setDelegate()
        setAddTarget()
        
        // 샘플 데이터 설정
        let sampleData = [
            NotificationItem(title: "일기 알림 받기", detail: nil, hasSwitch: true),
            NotificationItem(title: "일기 알림 시간", detail: "오후 10:00", hasSwitch: false),
            NotificationItem(title: "답장 도착 알림 받기", detail: nil, hasSwitch: true)
        ]
        viewModel.notificationItems.onNext(sampleData)
    }
    
    @objc
    private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

private extension NotificationViewController {

    func bindViewModel() {
        viewModel.notificationItems
            .bind(to: rootView.tableView.rx.items(cellIdentifier: "NotificationCell", cellType: NotificationCell.self)) { (row, element, cell) in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }

    func setUI() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        rootView.tableView.snp.remakeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setDelegate() {
        // Delegate 설정 코드 추가
    }
    
    func setAddTarget() {
        // AddTarget 설정 코드 추가
    }
    
    // MARK: - Actions
    
    @objc
    func buttonDidTap() {
        // 버튼 클릭 액션 추가
    }
}

final class NotificationView: UIView {
    
    let tableView = UITableView().then {
        $0.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
        $0.tableFooterView = UIView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

final class NotificationCell: UITableViewCell {
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard Variable", size: 20)
        $0.textColor = .black
    }
    
    private let detailLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard Variable", size: 20)
        $0.textColor = .black
    }
    
    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(named: "arrow")
        $0.contentMode = .scaleAspectFit
    }
    
    private let switchControl = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(switchControl)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints {
            $0.trailing.equalTo(arrowImageView.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        switchControl.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with item: NotificationItem) {
        titleLabel.text = item.title
        if let detail = item.detail {
            detailLabel.text = detail
            detailLabel.isHidden = false
            arrowImageView.isHidden = false
            switchControl.isHidden = true
        } else {
            detailLabel.isHidden = true
            arrowImageView.isHidden = true
            switchControl.isHidden = false
        }
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct NotificationViewController_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            NotificationViewController()
        }
    }
}

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: Context) -> ViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}
#endif
