import SwiftUI
import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class AccountManageViewModel {
    
    // Example properties with dummy data
    let isLogoutButtonEnabled = BehaviorRelay<Bool>(value: true)
    
    // Add more properties and methods as needed
}

final class AccountManageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = AccountManageViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
     
    private let rootView = AccountManageView()
    
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "back"), for: .normal)
        $0.tintColor = .black
    }
    
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
        
        // 네비게이션 바에 뒤로 가기 버튼 추가
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Extensions

    private func bindViewModel() {
        // Example binding
        viewModel.isLogoutButtonEnabled
            .bind(to: rootView.logoutButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    private func setUI() {
        view.addSubview(backButton)
                
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
    }
    
    private func setDelegate() {
    }
    
    private func setAddTarget() {
        rootView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        rootView.deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func logoutButtonTapped() {
        // Handle logout action
    }

    @objc
    func deleteAccountButtonTapped() {
        // Handle delete account action
    }
}

// MARK: - View

final class AccountManageView: UIView {

    // MARK: - UI Components
    
    let titleLabel = UILabel().then {
        $0.text = "계정 관리"
        $0.font = UIFont(name: "Inter", size: 25)
        $0.textColor = .black
    }
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let emailLabel = UILabel().then {
        let emailText = "a55751744@gmail.com"
        let attributedString = NSMutableAttributedString(string: emailText)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: emailText.count))
        $0.attributedText = attributedString
        $0.font = UIFont(name: "Inter", size: 15)
        $0.textColor = .black
        $0.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: AccountManageView.self, action: #selector(emailLabelTapped))
        $0.addGestureRecognizer(tapGesture)
    }
    
    let logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(UIColor(red: 0.38, green: 0.39, blue: 0.42, alpha: 1.0), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Inter", size: 15)
    }
    
    let deleteAccountButton = UIButton().then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.setTitleColor(UIColor(red: 0.38, green: 0.39, blue: 0.42, alpha: 1.0), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Inter", size: 15)
    }
    
    let deleteConfirmationLabel = UILabel().then {
        $0.text = "계정을 삭제하시겠어요?"
        $0.font = UIFont(name: "Inter", size: 15)
        $0.textColor = UIColor(red: 0.38, green: 0.39, blue: 0.42, alpha: 1.0)
    }
    
    let separatorLine = UIView().then {
        $0.backgroundColor = UIColor(red: 0.69, green: 0.69, blue: 0.71, alpha: 1.0)
    }
    
    let profileImageView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        $0.layer.cornerRadius = 26.5 // Half of the height and width (53 / 2)
    }


    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setUI() {
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(emailLabel)
        addSubview(logoutButton)
        addSubview(deleteAccountButton)
        addSubview(deleteConfirmationLabel)
        addSubview(separatorLine)
        addSubview(profileImageView)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(34)
            $0.centerX.equalToSuperview().offset(-10)
        }
        
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(102)
            $0.width.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(53)
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(21)
        }
        
        emailLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(20)
        }
        
        logoutButton.snp.makeConstraints {
           $0.centerY.equalTo(profileImageView)
           $0.right.equalToSuperview().offset(-25)
       }
        
        deleteConfirmationLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(45.5)
            $0.left.equalToSuperview().offset(32.5)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.centerY.equalTo(deleteConfirmationLabel)
            $0.right.equalToSuperview().offset(-25)
        }
    }
    
    // MARK: - Actions
    
    @objc private func emailLabelTapped() {
        // Handle email label tap
    }
}

struct AccountManageViewControllerPreview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> AccountManageViewController {
        return AccountManageViewController()
    }
    
    func updateUIViewController(_ uiViewController: AccountManageViewController, context: Context) {
        // Update the view controller if needed
    }
}

#if DEBUG
struct AccountManageViewControllerPreview_Previews: PreviewProvider {
    static var previews: some View {
        AccountManageViewControllerPreview()
            .previewDevice("iPhone 12")
    }
}
#endif
