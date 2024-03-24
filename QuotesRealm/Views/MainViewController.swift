//
//  ViewController.swift
//  QuotesRealm
//
//  Created by Миша Вашкевич on 24.03.2024.
//

import UIKit

class MainViewController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        
        self.tabBar.tintColor = .black
        let realmManager = RealmManager()
        let networkManager = NetworkManager()
        networkManager.realmManager = realmManager
        let quotesView = QuotesListViewController()
        quotesView.networkManager = networkManager
        quotesView.realmManager = realmManager
        let categoriesView = CategoriesTableViewController()
        categoriesView.realmManager = realmManager
        let navigationControllercategoriesView = UINavigationController(rootViewController: categoriesView)
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white
        navigationControllercategoriesView.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationControllercategoriesView.navigationBar.standardAppearance = navBarAppearance
        navigationControllercategoriesView.navigationBar.compactAppearance = navBarAppearance
        navigationControllercategoriesView.navigationBar.compactScrollEdgeAppearance = navBarAppearance
        navigationControllercategoriesView.navigationBar.prefersLargeTitles = true
            
        self.viewControllers = [
            setVC(
                viewController: quotesView,
                title: "All quotes",
                image: UIImage(systemName: "quote.bubble")),
            setVC(
                viewController: navigationControllercategoriesView,
                title: "Quot's categories",
                image: UIImage(systemName: "list.bullet"))
        ]
    }
    
    private func setVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
            viewController.tabBarItem.title = title
            viewController.tabBarItem.image = image
            return viewController
    }
}


