//
//  ViewController.swift
//  Basic UIKIT
//
//  Created by Amilzith on 16/07/24.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlet Declarations
    @IBOutlet var tableView: UITableView!
    
    let viewModel = HomeViewModel()
    var postData = [HomeDataEntity]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.viewModel.getData()
        viewModel.onDataFetched = { [weak self] in
            self?.loadDataFromCoreData()
        }
        tableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        self.title = "Home"

    }
    
    func loadDataFromCoreData() {
        let context = Databasehandler.shared.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<HomeDataEntity> = HomeDataEntity.fetchRequest()
        
        do {
            self.postData = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching data from Core Data:", error)
        }
    }
    
    @IBAction func addNewObj(_ action: UIButton) {
        let context = Databasehandler.shared.persistentContainer.viewContext
        
        let newPost = HomeDataEntity(context: context)
        newPost.userId = 1
        newPost.id = (postData.last?.id ?? 0) + 1
        newPost.title = "New Post Title"
        newPost.body = "New Post Body"
        
        do {
            try context.save()
            self.postData.append(newPost)
            self.tableView.reloadData()
        } catch {
            print("Error saving new object to Core Data:", error)
        }
        tableView.reloadData()
    }
    
    @IBAction func removeAll(_ action: UIButton) {
        // Example: Removing all objects from Core Data
        
        let context = Databasehandler.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<HomeDataEntity> = HomeDataEntity.fetchRequest()
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            try context.save()
            self.postData.removeAll()
            self.tableView.reloadData()
        } catch {
            print("Error removing all objects from Core Data:", error)
        }
        tableView.reloadData()
    }
    
    @IBAction func removeSpecifObj(_ action: UIButton) {
        // Example: Removing a specific object from Core Data
        guard !postData.isEmpty else { return }
        let objectToDelete = postData.first!
        let context = Databasehandler.shared.persistentContainer.viewContext
        context.delete(objectToDelete)
        
        do {
            try context.save()
            self.postData.remove(at: 0)
        } catch {
            print("Error removing specific object from Core Data:", error)
        }
        tableView.reloadData()
    }
    
    @objc func deleteObjc(_ sender: UIButton) {
//        let postToDelete = postData[sender.tag]
//        let context = Databasehandler.shared.persistentContainer.viewContext
//        context.delete(postToDelete)
//        
//        do {
//            try context.save()
//            self.postData.remove(at: sender.tag)
//        } catch {
//            print("Error deleting data from Core Data:", error)
//        }
        
        Databasehandler.shared.deleteObject(withId: postData[sender.tag].id) { success in
            if success {
                DispatchQueue.main.async {
                    self.loadDataFromCoreData()
                }
            } else {
                print("Failed to delete object with id:", self.postData[sender.tag].id)
            }
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let post = postData[indexPath.row]
        cell.titleTextLabel.text = post.title
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteObjc(_ :)), for: .touchDown)
        
        return cell
    }
}
