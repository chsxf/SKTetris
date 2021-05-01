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
	
	static func setup() -> Void {
        SettingsManager.initialize()
        print(SettingsManager.sfxEnabled)
        
		let rect = NSRect(x: 100, y: 100, width: 640, height: 360)
		
		let window = NSWindow(contentRect: rect, styleMask: [.titled, .closable, .resizable], backing: .buffered, defer: false)
		window.title = "Tetris"
		window.contentView = GameView(frame: rect)
		window.makeKeyAndOrderFront(nil)
		window.toggleFullScreen(nil)
	}
	
	static func main() -> Void {
		NSApp = NSApplication.shared
		
		let delegate = AppDelegate()
		NSApp.delegate = delegate
		
		setup()
		
		NSApp.run()
	}

}
