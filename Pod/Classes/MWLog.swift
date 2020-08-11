//
//  MWLog.swift
//  Pods
//
//  Created by Tapani Saarinen on 09/09/15.
//
//

import Foundation

class MWLog: NSObject {
    static let queue = DispatchQueue(__label: "com.mwphotobrowser", attr: nil)
    static let formatter = DateFormatter()
    
    class func log(format: String) {
        formatter.dateStyle = DateFormatter.Style.none
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = "HH:mm:ss.SSS"
        
        let tid = String(format: "%.05x", pthread_mach_thread_np(pthread_self()))
        let tme = formatter.string(from: Date())
        let str = "\(tme) [\(tid)] " + format
        
        queue.async() {
            print(str)
        }
    }
}
