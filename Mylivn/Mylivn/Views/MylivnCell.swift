//
//  MylivnCell.swift
//  Mylivn
//
//  Created by Karthik Kumar on 26/03/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import UIKit

// MARK: - MylivnCellDelegate protocol
protocol MylivnCellDelegate: class {
    func deleteMe(cell: MylivnCell)
}

// MARK: - MylivnCell class
class MylivnCell: UICollectionViewCell {
    
    // MARK: - static member variables
    static let identifier: String = "MylivnCell"
    
    // for color randomizing on loading cells
    static let colors: [UIColor] = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)]
    
    // MARK: - member variables
    weak var delegate: MylivnCellDelegate?
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ios-application-placeholder")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFill
//        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    let crossButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "Red_cross_tick")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.contentMode = .scaleAspectFit
        b.layer.cornerRadius = 2
        b.layer.masksToBounds = true
        b.backgroundColor = UIColor.red
        b.layer.borderWidth = 1.0
        b.layer.borderColor = AppColors.theme.getColor().cgColor
        b.tintColor = UIColor.white
        return b
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.color = UIColor.blue
        ai.sizeThatFits(CGSize(width: 100, height: 100))
        return ai
    }()
    
    // MARK: - life cycle methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupFrames()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupFrames()
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "ios-application-placeholder")?.withRenderingMode(.alwaysTemplate)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        stopWiggle()
    }
    
    // MARK: - view setup
    private func setupFrames() {
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        crossButton.frame = CGRect(x: frame.width - 20, y: 0, width: 20, height: 20)
    }
    
    private func setupViews() {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        layer.borderColor = AppColors.theme.getColor().cgColor
        layer.borderWidth = 1.0
        
        addSubview(imageView)
        addSubview(activityIndicator)
        addSubview(crossButton)
        
        crossButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        
        setupFrames()
        
        setupRandomizedColor()
    }
    
    private func setupRandomizedColor() {
        let colorIndex: Int = abs(Int(randomInterval(interval: TimeInterval(1000), variance: 10)) % MylivnCell.colors.count)
        imageView.tintColor = MylivnCell.colors[colorIndex]
        activityIndicator.color = MylivnCell.colors[colorIndex]
    }
    
    func configure(data: ImageData) {
        activityIndicator.startAnimating()
        imageView.loadImage(url: data.imageUrlString, completion: { [weak self] () in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        })
    }
    
    // MARK: - actions
    @objc
    func buttonAction(sender: UIButton) {
        delegate?.deleteMe(cell: self)
    }

    // MARK: - animations
    func startWiggle() {
        layer.removeAnimation(forKey: "wiggle")
        layer.removeAnimation(forKey: "bounce")
        
        let angle = 0.04
        
        let wiggle = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        wiggle.values = [-angle, angle]
        
        wiggle.autoreverses = true
        wiggle.duration = randomInterval(interval: 0.1, variance: 0.025)
        wiggle.repeatCount = Float.infinity
        
        contentView.layer.add(wiggle, forKey: "wiggle")
        
        let bounce = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounce.values = [4.0, 0.0]
        
        bounce.autoreverses = true
        bounce.duration = randomInterval(interval: 0.12, variance: 0.025)
        bounce.repeatCount = Float.infinity
        
        layer.add(bounce, forKey: "bounce")
    }
    
    func stopWiggle() {
        layer.removeAnimation(forKey: "wiggle")
        layer.removeAnimation(forKey: "bounce")
//        layer.removeAllAnimations()
    }
    
    func randomInterval(interval: TimeInterval, variance: Double) -> TimeInterval {
        return interval + variance * Double((Double(arc4random_uniform(1000)) - 500.0) / 500.0)
    }
    
}
