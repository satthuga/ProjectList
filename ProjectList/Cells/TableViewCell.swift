//
//  TableViewCell.swift
//  ProjectList
//
//  Created by Apple on 27/10/2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var containView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        setupConstraint()
        contentView.backgroundColor = .white
        containView.backgroundColor = #colorLiteral(red: 0.9528506398, green: 0.9530065656, blue: 0.9528173804, alpha: 1)
        containView.layer.cornerRadius = 15
        projectTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
 
    
    func setupConstraint() {
        self.addSubview(containView)
        containView.addSubview(projectTitleLabel)
        containView.translatesAutoresizingMaskIntoConstraints = false
        projectTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            containView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            containView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            projectTitleLabel.centerYAnchor.constraint(equalTo: containView.centerYAnchor),
            projectTitleLabel.leadingAnchor.constraint(equalTo: containView.leadingAnchor, constant: 20),
            projectTitleLabel.trailingAnchor.constraint(equalTo: containView.trailingAnchor, constant: -10),
        ])
        
        
    }
}
