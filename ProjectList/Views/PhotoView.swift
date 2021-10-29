//
//  PhotoView.swift
//  ProjectList
//
//  Created by Apple on 28/10/2021.
//

import UIKit

class PhotoView: UIView {
    
    var button : UIButton?
    var imageView : UIImageView?
    var isTouch = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor =  .clear
        button = UIButton()
        button!.frame = CGRect(x: frame.size.width/2-15, y: 0, width: 30, height: 30)
        Utilities.styleDeleteButton(button!)
        self.addSubview(button!)
        button!.isHidden = true
        
        button!.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        // imageView inside photoView
        imageView = UIImageView()
        imageView!.frame = CGRect(x: 0, y: 40, width: frame.size.width, height: frame.size.height-40)
        self.addSubview(imageView!)
        
        imageView?.isUserInteractionEnabled = true
        
        let onTapImageViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTap(_:)))
        imageView!.addGestureRecognizer(onTapImageViewGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(sender:)))
        self.addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotatePiece(_:)))
        self.addGestureRecognizer(rotationGesture)
        }

    
    @objc func imageViewTap(_ gesture: UITapGestureRecognizer) {
        if isTouch == false {
            imageView!.layer.borderWidth = 2
            imageView!.layer.borderColor = UIColor.systemBlue.cgColor
            button?.isHidden = false
            isTouch = true
        } else {
            imageView!.layer.borderWidth = 0
            button?.isHidden = true
            isTouch = false
        }
    }
    
    @objc func pinch(sender:UIPinchGestureRecognizer) {
        
        guard let view = sender.view else { return }
        if sender.state == .began || sender.state == .changed {
            imageView!.layer.borderWidth = 0
            button?.isHidden = true
            isTouch = false
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            
        }
        button!.transform =  button!.transform.scaledBy(x: 1/(sender.scale), y: 1/(sender.scale))
        button?.center.y -=  25*(1-sender.scale)
        
        sender.scale = 1
  
    }

    
    @objc func rotatePiece(_ gestureRecognizer : UIRotationGestureRecognizer) {
       guard let view = gestureRecognizer.view else { return }
    
       if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
          view.transform = view.transform.rotated(by: gestureRecognizer.rotation)
          gestureRecognizer.rotation = 0
       }
    }
    
    
    
    @objc func didTapButton() {
        self.removeFromSuperview()
    }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    
}
