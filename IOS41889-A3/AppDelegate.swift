//
//  AppDelegate.swift
//  IOS41889-A3
//
//  Created by Zhixu Wan on 2022/5/17.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "IOS41889_A3")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeCustomer(id: Int, nameC: String, nameR: String, phone: String, num: Int, status: String, date: Date) {
        let context = getContext()
        let customer = NSEntityDescription.entity(forEntityName: "Customer", in: context)
        let transfer = NSManagedObject(entity: customer!, insertInto: context)
        
        transfer.setValue(id, forKey: "id")
        transfer.setValue(nameC, forKey: "nameC")
        transfer.setValue(nameR, forKey: "nameR")
        transfer.setValue(phone, forKey: "phone")
        transfer.setValue(num, forKey: "num")
        transfer.setValue(status, forKey: "status")
        transfer.setValue(date, forKey: "date")
        
        saveContext()
    }
    
    func searchCustomer(id: Int) -> Customer {
        var customer : Customer!
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "Customer")
        let predicate = NSPredicate(format: "id = \(id)")
        fetchReq.predicate = predicate
        do {
            let searchResult = try getContext().fetch(fetchReq)
            for trans in searchResult as [NSManagedObject] {
                customer = trans as? Customer
            }
        } catch {
            print("Error with request: \(error)")
        }
        return customer
    }
    
    func listCustomers() -> [Customer] {
        var customers = [Customer]()
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "Customer")
        do {
            let searchResult = try getContext().fetch(fetchReq)
            for trans in searchResult as [NSManagedObject] {
                let customer = trans as! Customer
                customers.append(customer)
            }
        } catch {
            print("Error with request: \(error)")
        }
        return customers
    }
    
    func deleteCustomer(id: Int) {
        let context = getContext()
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
        let predicate = NSPredicate(format: "id = \(id)")
        fetchReq.predicate = predicate
        let deleteReq = NSBatchDeleteRequest(fetchRequest: fetchReq)
        do {
            try context.execute(deleteReq)
            try context.save()
        } catch {
            print("There was an error")
        }
    }
    
    func updateCustomer(id: Int, status: String) {
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "Customer")
        let predicate = NSPredicate(format: "id = \(id)")
        fetchReq.predicate = predicate
        do {
            let searchResult = try getContext().fetch(fetchReq)
            for trans in searchResult as [NSManagedObject] {
                if let customer = trans as? Customer {
                    if customer.id == id {
                        customer.status = status
                    }
                }
            }
        } catch {
            print("Error with request: \(error)")
        }
    }
    
}

