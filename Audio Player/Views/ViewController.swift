//
//  ViewController.swift
//  Audio Player
//
//  Created by Attabiq Khan on 08/10/2024.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    private let titleLabel = Label(text: "Tap on any option to play relevant audio", textAlignment: .center)
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: OptionsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    private let options: [Options] = [.init(title: "Nature"), .init(title: "Bird"), .init(title: "Water"), .init(title: "City"), .init(title: "Forest")]
    
    // MARK: - Overriden Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Functions
    private func setupUI() {
        view.backgroundColor = .systemGray4
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
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableViewCell.identifier, for: indexPath) as! OptionsTableViewCell
        cell.options = options[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let audioViewController = AudioPlayViewController()
        
        switch options[indexPath.row].title {
        case "Nature":
            audioViewController.audioFileName = "nature"
        case "Bird":
            audioViewController.audioFileName = "bird"
        case "Water":
            audioViewController.audioFileName = "flowing_water"
        case "City":
            audioViewController.audioFileName = "city_at_night"
        case "Forest":
            audioViewController.audioFileName = "forest"
        default:
            break
        }
        navigationController?.pushViewController(audioViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
