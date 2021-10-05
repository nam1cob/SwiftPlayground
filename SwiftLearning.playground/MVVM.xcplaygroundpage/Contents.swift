import Foundation
import UIKit
import PlaygroundSupport


PlaygroundPage.current.needsIndefiniteExecution = true


// View
// View Model
class MyViewConroller : UIViewController, UITableViewDataSource {

    private var viewModel : MyViewConrollerViewModel!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    init(viewModel: MyViewConrollerViewModel) {
        self.viewModel = MyViewConrollerViewModel(apiService: APIService())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellId1") {
            cell.textLabel?.text = "someText"
            return cell
        }
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cellId1")
        cell.textLabel?.text = "someText"
        return cell
    }
    
    override func loadView() {
        let view = UITableView()
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cellId1")
        self.view = view
    }
}


PlaygroundPage.current.liveView = MyViewConroller.init(viewModel: MyViewConrollerViewModel())


// View Model

class MyViewConrollerViewModel {
    private var apiService : APIService!
    private var bindViewModelToController: () -> () = {}
    private var empData : Employees! {
        didSet{
            self.bindViewModelToController()
        }
    }
    
    init(apiService: APIService) {
        self.apiService = apiService
        self .callGetEmpList()
    }
    
    func callGetEmpList() {
        self.apiService.getEmployee {[weak self] result in
            guard let vm = self else {
                print("VM instance is gone")
                return
            }
            switch result {
                case .success(let data):
                    vm.empData = data
                case .failure(let error):
                    print("Logging Error \(error)")
            }
        }
    }
}

enum APIErrror : Error {
    case networkError, parsingError
}


class APIService {
    
    private let url = URL(string: "http://dummy.restapiexample.com/api/v1/employees")!

    
    func getEmployee(completion : @escaping (Result<Employees, Error>) -> Void) {
        
//        let filePath= Bundle.main.path(forResource: "data", ofType: "json")
//        let content = FileManager.default.contents(atPath: filePath)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error != nil else {
                completion(.failure(APIErrror.networkError))
                return
            }
            
            guard let data = data,
                  let jsonData = try? JSONDecoder().decode(Employees.self, from: data) else{
                completion(.failure(APIErrror.parsingError))
                return
            }
            
            completion(.success(jsonData))
        }
    }
}


// Model

// MARK: - Employee
struct Employees: Decodable, Equatable {
    let status: String
    let data: [EmployeeData]
}

extension Employees {
    static func == (lhs: Self, rhs: Self) -> Bool {
        let lhsEmpData = lhs.data
        let rhsEmpData = rhs.data
        return lhsEmpData == rhsEmpData
    }
}

// MARK: - EmployeeData
struct EmployeeData: Decodable, Equatable  {
    let id, employeeName, employeeSalary, employeeAge: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case id
        case employeeName = "employee_name"
        case employeeSalary = "employee_salary"
        case employeeAge = "employee_age"
        case profileImage = "profile_image"
    }
}

extension  EmployeeData{
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

