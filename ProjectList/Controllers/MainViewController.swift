//
//  MainViewController.swift
//  ProjectList
//
//  Created by Apple on 27/10/2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var addProjectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        fetch()
        setupConstraints()
        setupElements()
        
        addProjectButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    // MARK: - Constraints,Elements
    func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(addProjectButton)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        addProjectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height*0.05),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // tableView
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: 20),
            
            // footerView
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            // Add Button
            addProjectButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            addProjectButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20),
            addProjectButton.heightAnchor.constraint(equalTo: footerView.heightAnchor, multiplier: 0.4),
            addProjectButton.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.8)
        ])
    }
   
    func setupElements() {
        // Title
        titleLabel.text = "Projects"
        Utilities.styleTitleLabel(titleLabel)
        
        // tableView
        let tableFooterView = UIView()
        tableFooterView.frame.size.height = 1
        tableView.tableFooterView = tableFooterView
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        // footerView
        footerView.backgroundColor = #colorLiteral(red: 0.9802990556, green: 0.9804593921, blue: 0.9802649617, alpha: 1)
        
        addProjectButton.setTitle("Add Project", for: .normal)
        Utilities.styleFilledButton(addProjectButton)
    }

    // MARK: -fetch data from server
    func fetch() {
            
        let urlString = "https://tapuniverse.com/xproject"

            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    parse(json: data)
                }
            }
    }
    
    // parse Json
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonProjects = try? decoder.decode(Projects.self, from: json) {
            projects = jsonProjects.projects
            tableView.reloadData()
        }
    }
    
    // add new project
    @objc func didTapButton (){
        let alert = UIAlertController(title: "Add new project", message: nil , preferredStyle: .alert)
        
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 18
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            guard let textfield = alert.textFields else { return }
            guard let text = textfield[0].text else { return }
            
            if text != "" {
                let newProject = Project(id: 100+projects.count, name: text)
                projects.append(newProject)
                self.tableView.reloadData()
            } else {
                return
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
        }))
        
        self.present(alert, animated: true)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        cell.projectTitleLabel.text = projects[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
              // delete project
            completionHandler(true)
            }
        
        delete.image = UIImage(named: "check")
        delete.backgroundColor = .white
        
        let swipe = UISwipeActionsConfiguration(actions: [delete])
            return swipe
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsVC = DetailsViewController()
        detailsVC.id = projects[indexPath.row].id
        detailsVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(detailsVC, animated: true, completion: nil)
    }
}
