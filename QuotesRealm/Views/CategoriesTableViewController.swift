//
//  CategoriesTableViewController.swift
//  QuotesRealm
//
//  Created by Миша Вашкевич on 24.03.2024.
//

import UIKit

class CategoriesTableViewController: UIViewController {
    
    // MARK: Properties
    var realmManager: RealmManagerProtocol?
    var catigoties: [Category] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: SubViews
    
    let tableView: UITableView = {
       let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catigoties = realmManager!.fetchQuotesByCatigory()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        catigoties = realmManager!.fetchQuotesByCatigory()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}


extension CategoriesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        catigoties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = UIListContentConfiguration.cell()
        config.text = catigoties[indexPath.row].name
        config.secondaryText = "Quotes numder: \(catigoties[indexPath.row].quotes.count)"
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = QuotesListViewController()
        let quotes = Array(catigoties[indexPath.row].quotes)
        vc.quotes = quotes
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
