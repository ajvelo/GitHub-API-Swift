//
//  SwipingController.swift
//  autolayout_lbta
//
//  Created by Brian Voong on 10/12/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let pages = [
        Page(headerText: "Qured\n\nWelcome to the new\n\nHome Healthcare", imageURL: "https://avatars0.githubusercontent.com/u/1120569?v=4"),
        Page(headerText: "Book a Doctor\n\nPhysiotherapist\n\nOr Phone Consultation", imageURL: "none"),
        Page(headerText: "Healthcare to your door\n\n7 days a week\n\nAt Home or at Work", imageURL: "none"),
        Page(headerText: "Healthcare for you\n\nAnd your family", imageURL: "none"),
        Page(headerText: "Available\n\nthroughout\n\nGreater London", imageURL: "none")
    ]
    
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
        
        if pageControl.currentPage == pages.count - 2 {
            nextButton.setTitle("Finish", for: .normal)
        }
        else {
            nextButton.setTitle("Next", for: .normal)
        }
        
        if checkIfLastPage() {
//            let destVC = self.storyboard?.instantiateViewController(withIdentifier: "AreaValidationVC") as? AreaValidationVC
//            self.present(destVC!, animated: true, completion: nil)
        }
        else {
            let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
            let indexPath = IndexPath(item: nextIndex, section: 0)
            pageControl.currentPage = nextIndex
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = UIColor.cyan
        pc.pageIndicatorTintColor = UIColor.blue
        pc.isHidden = true
        return pc
    }()
    
    fileprivate func checkIfLastPage() -> Bool {
        
        if pageControl.currentPage == pages.count - 1 {
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
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        setupBottomControls()
        
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        
        let jsonURL = URL(string: "https://api.github.com/repos/apple/swift/git/refs/heads/master")!
        jsonURL.asyncDownload { data, response, error in
            guard
                let data = data,
                let dict = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
                let object = dict["object"] as? NSDictionary,
                let url = URL(string: object["url"] as! String)
                else {
                    print("error:", error ?? "nil")
                    return
            }
            DispatchQueue.main.async {
                url.asyncDownload { data, response, error in
                    guard
                        let data = data,
                        let dict = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
                        let object = dict["tree"] as? NSDictionary,
                        var urlString = object["url"] as? String
                        else {
                            print("error:", error ?? "nil")
                            return
                    }
                    DispatchQueue.main.async {
                        urlString.append("?recursive=1")
                        let url = URL(string: urlString)
                        
                        url!.asyncDownload { data, response, error in
                            guard
                                let data = data,
                                let dict = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
                                let object = dict["tree"] as? [NSDictionary]
                                else {
                                    print("error:", error ?? "nil")
                                    return
                            }
                            DispatchQueue.main.async {
                                
                                var urlCommit = "https://api.github.com/repos/apple/swift/commits?path="
                                urlCommit.append((object.first!["path"] as? String)!)

                                URL(string: urlCommit)?.asyncDownload { data, response, error in
                                    guard
                                        let dataCommit = data,
                                        let dictCommit = (try? JSONSerialization.jsonObject(with: dataCommit)) as? [[String: Any]],
                                        let author = dictCommit[0]["author"] as? [String: Any],
                                        let commit = dictCommit[0]["commit"] as? [String: Any],
                                    let authorName = commit["author"] as? [String: Any]
                                        else {
                                            print("error:", error ?? "nil")
                                            return
                                    }
                                    DispatchQueue.main.async {
                                        print(authorName["name"])
//                                        print(author!["avatar_url"]!) URL FOR IMAGE
                                    }
                                }
                                
//                                for o in object {
//                                    urlCommit.append((o["path"] as? String)!)
//                                    print(urlCommit)
//
//                                    URL(string: urlCommit)?.asyncDownload { data, response, error in
//                                        guard
//                                            let data = data,
//                                            let dictCommit = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
////                                            let object = dict["tree"] as? [NSDictionary]
//                                            else {
//                                                print("error:", error ?? "nil")
//                                                return
//                                        }
//                                        DispatchQueue.main.async {
//                                            print(dictCommit)
//                                        }
//                                    }
//                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
