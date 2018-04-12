//
//  AddCell.swift
//  Mylivn
//
//  Created by Karthik Kumar on 28/03/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import UIKit

class AddCell: UICollectionViewCell {
    
    // MARK: - Members variables
    static let identifier: String = "AddCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = "ADD"
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "button_add")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.white
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupFrames()
    }
    
    // MARK: - Setup view
    private func setupViews() {
        backgroundColor = AppColors.theme.getColor()
        
        addSubview(imageView)
        addSubview(label)
        
        setupFrames()
    }
    
    private func setupFrames() {
        imageView.frame = CGRect(x: 0, y: frame.height / 2 - (frame.height * 0.6 / 2), width: frame.width, height: frame.height / 2)
        label.frame = CGRect(x: 0, y: imageView.frame.height + imageView.frame.origin.y, width: frame.width, height: 20)
    }
    
    // MARK: - Animation
    func shakeMe() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut], animations: { () -> Void in
            self.alpha = 0.5
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { finished in
            self.alpha = 1.0
            self.transform = .identity
        })
    }
    
}
