//
//  TableViewCell.swift
//  GithubGraphQL
//
//  Created by Râmede on 10/05/22.
//  Copyright © 2022 test. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    private var nameLabel = UILabel()
    private var bookImage = UIImageView()
    
    // MARK: - Internal Properties
    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

}

// MARK: - Private Constants
private extension TableViewCell {

    enum Constants {
        enum BookImage {
            static let top: CGFloat = 16
            static let leading: CGFloat = 16
            static let width: CGFloat = 25
            static let height: CGFloat = 25
        }

        enum NameLabel {
            static let leading: CGFloat = 16
            static let trailing: CGFloat = -16
        }
    }
    
    enum Font {
        enum Label {
            static let regular = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
    
}

// MARK: - Private Implementation
private extension TableViewCell {
    
    func setup() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupBookImage()
        setupNameLabel()
        setupHierarchy()
        setupConstraints()
    }

    func setupBookImage() {
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        bookImage.contentMode = .scaleAspectFit
        bookImage.image = UIImage(named: "BookImage")
    }

    func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Font.Label.regular)
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.textColor = .black

        nameLabel.text = "Free WipesFree WipesFree WipesFree WipesFree WipesFree Wipes"
    }
    
    func setupHierarchy() {
        contentView.addSubview(bookImage)
        contentView.addSubview(nameLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bookImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.BookImage.top),
            bookImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.BookImage.leading),
            bookImage.widthAnchor.constraint(equalToConstant: Constants.BookImage.width),
            bookImage.heightAnchor.constraint(equalToConstant: Constants.BookImage.height),

            
            nameLabel.topAnchor.constraint(equalTo: bookImage.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: Constants.NameLabel.leading),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.NameLabel.trailing)
        ])
    }
}
