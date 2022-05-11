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
    private var descriptionLabel = UILabel()
    private var starImage = UIImageView()
    private var starsLabel = UILabel()

    // MARK: - Internal Properties
    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }

    var repositoryDescription: String = "" {
        didSet {
            descriptionLabel.text = repositoryDescription
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
            static let width: CGFloat = 15
            static let height: CGFloat = 15
        }

        enum NameLabel {
            static let top: CGFloat = 13
            static let leading: CGFloat = 12
            static let trailing: CGFloat = -16
        }
        
        enum DescriptionLabel {
            static let top: CGFloat = 8
            static let leading: CGFloat = 16
            static let trailing: CGFloat = -16
        }
        
        enum StarImage {
            static let top: CGFloat = 8
            static let bottom: CGFloat = -16
            static let width: CGFloat = 15
            static let height: CGFloat = 15
        }
        
        enum StarsLabel {
            static let top: CGFloat = 8
            static let leading: CGFloat = 12
            static let trailing: CGFloat = -16
            static let bottom: CGFloat = -16
        }
    }
    
    enum Font {
        enum Label {
            static let regular = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let bold = UIFont.systemFont(ofSize: 14, weight: .bold)
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
        setupDescriptionLabel()
        setupStarImage()
        setupStarsLabel()
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
        nameLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Font.Label.bold)
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.textColor = .systemBlue

        nameLabel.text = "graphql-go/graphql"
    }

    func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Font.Label.regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.textColor = .black

        descriptionLabel.text = "GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation GraphQL Java implementation"
    }
    
    func setupStarImage() {
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.contentMode = .scaleAspectFit
        starImage.image = UIImage(named: "Star")
    }

    func setupStarsLabel() {
        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        starsLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: Font.Label.regular)
        starsLabel.numberOfLines = 1
        starsLabel.lineBreakMode = .byTruncatingTail
        starsLabel.textColor = .black

        starsLabel.text = "5.5k"
    }

    func setupHierarchy() {
        contentView.addSubview(bookImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(starImage)
        contentView.addSubview(starsLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bookImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.BookImage.top),
            bookImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.BookImage.leading),
            bookImage.widthAnchor.constraint(equalToConstant: Constants.BookImage.width),
            bookImage.heightAnchor.constraint(equalToConstant: Constants.BookImage.height),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.NameLabel.top),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.NameLabel.trailing),
            nameLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: Constants.NameLabel.leading),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.DescriptionLabel.top),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.DescriptionLabel.trailing),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.DescriptionLabel.leading),
            
            starImage.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.StarImage.top),
            starImage.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            starImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.StarImage.bottom),
            starImage.widthAnchor.constraint(equalToConstant: Constants.StarImage.width),
            starImage.heightAnchor.constraint(equalToConstant: Constants.StarImage.height),
            
            starsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.StarsLabel.top),
            starsLabel.leadingAnchor.constraint(equalTo: starImage.trailingAnchor, constant: Constants.StarsLabel.leading),
            starsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.StarsLabel.trailing),
            starsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.StarsLabel.bottom)
        ])
    }
}
