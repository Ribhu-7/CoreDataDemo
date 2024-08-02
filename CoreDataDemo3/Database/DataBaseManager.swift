//
//  DataBaseManager.swift
//  CoreDataDemo3
//
//  Created by Apple on 01/08/24.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager{
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    func addUser(_ user: UserModel){
        let userEntity = UserEntity(context: context) //creating new user
       addUpdateUser(userEntity: userEntity, user: user)
    }
    
    func updateUser(user: UserModel , userEntity: UserEntity){
        addUpdateUser(userEntity: userEntity, user: user)
        
    }
    
    private func addUpdateUser(userEntity: UserEntity, user: UserModel){
        userEntity.firstname = user.firstName
        userEntity.lastname = user.lastName
        userEntity.emailID = user.email
        userEntity.password = user.password
        userEntity.imageName = user.imageName
        saveContext()
    }
    
    func fetchUsers() -> [UserEntity]{
        var users: [UserEntity] = []
        
        do{
            users = try context.fetch(UserEntity.fetchRequest())
        } catch {
            print("Error")
        }
        return users
    }
    
    func deleteUser(_ userEntity: UserEntity){
        let imageURL = URL.documentsDirectory.appending(components: userEntity.imageName ?? "").appendingPathExtension("png")
        do{
            try FileManager.default.removeItem(at: imageURL)
        } catch{
            print("Image deletion error")
        }
        context.delete(userEntity)
        saveContext()
    }
    
    func saveContext(){
        do {
            try context.save()
        } catch {
            print("User saving error", error)
        }
    }
}
