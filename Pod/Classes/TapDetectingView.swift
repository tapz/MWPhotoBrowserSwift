//
//  TapDetectingView.swift
//  MWPhotoBrowserSwift
//
//  Created by Tapani Saarinen on 04/09/15.
//  Original obj-c created by Michael Waterfall 2013
//
//

import Foundation

class TapDetectingView: UIView {
    weak var tapDelegate: TapDetectingViewDelegate?
    
    init() {
        super.init(frame: CGRectZero)
        userInteractionEnabled = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
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
            td.singleTapDetectedInView(self, touch: touch)
        }
    }

    func handleDoubleTap(touch: UITouch) {
        if let td = tapDelegate {
            td.doubleTapDetectedInView(self, touch: touch)
        }
    }

    func handleTripleTap(touch: UITouch) {
        if let td = tapDelegate {
            td.tripleTapDetectedInView(self, touch: touch)
        }
    }
}

protocol TapDetectingViewDelegate: class {
    func singleTapDetectedInView(view: UIView, touch: UITouch)
    func doubleTapDetectedInView(view: UIView, touch: UITouch)
    func tripleTapDetectedInView(view: UIView, touch: UITouch)
}
