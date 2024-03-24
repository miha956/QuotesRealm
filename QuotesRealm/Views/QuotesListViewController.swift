//
//  QuotesListViewController.swift
//  QuotesRealm
//
//  Created by Миша Вашкевич on 24.03.2024.
//

import UIKit

class QuotesListViewController: UIViewController {
    
    // MARK: Properties
    var networkManager: NetworkManagerProtocol?
    var realmManager: RealmManagerProtocol?
    var quotes: [Quote] = [] {
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
    let abbQuoteButton = {
        let view = UIButton(type: .system)
        view.setTitle("Add quote", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        view.backgroundColor = .black
        view.addTarget(nil, action: #selector(addQuoteButtonTapped), for: .touchUpInside)
        return view
    }()
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        
        view.addSubview(tableView)
        view.addSubview(abbQuoteButton)
        
        if navigationController != nil {
            abbQuoteButton.isHidden = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            tableView.bottomAnchor.constraint(equalTo: abbQuoteButton.topAnchor).isActive = true
            quotes = realmManager!.fetchAllQuotes()
        }
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
    
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            abbQuoteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            abbQuoteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            abbQuoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            abbQuoteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func addQuoteButtonTapped() {
        networkManager?.fetchData(complition: { error in
            guard let error = error else { return }
            print(error)
        })
        quotes = realmManager!.fetchAllQuotes()
        tableView.reloadData()
    }
}

extension QuotesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = UIListContentConfiguration.cell()
        config.text = quotes[indexPath.row].value
        config.secondaryText = "\(quotes[indexPath.row].createdAt)"
        cell.contentConfiguration = config
        return cell
    }
    
    
}
