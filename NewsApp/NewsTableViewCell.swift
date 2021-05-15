//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Sree Sai Raghava Dandu on 13/05/21.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data?
    
    init(
        title: String,
        subtitle: String,
        imageURL: URL?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"
    
    // NewsTitle
    private let newsTitleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    // News Subtitle
    private let subtitleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    // Image View

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Add all the subviews to ContentView
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTitleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 170,
            height: 70)
        subtitleLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height/2)
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 150,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    //Configure each cell with a view Model
    func configure(with viewModel: NewsTableViewCellViewModel){
        //Configure all the data here
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        //Image
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL{
            //Fetch image
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }

}
