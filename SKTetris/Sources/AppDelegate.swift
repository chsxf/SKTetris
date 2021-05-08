//
//  AppDelegate.swift
//  Tetris
//
//  Created by Christophe SAUVEUR on 04/03/2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}
	
	static private func setup() -> Void {
        SettingsManager.initialize()
        SoundManager.preloadSounds()
        
		let rect = NSRect(x: 100, y: 100, width: 640, height: 360)
		
		let window = NSWindow(contentRect: rect, styleMask: [.titled, .closable, .resizable], backing: .buffered, defer: false)
		window.title = "SKTetris"
		window.contentView = GameView(frame: rect)
		window.makeKeyAndOrderFront(nil)
		window.toggleFullScreen(nil)
	}
	
    static private func setupMainMenu() -> Void {
        let applicationName = ProcessInfo.processInfo.processName
        let mainMenu = NSMenu()
        
        let menuItemOne = NSMenuItem()
        menuItemOne.submenu = NSMenu(title: "menuItemOne")
        menuItemOne.submenu?.items = [
            NSMenuItem(title: "Quit \(applicationName)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        ]
        
        mainMenu.items = [menuItemOne]
        NSApp.mainMenu = mainMenu
    }
    
	static func main() -> Void {
		NSApp = NSApplication.shared
		
		let delegate = AppDelegate()
		NSApp.delegate = delegate
		
		setup()
        setupMainMenu()
		
		NSApp.run()
	}

}
