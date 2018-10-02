//
//  DataSet.swift
//  GitHub API Swift
//
//  Created by Andreas Velounias on 02/10/2018.
//  Copyright © 2018 Andreas Velounias. All rights reserved.
//

import Foundation


class DataSet {
    
    func getData(completionHandler: @escaping (_ pagesArray: [Page]) -> ()){
        
        var pages = [Page]()
        
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
                        
//                        To get a list of all the files in all folders you can add recursive=1 as a parameter.
//                        urlString.append("?recursive=1")
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
                                
                                for o in object {
                                    
                                    var urlCommit = "https://api.github.com/repos/apple/swift/commits?path="
                                    urlCommit.append((o["path"] as? String)!)
                                    
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
                                        let page = Page(name: authorName["name"]! as! String + "\n" + self.getDate(isoDate: authorName["date"] as! String)!
                                                        + "\n" + commit["message"]! as! String + "\n" +  o["path"]! as! String, image: author["avatar_url"]! as! String)
                                        
                                        pages.append(page)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        completionHandler(pages)
    }
    
    func getDate(isoDate: String) -> String? {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
}
