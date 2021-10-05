import Foundation
import UIKit
import PlaygroundSupport


PlaygroundPage.current.needsIndefiniteExecution = true

class Dynamic<T> {
    typealias Listner = (T) -> Void
    var value : T {
        didSet{
            for listner in listners {
                listner(value)
            }
        }
    }
    var listners: [Listner] = []
    init(_ value:T) {
        self.value = value
    }
    
    func bind(listner: @escaping Listner) -> Void {
        listners.append(listner)
    }
    
}




// MARK: -----------------------------------Example 2-------------------------------------------------------------
// Model
// MARK: - Employee
struct Employees: Decodable, Equatable {
    let status: String
    let data: [EmployeeData]
}

extension Employees {
    static func == (lhs: Self, rhs: Self) -> Bool {
        let lhsEmpData = lhs.status
        let rhsEmpData = rhs.status
        return lhsEmpData == rhsEmpData
    }
}

// MARK: - EmployeeData
struct EmployeeData: Decodable, Equatable  {
    let id, employeeSalary, employeeAge: Int
    let employeeName : String
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


// MARK:- View Model

class MyViewConrollerViewModel {
    private var apiService : APIService!
    var bindViewModelToController: () -> () = {}
    var empData : Employees! {
        didSet{
            self.bindViewModelToController()
        }
    }
    
    init(apiService: APIService) {
        self.apiService = apiService
        self.callGetEmpList()
    }
    
    func callGetEmpList() {
        self.apiService.getEmployee {[weak self] result in
            guard let vm = self else {
                print("VM instance is gone")
                return
            }
            print("got \(result)")
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
    func getEmployee(completion : @escaping (Result<Employees, Error>) -> Void) {
        if let filePath = Bundle.main.path(forResource: "data", ofType: "json") {
            if let content = FileManager.default.contents(atPath: filePath) {
                if let jsonData = try? JSONDecoder().decode(Employees.self, from: content) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        completion(.success(jsonData))
                    }
                    
                }else{
                    completion(.failure(APIErrror.parsingError))
                }
            }else{
                completion(.failure(APIErrror.parsingError))
            }
        }else{
            completion(.failure(APIErrror.networkError))
        }
    }
}



// MARK:- View
// MARK:- View Model

class MyViewControllerDataSource<Cell: UITableViewCell , T> : NSObject , UITableViewDataSource {
    private var items : [T]?
    private var cellIdentifier : String!
    private var configureCell : (Cell, T?)->() = {_,_ in }
    
    init(cellIdentifier : String, items : [T]?, _ configureCell : @escaping (Cell, T?) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = items {
            return items.count
        }
        return 0
    }
           
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! Cell
        self.configureCell(cell,items?[indexPath.row])
        return cell
    }
}


class MyViewController : UIViewController {

    private var viewModel : MyViewConrollerViewModel!
    private var dataSource : MyViewControllerDataSource<UITableViewCell, EmployeeData>!
    private var tableView : UITableView!
            
    func updateDataSoruce() -> Void {
        self.viewModel = MyViewConrollerViewModel.init(apiService: APIService())
        self.viewModel.bindViewModelToController = {
            DispatchQueue.main.async {
                self.dataSource = MyViewControllerDataSource.init(cellIdentifier: "cellId", items: self.viewModel.empData.data) { (cell, employeeData) in
                    cell.textLabel?.text = employeeData?.employeeName
                }
                self.tableView.dataSource = self.dataSource
                self.tableView.reloadData()
            }
        }
    }
        
    override func loadView() {
        self.updateDataSoruce()
        self.tableView = UITableView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        self.view = self.tableView
    }
}


PlaygroundPage.current.liveView = MyViewController.init()
