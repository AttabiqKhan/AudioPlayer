//
//  ViewController.swift
//  Audio Player
//
//  Created by Attabiq Khan on 08/10/2024.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    private let titleLabel = Label(
        text: "Tap on any option to play relevant audio",
        textAlignment: .center,
        textColor: .textPrimary
    )
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: OptionsTableViewCell.tableViewIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.tintColor = .clear
        return tableView
    }()
    private let options: [Options] = [
        .init(title: "Nature"),
        .init(title: "Bird"),
        .init(title: "Water"),
        .init(title: "City"),
        .init(title: "Forest"),
        .init(title: "Garden")
    ]
    
    // MARK: - Overriden Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Functions
    private func setupUI() {
        view.addGradient(colors: [.secondary, .midGradient, .background], locations: [0.0, 0.6, 1.0])
        view.backgroundColor = .background
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.autoSized),
            titleLabel.heightAnchor.constraint(equalToConstant: 50.autoSized),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.widthRatio),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.widthRatio),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.autoSized),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.autoSized),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.widthRatio),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.widthRatio),
        ])
    }
}

// MARK: - TableView Delegate & DataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableViewCell.tableViewIdentifier, for: indexPath) as! OptionsTableViewCell
        cell.options = options[indexPath.row]
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.primary.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowRadius = 4
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let audioViewController = AudioPlayViewController()
        let selectedOption = options[indexPath.row]
        audioViewController.audioFileName = selectedOption.title.lowercased()
        navigationController?.pushViewController(audioViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.autoSized
    }
}
