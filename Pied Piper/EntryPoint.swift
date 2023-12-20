//
//  EntryPoint.swift
//  Pied Piper
//
//  Created by Ruslan Lutfullin on 22/11/23.
//

import UIKit
import PiedPiperApplication
import PiedPiperApplicationDelegate

@main
struct EntryPoint {
    
    static func main() {
        UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(Application.self), NSStringFromClass(ApplicationDelegate.self))
    }
}
