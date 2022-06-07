//
//  ChartsView.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 06.06.2022.
//

import UIKit

final class ChartsContainerView: UIView {
    
    private lazy var chartsView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(chartsView)
        addSubview(buttonsStackView)
        
        addButtons(for: ["W", "M", "6M", "1Y"])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chartsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartsView.topAnchor.constraint(equalTo: topAnchor),
            chartsView.heightAnchor.constraint(equalTo: chartsView.widthAnchor, multiplier: 26/36),
            
            
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonsStackView.topAnchor.constraint(equalTo: chartsView.bottomAnchor, constant: 40),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addButtons(for titles: [String]) {
        titles.enumerated().forEach { (index, title) in
            let button = UIButton()
            button.tag = index
            button.backgroundColor = UIColor.periodButtonBackgroundColor
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.semiBold(size: 12)
            button.layer.cornerRadius = 12
            button.addTarget(self, action: #selector(periodButtonTapped), for: .touchUpInside)
            button.layer.cornerCurve = .continuous
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    @objc private func  periodButtonTapped(sender: UIButton) {
        print("Button index -", sender.tag)
    }
}
