//
//  PageCell.swift
//  GitHub API Swift
//
//  Created by Andreas Velounias on 01/10/2018.
//  Copyright © 2018 Andreas Velounias. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var topImageContainerView: UIView!
    
    var page: Page? {
        didSet {
            
            guard let unwrappedPage = page else { return }
            
            for view in topImageContainerView.subviews {
                view.removeFromSuperview()
            }
            
            _ = addImages(imageURL: unwrappedPage.image)

            let attributedText = NSMutableAttributedString(string: unwrappedPage.name, attributes: [NSAttributedStringKey.font: UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!])
            attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedText.length))
            
            descriptionTextView.attributedText = attributedText
            descriptionTextView.textAlignment = .center
        }
    }
    
    let gradientLayer: CAGradientLayer = {
        let caGradient = CAGradientLayer()
        caGradient.frame = UIScreen.main.bounds
        caGradient.colors = [UIColor(red: 28.0/255.0, green: 178.0/255.0, blue: 121.0/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        caGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        caGradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        return caGradient
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = UIColor.clear
        
        return textView
    }()
    
    func addImages(imageURL: String) -> UIImageView {
        
        let imageView: UIImageView = {
            
            let url = URL(string: imageURL)
            let data = try? Data(contentsOf: url!)
            
            var imgView: UIImageView!
            
            if data != nil {
                imgView = UIImageView(image: UIImage(data: data!))
            }
            else {
                imgView = UIImageView(image: UIImage(named: "No-image-found"))
            }
            imgView.translatesAutoresizingMaskIntoConstraints = false
            imgView.contentMode = .scaleAspectFit
            
            return imgView
        }()
        
        topImageContainerView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.7).isActive = true
        
        return imageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
        layer.insertSublayer(gradientLayer, at: 0)
        
        topImageContainerView = UIView()
        addSubview(topImageContainerView)
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        topImageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        
        addSubview(descriptionTextView)
        descriptionTextView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
