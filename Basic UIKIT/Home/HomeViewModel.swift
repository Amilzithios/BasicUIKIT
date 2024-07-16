//
//  HomeViewModel.swift
//  Basic UIKIT
//
//  Created by Amilzith on 16/07/24.
//

import UIKit
import CoreData

class HomeViewModel: NSObject {
    var post = [Post]()
    var onDataFetched: (() -> Void)?
    
    func getData() {
        Task {
            do {
                let data = try await fetchData()
                let singleData = try await fetchSingleData()
                self.post = data
                self.saveDataToCoreData(posts: data)
                self.onDataFetched?()
            } catch {
                print("Error fetching data:", error)
            }
        }
    }
    
    func fetchData() async throws -> [Post] {
        let apiUrlString = "https://jsonplaceholder.typicode.com/posts"
        
        guard let url = URL(string: apiUrlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let posts = try JSONDecoder().decode([Post].self, from: data)
        return posts
    }
    
    func fetchSingleData() async throws -> Post {
        let apiUrlString = "https://jsonplaceholder.typicode.com/posts/1"
        
        guard let url = URL(string: apiUrlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let post = try JSONDecoder().decode(Post.self, from: data)
        return post
    }
    
    func saveDataToCoreData(posts: [Post]) {
        let context = Databasehandler.shared.persistentContainer.viewContext
        
//        // Clear existing data
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SampleEntity")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        do {
//            try context.execute(deleteRequest)
//        } catch {
//            print("Error deleting existing data:", error)
//        }
        
        // Save new data
        for post in posts {
            let postEntity = HomeDataEntity(context: context)
            postEntity.userId = Int64(post.userId)
            postEntity.id = Int64(post.userId)
            postEntity.title = post.title
            postEntity.body = post.body
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving data to Core Data:", error)
        }
    }
}
