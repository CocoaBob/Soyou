//
//  UIDevice+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 2017-11-20.
//  Copyright © 2017 Soyou. All rights reserved.
//

extension UIDevice {
    
    static var isX: Bool {
        if #available(iOS 11.0, *) {
            var model = ""
#if targetEnvironment(simulator)
                model = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
#else
                var size = 0
                sysctlbyname("hw.machine", nil, &size, nil, 0)
                var machine = [CChar](repeating: 0, count: size)
                sysctlbyname("hw.machine", &machine, &size, nil, 0)
                model = String(cString: machine)
#endif
            
            return model == "iPhone10,3" || model == "iPhone10,6" || model.starts(with: "iPhone11,")
        } else {
            return false
        }
    }
    
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
