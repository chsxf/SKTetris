//
//  EventEmitter.swift
//  Tetris
//
//  Created by Christophe on 03/04/2021.
//

import Foundation

class EventEmitter<T: AnyObject> {
    
    typealias Callback = (_ parameters: T) -> Void
    
    class EventEmitterEntry {
        private let callback: Callback
        private let usageLimit: UInt
        private var usage: UInt = 0
        
        init(_ callback: @escaping Callback, usageLimit: UInt) {
            self.callback = callback
            self.usageLimit = usageLimit
        }
        
        fileprivate func use() -> Callback {
            if usageLimit > 0 {
                usage += 1
            }
            return callback
        }
        
        fileprivate var isUsable: Bool {
            return usageLimit == 0 || usageLimit > usage
        }
    }
    
    private var listeners: [EventEmitterEntry] = []
    
    init() { }
    
	@discardableResult func on(_ callback: @escaping Callback, usageLimit: UInt = 0) -> EventEmitterEntry {
        let entry = EventEmitterEntry(callback, usageLimit: usageLimit)
        SimpleEventEmitter.synchronized {
            listeners.append(entry)
        }
        return entry
    }
    
	@discardableResult func once(_ callback: @escaping Callback) -> EventEmitterEntry {
        return on(callback, usageLimit: 1)
    }
    
    func notify(_ parameters: T) -> Void {
        var toCall: [Callback] = []
        
        SimpleEventEmitter.synchronized {
            for listener in listeners {
                toCall.append(listener.use())
            }
        }
        
        for callback in toCall {
            callback(parameters)
        }
    }
    
}

class SimpleEventEmitter {
    
    typealias Callback = () -> Void
    
    fileprivate static let queue = DispatchQueue(label: "com.xhaleera.eventEmitter")

    class EventEmitterEntry {
        private let callback: Callback
        private let usageLimit: UInt
        private var usage: UInt = 0
        
        init(_ callback: @escaping Callback, usageLimit: UInt) {
            self.callback = callback
            self.usageLimit = usageLimit
        }
        
        fileprivate func use() -> Callback {
            if usageLimit > 0 {
                usage += 1
            }
            return callback
        }
        
        fileprivate var isUsable: Bool {
            return usageLimit == 0 || usageLimit > usage
        }
    }
    
    private var listeners: [EventEmitterEntry] = []
    
    init() { }
    
    @discardableResult func on(_ callback: @escaping Callback, usageLimit: UInt = 0) -> EventEmitterEntry {
        let entry = EventEmitterEntry(callback, usageLimit: usageLimit)
        SimpleEventEmitter.synchronized {
            listeners.append(entry)
        }
        return entry
    }
    
	@discardableResult func once(_ callback: @escaping Callback) -> EventEmitterEntry {
        return on(callback, usageLimit: 1)
    }
    
    func notify() -> Void {
        var toCall: [Callback] = []
        
        SimpleEventEmitter.synchronized {
            for listener in listeners {
                toCall.append(listener.use())
            }
            listeners = listeners.filter { $0.isUsable }
        }
        
        for callback in toCall {
            callback()
        }
    }

    fileprivate static func synchronized(_ block: () -> Void) -> Void {
        SimpleEventEmitter.queue.sync(execute: block)
    }
    
}
