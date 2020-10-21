//
//  ImageNames.swift
//  SwiftUISample
//
//  Created by Abhinay kukkadapu on 12/13/19.
//  Copyright © 2019 Deepthi. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics


let imageCache = NSCache<AnyObject,AnyObject>()
class ImageNames {
    
    static let emptyImage = UIImage()
    static let arrow = UIImage(named: "arrow")!
    static let downArrow = UIImage(named: "downArrow")!
    static let expand = UIImage(named: "expand")!
    static let placeholder = UIImage(named: "placeholder")!
    static let recipeplaceholder = UIImage(named: "recipeplaceholder")!
    static let logout = UIImage(named: "logout")!
    
    
}


extension UIImage {
    
    func maskWithColor(_ color: UIColor) -> UIImage {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return self
        }
    }
    
}

extension UIImageView {
    
    func load(url: String) {
        // self.image = nil
        self.backgroundColor = Colors.clear
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        if let fileUrl = URL(string: url) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: fileUrl) {
                    if let imageToCache = UIImage(data: data) {
                        imageCache.setObject(imageToCache, forKey: url as AnyObject)
                        DispatchQueue.main.async {
                            self?.image = imageToCache
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self?.backgroundColor = UIColor.random()
                    }
                }
            }
        }else{
            self.backgroundColor = UIColor.random()
        }
    }
}
