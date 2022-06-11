//
//  StockCell.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 24.05.2022.
//

import UIKit
import Kingfisher


final class StockCell: UITableViewCell {
    private var favoriteAction: (() -> Void)?
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favorite-off"), for: .normal)
        button.setImage(UIImage(named: "favorite-on"), for: .selected)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stockNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semiBold(size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
  
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semiBold(size: 12)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteAction = nil
    }
    
    func setBackgroundColor(for row: Int) {
        wrapperView.backgroundColor = row % 2 == 0
        ? UIColor.StockCell.grayCellColor
        : UIColor.StockCell.whiteCellColor
    }
    
    func viewTapped() {
        animateWrapperView()
    }
    
    func configure(with model: StockModelProtocol) {
        symbolLabel.text = model.symbol
        stockNameLabel.text = model.name
        priceLabel.text = model.price
        percentLabel.text = model.change
        percentLabel.textColor = model.changeColor
        favoriteButton.isSelected = model.isFavorite
        favoriteAction = {
            model.setFavorite()
        }
       
        iconImageView.setImage(from: model.iconURL, placeholder: nil)
    }
    
    private func animateWrapperView() {
        guard let previousBackgroundColor = wrapperView.backgroundColor else { return }
   
        UIView.animate(withDuration: 0.1, delay: 0.0, options:[.curveEaseOut], animations: {
            self.wrapperView.backgroundColor = UIColor.StockCell.selectionColor
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn]) {
                self.wrapperView.backgroundColor = previousBackgroundColor
            }
        })
    }
    private func setupViews() {
        selectionStyle = .none
        contentView.addSubview(wrapperView)
        
        [iconImageView,
         symbolLabel,
         favoriteButton,
         stockNameLabel,
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
            iconImageView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 52),
            iconImageView.widthAnchor.constraint(equalToConstant: 52),
            
            //symbolLabel
            symbolLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            symbolLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 14),

            //isFavoriteImageView
            favoriteButton.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 6),
            favoriteButton.centerYAnchor.constraint(equalTo: symbolLabel.centerYAnchor),
            favoriteButton.heightAnchor.constraint(equalToConstant: 18),
            favoriteButton.widthAnchor.constraint(equalToConstant: 16),

            //companyNameLabel
            stockNameLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
            stockNameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor),

            //priceLabel
            priceLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -17),
            priceLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 14),

            //percentLabel
            percentLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -12),
            percentLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor)
        ])
    }
    
    // MARK: - Selectors
    @objc private func favoriteButtonTapped() {
        favoriteButton.isSelected.toggle()
        favoriteAction?()
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let iconTag = tag
        iconImageView.image = nil
                
        let cache = URLCache(memoryCapacity: 50, diskCapacity: 50, diskPath: "stock_icons")
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.httpMaximumConnectionsPerHost = 5
       
        let session = URLSession(configuration: configuration)
        
        session.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                if iconTag == self?.tag {
                    self?.iconImageView.image = image
                }
            }
        }.resume()
    }
}



// MARK: - UIColor extension for Stock cell color
extension UIColor {
    enum StockCell {
        static var grayCellColor: UIColor  { return UIColor(red: 240 / 255,
                                                            green: 244 / 255,
                                                            blue: 247 / 255,
                                                            alpha: 1) }
        static var whiteCellColor: UIColor { .white }
        
        static var percenGreenColor: UIColor { UIColor(red: 36 / 255,
                                                       green: 178 / 255,
                                                       blue: 93 / 255,
                                                       alpha: 1) }
        
        static var percenRedColor: UIColor { UIColor.systemRed }
        
        static var selectionColor: UIColor {
            .gray.withAlphaComponent(0.3)
        }
    }
}
