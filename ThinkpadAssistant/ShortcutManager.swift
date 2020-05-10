//
//  ShortcutManager.swift
//  ThinkpadAssistant
//
//  Created by Matt on 17.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Cocoa

final class ShortcutManager {
    
    static let mirroringMonitorShortcut = Shortcut(key: .f16, modifiers: [])
    static let disableWlanShortcut = Shortcut(key: .f17, modifiers: [])
    static let systemPrefsShortcut = Shortcut(key: .f18, modifiers: [])
    static let launchpadShortcut = Shortcut(key: .f19, modifiers: [])
    static let micMuteShortcut = Shortcut(key: .f20, modifiers: [])
    static let micMuteShortcutActivate = Shortcut(key: .f20, modifiers: [.control])
    static let micMuteShortcutDeactivate = Shortcut(key: .f20, modifiers: [.command])
    
    static func register() {
        
        ShortcutMonitor.shared.register(systemPrefsShortcut, withAction: {
            startApp(withBundleIdentifier: "com.apple.systempreferences")
        })
        
        ShortcutMonitor.shared.register(launchpadShortcut, withAction: {
            startApp(withBundleIdentifier: "com.apple.launchpad.launcher")
        })
        
        ShortcutMonitor.shared.register(micMuteShortcut, withAction: {
            if(MuteMicManager.isMuted() == true){
                HUD.showImage(Icons.unmute, status: NSLocalizedString("Microphone\nunmuted", comment: ""))
                MuteMicManager.toggleMute()
            } else {
                HUD.showImage(Icons.mute, status: NSLocalizedString("Microphone\nmuted", comment: ""))
                MuteMicManager.toggleMute()
            }
        })
        
        ShortcutMonitor.shared.register(micMuteShortcutActivate, withAction: {
            if(MuteMicManager.isMuted() == true){
                HUD.showImage(Icons.unmute, status: NSLocalizedString("Microphone\nunmuted", comment: ""))
                MuteMicManager.activateMicrophone()
            }
        })
        
        ShortcutMonitor.shared.register(micMuteShortcutDeactivate, withAction: {
            if(MuteMicManager.isMuted() == false){
                HUD.showImage(Icons.mute, status: NSLocalizedString("Microphone\nmuted", comment: ""))
                MuteMicManager.deactivateMicrophone()
            }
        })
        
        ShortcutMonitor.shared.register(disableWlanShortcut, withAction: {
            if(WifiManager.isPowered() == nil){
                return
            } else if(WifiManager.isPowered() == true){
                HUD.showImage(Icons.wlanOff, status: NSLocalizedString("Wi-Fi\ndisabled", comment: ""))
                WifiManager.disableWifi()
            } else {
                HUD.showImage(Icons.wlanOn, status: NSLocalizedString("Wi-Fi\nenabled", comment: ""))
                WifiManager.enableWifi()
            }
        })
        
        ShortcutMonitor.shared.register(mirroringMonitorShortcut, withAction: {
            if(DisplayManager.getDisplayCount() > 1){
                if(DisplayManager.isDisplayMirrored() == true){
                    DispatchQueue.background(background: {
                        DisplayManager.disableHardwareMirroring()
                    }, completion:{
                        HUD.showImage(Icons.extending, status: NSLocalizedString("Screen\nextending", comment: ""))
                    })
                } else {
                    DispatchQueue.background(background: {
                        DisplayManager.enableHardwareMirroring()
                    }, completion:{
                        HUD.showImage(Icons.mirroring, status: NSLocalizedString("Screen\nmirroring", comment: ""))
                    })
                }
            }
        })
        
    }
    
    static func unregister() {
        ShortcutMonitor.shared.unregisterAllShortcuts()
    }
    
    private static func startApp(withBundleIdentifier: String){
        
        let focusedApp = NSWorkspace.shared.frontmostApplication?.bundleIdentifier
        
        if(withBundleIdentifier == focusedApp){
            NSRunningApplication.runningApplications(withBundleIdentifier: focusedApp!).first?.hide()
        } else {
            NSWorkspace.shared.launchApplication(withBundleIdentifier: withBundleIdentifier, options: NSWorkspace.LaunchOptions.default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
        }
    }
}
