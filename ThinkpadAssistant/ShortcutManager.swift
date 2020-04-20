//
//  ShortcutManager.swift
//  ThinkpadAssistant
//
//  Created by Matt on 17.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Foundation
import MASShortcut

class ShortcutManager {
    
    static let systemPrefsShortcut = MASShortcut(keyCode: kVK_F18, modifierFlags: [])
    static let launchpadShortcut = MASShortcut(keyCode: kVK_F19, modifierFlags: [])
    static let micMuteShortcut = MASShortcut(keyCode: kVK_F20, modifierFlags: [])
    
    private static var muteIcon:NSImage = {
        let image = NSImage(named: "NSTouchBarAudioInputMuteTemplate")
        let resized = image!.resizeWhileMaintainingAspectRatioToSize(size: NSSize(width: 76.0, height: 120.0))
        let cropped = resized!.crop(size: NSSize(width: 85.0, height: 130.0))
        cropped?.isTemplate = true
        return cropped!
    }()
    
    private static var unmuteIcon:NSImage = {
        let image = NSImage(named: "NSTouchBarAudioInputTemplate")
        let resized = image!.resizeWhileMaintainingAspectRatioToSize(size: NSSize(width: 36.0, height: 120.0))
        let cropped = resized!.crop(size: NSSize(width: 40.3, height: 130.0))
        cropped?.isTemplate = true
        return cropped!
    }()
    
    class func register() {
        MASShortcutMonitor.shared()?.register(systemPrefsShortcut, withAction: {
            startApp(withBundleIdentifier: "com.apple.systempreferences")
            })
        
        MASShortcutMonitor.shared()?.register(launchpadShortcut, withAction: {
            startApp(withBundleIdentifier: "com.apple.launchpad.launcher")
        })
        
        MASShortcutMonitor.shared()?.register(micMuteShortcut, withAction: {
            if(MuteMicManager.shared.isMuted() == true){
                HUD.showImage(unmuteIcon, status: "Microphone              \nunmuted")
                MuteMicManager.shared.toogleMute()
                
            } else {
                HUD.showImage(muteIcon, status: "Microphone              \nmuted")
                MuteMicManager.shared.toogleMute()
                
            }
        })
        
    }
    
    
    class func unregister() {
        MASShortcutMonitor.shared().unregisterShortcut(systemPrefsShortcut)
    }
    
    class func startApp(withBundleIdentifier: String){
        
        let focusedApp = NSWorkspace.shared.frontmostApplication?.bundleIdentifier
        
        if(withBundleIdentifier == focusedApp){
            NSRunningApplication.runningApplications(withBundleIdentifier: focusedApp!).first?.hide()
        } else {
            NSWorkspace.shared.launchApplication(withBundleIdentifier: withBundleIdentifier, options: NSWorkspace.LaunchOptions.default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
        }
    }
}