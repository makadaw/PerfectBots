//
//  ConnectorDispatcher.swift
//  BotsKit
//

import LoggerAPI
import Dispatch

/*
 ---------------------
 |      Provider     |
 ---------------------
 ||                ^
 || Activity       | Message to chat provider
 \/                |
 ---------------------
 |     Dispatcher    |
 ---------------------
 ||                /\
 || Activity       || Replay
 \/                ||
 ----------------  ||
 |   Bot Impl   |===/
 ----------------
 |   Storage    |
 ----------------
 */

internal final class BotConnector {
    
    let provider: Provider
    
    let bot: Bot
    
    /// Dispatch queue to process messages from providers
    let queue: DispatchQueue
    
    var sessionsQueue: [Activity.Session:DispatchQueue] = [:]
    
    init(bot: Bot, provider: Provider) {
        self.bot = bot
        self.provider = provider
        
        // Run all requests cuncurrent
        queue = DispatchQueue(label: "Dispatch \(bot.name) - \(provider.name)", attributes: .concurrent)
        
        // Subscribe on signals
        
        // For many providers we need to answer ASAP with HTTP response, so for
        // this need to schedule processing on other queue
        // Subscribe on signals
        self.provider.recieveActivity.subscribe{ [unowned self] activity in
            self.messageQueue(session: activity.session).async {
                self.bot.dispatch(activity: activity)
            }
        }
        
        // Dispatch output activity to provider
        // This method can be run concurrently inside outcome group
        self.bot.sendActivity.subscribe{ [unowned self] activity in
            self.messageQueue(session: activity.session).async {
                self.provider.send(activity: activity)
            }
        }
    }
    
    /// Return queue that associated with session. This will run on serial queue for session
    /// that are run on concurrent connector queue.
    /// This will mean that activities associated with one session will be run in serial queue,
    /// but not related activities run on concurrent queue
    ///
    /// - Parameter session: identifier of the current session
    /// - Returns: session releated queue
    internal func messageQueue(session: Activity.Session?) -> DispatchQueue {
        if session == nil {
            return self.queue
        }
        guard let queue = sessionsQueue[session!] else {
            let sessionQueue = DispatchQueue(label: "", target: self.queue)
            sessionsQueue[session!] = sessionQueue
            return sessionQueue
        }
        return queue
    }
}

public final class ConnectorDispatcher {
    var connectors: [BotConnector]
    
    public init() {
        connectors = []
    }
    
    public func register(bot: Bot, `in` provider: Provider) {
        let connector = BotConnector(bot: bot, provider: provider)
        Log.verbose("Connect \(bot.name) to \(provider.name) provider")
        connectors.append(connector)
    }
}
