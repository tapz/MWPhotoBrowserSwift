//
//  TapDetectingImageView.swift
//  MWPhotoBrowserSwift
//
//  Created by Tapani Saarinen on 04/09/15.
//  Original obj-c created by Michael Waterfall 2013
//
//

import Foundation

public class TapDetectingImageView: UIImageView {
    public weak var tapDelegate: TapDetectingImageViewDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }

    public override init(image: UIImage?) {
        super.init(image: image)
        isUserInteractionEnabled = true
    }

    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        isUserInteractionEnabled = true
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first  {
            let tapCount = touch.tapCount
        
            switch tapCount {
            case 1: handleSingleTap(touch: touch)
            case 2: handleDoubleTap(touch: touch)
            case 3: handleTripleTap(touch: touch)
                default: break
            }
        }
        
        if let nr = next {
            nr.touchesEnded(touches, with: event)
        }
    }

    private func handleSingleTap(touch: UITouch) {
        if let td = tapDelegate {
            td.singleTapDetectedInImageView(view: self, touch: touch)
        }
    }

    private func handleDoubleTap(touch: UITouch) {
        if let td = tapDelegate {
            td.doubleTapDetectedInImageView(view: self, touch: touch)
        }
    }

    private func handleTripleTap(touch: UITouch) {
        if let td = tapDelegate {
            td.tripleTapDetectedInImageView(view: self, touch: touch)
        }
    }
}

public protocol TapDetectingImageViewDelegate: class {
    func singleTapDetectedInImageView(view: UIImageView, touch: UITouch)
    func doubleTapDetectedInImageView(view: UIImageView, touch: UITouch)
    func tripleTapDetectedInImageView(view: UIImageView, touch: UITouch)
}
