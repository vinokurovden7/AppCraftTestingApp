//
//  ImageScrollView.swift
//  TestingApp
//
//  Created by Денис Винокуров on 30.12.2020.
//

import UIKit

class ImageScrollView: UIScrollView, UIScrollViewDelegate {

    var imageZoomView: UIImageView!
    var dividier: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = .fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(image: UIImage, dividier: Int) {
        imageZoomView?.removeFromSuperview()
        imageZoomView?.image = nil
        imageZoomView = UIImageView(image: image)
        self.addSubview(imageZoomView)
        configurateFor(imageSize: image.size)
        self.dividier = CGFloat(dividier)
    }
    
    func configurateFor(imageSize: CGSize) {
        self.contentSize = imageSize
        setCurrenMaxMinZumScale()
        self.zoomScale = self.minimumZoomScale
    }
    
    func setCurrenMaxMinZumScale() {
        let boundsSize = self.bounds.size
        let imageSize = imageZoomView.bounds.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale,yScale)
        
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.5
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.9
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        
        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
    }
    
    func centerImage() {
        let boundsSize = self.bounds.size
        var frameToCenter = imageZoomView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 3
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageZoomView.frame = frameToCenter
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.centerImage()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageZoomView
    }
    
}
