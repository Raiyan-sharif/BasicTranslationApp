//
//  ViewController.swift
//  GenericAPICaller
//
//  Created by BJIT on 30/5/22.
//

import UIKit

//Model
struct User: Codable{
    let name: String
    let email: String
}

struct ToDoListItem: Codable{
    let title: String
    let completed: Bool
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct Constants{
        static let usersUrl = URL(string: "https://jsonplaceholder.typicode.com/users")
        static let todolistUrl = URL(string: "https://jsonplaceholder.typicode.com/todos")
    }
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models: [Codable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        fetchItems()
    }
    
    func fetch(){
        URLSession.shared.request(
            url: Constants.usersUrl,
            expecting: [User].self
        ) {[weak self] result in
            
            switch result{
            case .success(let users):
                DispatchQueue.main.async {
                    self?.models = users
                    self?.table.reloadData()
                }
            
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func fetchItems(){
        URLSession.shared.request(
            url: Constants.todolistUrl,
            expecting: [ToDoListItem].self
        ) {[weak self] result in
            
            switch result{
            case .success(let toDoList):
                DispatchQueue.main.async {
                    self?.models = toDoList
                    self?.table.reloadData()
                }
            
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = (models[indexPath.row] as? User)?.name
        cell.textLabel?.text = (models[indexPath.row] as? ToDoListItem)?.title
        if let item = models[indexPath.row] as? ToDoListItem{
            cell.accessoryType = item.completed ? .checkmark : .none
        }
        return cell
    }


}

extension URLSession{
    enum CustomError: Error{
        case invalidUrl
        case invalidData
    }
    func request<T: Codable>(
        url: URL?,
        expecting: T.Type,
        complition: @escaping (Result<T, Error>) -> Void
    ){
        guard let url = url else{
            complition(.failure(CustomError.invalidUrl))
            return
        }
        let task = dataTask(with: url) { data, _, error in
            guard let data = data else{
                if let error = error{
                    complition(.failure(error))
                }else{
                    complition(.failure(CustomError.invalidData))
                }
                return
            }
            
            do{
                let result = try JSONDecoder().decode(expecting, from: data)
                complition(.success(result))
            }
            catch{
                complition(.failure(error))
            }
        }
        
        
        task.resume()
    }
}
