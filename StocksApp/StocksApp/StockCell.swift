//
//  StockCell.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 24.05.2022.
//

import UIKit



final class StockCell: UITableViewCell {
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "YNDX")
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.text = "YNDX"
        label.font = UIFont.Bold(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var isFavoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Fav")
        return imageView
    }()
    
    private lazy var companyNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Yandex, LLC"
        label.font = UIFont.SemiBold(size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "4 764,6 ₽"
        label.font = UIFont.Bold(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
  
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.text = "+55 ₽ (1,15%)"
        label.font = UIFont.SemiBold(size: 12)
        label.textColor = UIColor(red: 36 / 255,
                                  green: 178 / 255,
                                  blue: 93 / 255,
                                  alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackgroundColor(for row: Int) {
        wrapperView.backgroundColor = row % 2 == 0
        ? UIColor.grayCellColor
        : UIColor.whiteCellColor
    }
    private func setupViews() {
        contentView.addSubview(wrapperView)
        
        [iconImageView,
         symbolLabel,
         isFavoriteImageView,
         companyNameLabel,
         priceLabel,
         percentLabel].forEach { wrapperView.addSubview($0) }
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            //wrapperView
            
            wrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            wrapperView.topAnchor.constraint(equalTo: contentView.topAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            //iconImageView
            iconImageView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 8),
            iconImageView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 8),
            iconImageView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -8),
            iconImageView.heightAnchor.constraint(equalToConstant: 52),
            iconImageView.widthAnchor.constraint(equalToConstant: 52),
            
            //symbolLabel
            symbolLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            symbolLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 14),

            //isFavoriteImageView
            isFavoriteImageView.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 6),
            isFavoriteImageView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 17),
            isFavoriteImageView.heightAnchor.constraint(equalToConstant: 18),
            isFavoriteImageView.widthAnchor.constraint(equalToConstant: 16),

            //companyNameLabel
            companyNameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            companyNameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor),

            //priceLabel
            priceLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -priceLabel.bounds.width),
            priceLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 14),

            //percentLabel
            percentLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -12),
            percentLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),

          
           
        ])
    }
}




