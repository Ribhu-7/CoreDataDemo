//
//  UserListViewController.swift
//  CoreDataDemo3
//
//  Created by Apple on 01/08/24.
//

import UIKit

class UserListViewController: UIViewController {

   
    @IBOutlet weak var userTBlView: UITableView!
    private var users: [UserEntity] = []
    private let manager = DatabaseManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "UserCellTableViewCell", bundle: nil)
        userTBlView.register(nib, forCellReuseIdentifier: "UserCellTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users = manager.fetchUsers()
        self.userTBlView.reloadData()
    }

    @IBAction func addBtnClick(_ sender: UIBarButtonItem) {
        addUpdateUserConfiguration()
    }
    
    func addUpdateUserConfiguration(user: UserEntity? = nil){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = sb.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
        registerVC.user = user
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
}

extension UserListViewController: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCellTableViewCell") as? UserCellTableViewCell else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]

        cell.user = user
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(style: .normal, title: "Update"){
            _,_,_ in
            self.addUpdateUserConfiguration(user: self.users[indexPath.row])
        }
        let delete = UIContextualAction(style: .normal, title: "Delete"){
            _,_,_ in
            self.manager.deleteUser(self.users[indexPath.row]) //core data
            self.users.remove(at: indexPath.row) //array
            self.userTBlView.reloadData()
        }
        update.backgroundColor = .systemIndigo
        return UISwipeActionsConfiguration(actions: [update,delete])
    }
}
