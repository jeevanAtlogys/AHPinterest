//
//  AHNetowrkTool.swift
//  AHDataGenerator
//
//  Created by Andy Hurricane on 3/29/17.
//  Copyright © 2017 Andy Hurricane. All rights reserved.
//

import UIKit

let shouldCacheImage = true

class AHNetowrkTool: NSObject {
    static let tool = AHNetowrkTool()
    
    var imageCache = [String: UIImage]()
    
    
}

// MARK:- For Discover Stuff
extension AHNetowrkTool {
    func loadCategoryData(forCategoryName name: String, completion: ((_ dataModels:[AHCategoryDataModel]? )-> ())? ) {
        DispatchQueue.global().async {
            let dataModels = AHPinDataGenerator.generator.loadCategories(categoryName: name)
            DispatchQueue.main.async {
                completion?(dataModels)
            }
        }
    }
    
    func loadCategoryNames(comletion: (([String]?)->())? ) {
        
        // this is so fake.....
        DispatchQueue.global().async {
//            sleep(5)
            DispatchQueue.main.async {
                let categoryArr = AHPinDataGenerator.generator.generateCategories()
                comletion?(categoryArr)
            }
        }
    }
}


// MARK:- Pin Data Related
extension AHNetowrkTool {
    func loadNewData(completion: @escaping ([AHPinViewModel]) -> Swift.Void) {
        // fake networking:)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let arr = AHPinDataGenerator.generator.randomData()
            completion(arr)
        }
    }
}


// MARK:- Image Related
extension AHNetowrkTool {
    func requestImage(urlStr: String, completion: @escaping (_ image: UIImage?) -> Swift.Void) {
        guard let url = URL(string: urlStr) else {
            return
        }
        if let cachedImg = imageCache[url.absoluteString] {
            completion(cachedImg)
        }else{
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                DispatchQueue.main.async {
                    if let data = data, error == nil {
                        if let image = UIImage(data: data) {
                            self.imageCache[url.absoluteString] = image
                            completion(image)
                            return
                        }
                        
                    }
                    completion(nil)
                }
            }
            task.resume()
            
        }
    }
}
