//
//  SwipingController.swift
//  GitHub API Swift
//
//  Created by Andreas Velounias on 01/10/2018.
//  Copyright © 2018 Andreas Velounias. All rights reserved.
//

import UIKit

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var pageArray = [Page]()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Previous", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    let gradientLayer: CAGradientLayer = {
        let caGradient = CAGradientLayer()
        caGradient.frame = UIScreen.main.bounds
        caGradient.colors = [UIColor(red: 28.0/255.0, green: 178.0/255.0, blue: 121.0/255.0, alpha: 1.0).cgColor, UIColor.black.cgColor]
        caGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        caGradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        return caGradient
    }()
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private let nextButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        
        if pageControl.currentPage == pageArray.count - 2 {
            nextButton.setTitle("Finish", for: .normal)
        }
        else {
            nextButton.setTitle("Next", for: .normal)
        }
        
        if checkIfLastPage() {
            print("Last Commit")
        }
        else {
            let nextIndex = min(pageControl.currentPage + 1, pageArray.count - 1)
            let indexPath = IndexPath(item: nextIndex, section: 0)
            pageControl.currentPage = nextIndex
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pageArray.count
        pc.currentPageIndicatorTintColor = UIColor.cyan
        pc.pageIndicatorTintColor = UIColor.blue
        pc.isHidden = true
        return pc
    }()
    
    fileprivate func checkIfLastPage() -> Bool {
        
        if pageControl.currentPage == pageArray.count - 1 {
            return true
        }
        else {
            return false
        }
    }
    
    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsStackView)
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
                ])
        } else {
            // Fallback on earlier versions
            NSLayoutConstraint.activate([
                bottomControlsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 24),
                bottomControlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                bottomControlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 24),
                bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
                ])
        }
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
        
        if checkIfLastPage() {
            nextButton.setTitle("FINISH", for: .normal)
        }
        else {
            nextButton.setTitle("NEXT", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataSet().getData(completionHandler: {array in
            self.pageArray = array
        })
        
        view.layer.insertSublayer(self.gradientLayer, at: 0)
        
        setupBottomControls()
        
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
