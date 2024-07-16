//
//  TabbarController.swift
//  Basic UIKIT
//
//  Created by Amilzith on 16/07/24.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.unselectedItemTintColor = .gray
        
        createTabbarControllers()
        overrideUserInterfaceStyle = .light
        tabBar.clipsToBounds = true
        
        
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = false
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    private func createTabbarControllers() {
        let homeVc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let homePage = UINavigationController(rootViewController: homeVc)
        homeVc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        
        let bookmarkVc = UIStoryboard(name: "Bookmark", bundle: nil).instantiateViewController(withIdentifier: "BookmarkViewController") as! BookmarkViewController
        let bookMarkPage = UINavigationController(rootViewController: bookmarkVc)
        bookmarkVc.tabBarItem = UITabBarItem(title: "Bookmark", image: UIImage(systemName: "bookmark"), tag: 2)
        
        let accountVc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        let settingPage = UINavigationController(rootViewController: accountVc)
        accountVc.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "person.crop.circle"), tag: 3)
        
        
        viewControllers = [homePage, bookMarkPage, settingPage]
        selectedIndex = 3
    }
}
