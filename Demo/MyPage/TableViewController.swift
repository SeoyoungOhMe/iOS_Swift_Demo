import SwiftUI
import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
final class TableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Data Source
    
    private let items: [(text: String, detail: String?)] = [
        ("알림 설정", nil),
        ("공지사항", nil),
        ("1:1 문의하기", nil),
        ("계정 관리", nil),
        ("앱 버전", "최신 버전")
    ]
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        setupTableViewHeader()
    }
    
    // MARK: - TableView Header
    
    private func setupTableViewHeader() {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.frame.size.height = 150
        
        let labelNickname = UILabel().then {
            $0.text = "닉네임"
            $0.font = UIFont(name: "Inter", size: 20)
            $0.textColor = UIColor(red: 0.38, green: 0.39, blue: 0.42, alpha: 1.0)
        }
        
        let label000 = UILabel().then {
            $0.text = "000"
            $0.font = UIFont(name: "Pretendard Variable", size: 20)
            $0.textColor = .black
        }
        
        let pencilImageView = UIImageView().then {
            $0.image = UIImage(named: "ph_pencil-thin")
        }
        
        let separatorLine = UIView().then {
            $0.backgroundColor = UIColor.lightGray
        }
        
        
        headerView.addSubview(labelNickname)
        headerView.addSubview(label000)
        headerView.addSubview(pencilImageView)
        headerView.addSubview(separatorLine)
        
        labelNickname.snp.makeConstraints {
            $0.top.equalToSuperview().offset(62)
            $0.leading.equalToSuperview().offset(59)
        }

        label000.snp.makeConstraints {
            $0.top.equalTo(labelNickname.snp.bottom).offset(7)
            $0.leading.equalToSuperview().offset(54)
        }
        
        pencilImageView.snp.makeConstraints {
            $0.centerY.equalTo(label000)
            $0.leading.equalTo(label000.snp.trailing).offset(20)
            $0.width.height.equalTo(24)
        }
        
        separatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(label000.snp.bottom).offset(20)
            $0.height.equalTo(1)
        }
        
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.text

        if item.text == "앱 버전" {
            let latestVersionLabel = UILabel().then {
                $0.text = "최신 버전"
                $0.font = UIFont(name: "Pretendard Variable", size: 20)
                $0.textColor = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1.0)
            }

            cell.contentView.addSubview(latestVersionLabel)
            latestVersionLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().offset(-15)
            }
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
}



// PreviewProvider 추가
struct TableViewController_Previews: PreviewProvider {
    static var previews: some View {
        TableViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all) // 전체 화면 미리보기
            .previewDevice(PreviewDevice(rawValue: "iPhone 17")) // 원하는 디바이스로 미리보기
    }
}

struct TableViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TableViewController {
        return TableViewController()
    }
    
    func updateUIViewController(_ uiViewController: TableViewController, context: Context) {
        // 필요시 업데이트 코드 추가
    }
}
