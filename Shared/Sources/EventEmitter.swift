//
//  EventEmitter.swift
//  Tetris
//
//  Created by Christophe on 03/04/2021.
//

import Foundation

class EventEmitter<T> {
    
    typealias Callback = (_: T, _: Any?) -> Void
    
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
        ParameterlessEventEmitter.synchronized {
            listeners.append(entry)
        }
        return entry
    }
    
	@discardableResult func once(_ callback: @escaping Callback) -> EventEmitterEntry {
        return on(callback, usageLimit: 1)
    }
    
    func notify(_ parameters: T, from sender: Any? = nil) -> Void {
        var toCall: [Callback] = []
        
        ParameterlessEventEmitter.synchronized {
            for listener in listeners {
                toCall.append(listener.use())
            }
        }
        
        for callback in toCall {
            callback(parameters, sender)
        }
    }
    
}

class ParameterlessEventEmitter {
    
    typealias Callback = (_: Any?) -> Void
    
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
        ParameterlessEventEmitter.synchronized {
            listeners.append(entry)
        }
        return entry
    }
    
	@discardableResult func once(_ callback: @escaping Callback) -> EventEmitterEntry {
        return on(callback, usageLimit: 1)
    }
    
    func notify(from sender: Any? = nil) -> Void {
        var toCall: [Callback] = []
        
        ParameterlessEventEmitter.synchronized {
            for listener in listeners {
                toCall.append(listener.use())
            }
            listeners = listeners.filter { $0.isUsable }
        }
        
        for callback in toCall {
            callback(sender)
        }
    }

    fileprivate static func synchronized(_ block: () -> Void) -> Void {
        ParameterlessEventEmitter.queue.sync(execute: block)
    }
    
}
