//
//  TapDetectingImageView.swift
//  MWPhotoBrowserSwift
//
//  Created by Tapani Saarinen on 04/09/15.
//  Original obj-c created by Michael Waterfall 2013
//
//

import Foundation

class TapDetectingImageView: UIImageView {
    weak var tapDelegate: TapDetectingImageViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        userInteractionEnabled = true
    }

    override init(image: UIImage) {
        super.init(image: image)
        userInteractionEnabled = true
    }

    override init(image: UIImage, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        userInteractionEnabled = true
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch  {
            let tapCount = touch.tapCount
        
            switch tapCount {
                case 1: handleSingleTap(touch)
                case 2: handleDoubleTap(touch)
                case 3: handleTripleTap(touch)
                default: break
            }
        }
        
        if let nr = nextResponder() {
            nr.touchesEnded(touches, withEvent: event)
        }
    }

    func handleSingleTap(touch: UITouch) {
        if let td = tapDelegate {
            td.singleTapDetectedInImageView(self, touch: touch)
        }
    }

    func handleDoubleTap(touch: UITouch) {
        if let td = tapDelegate {
            td.doubleTapDetectedInImageView(self, touch: touch)
        }
    }

    func handleTripleTap(touch: UITouch) {
        if let td = tapDelegate {
            td.tripleTapDetectedInImageView(self, touch: touch)
        }
    }
}

protocol TapDetectingImageViewDelegate: class {
    func singleTapDetectedInImageView(view: UIImageView, touch: UITouch)
    func doubleTapDetectedInImageView(view: UIImageView, touch: UITouch)
    func tripleTapDetectedInImageView(view: UIImageView, touch: UITouch)
}