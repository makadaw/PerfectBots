//
//  Application.swift
//  SwiftBot
//

import Foundation
import BotsKit
import Facebook
import EchoBot
import Health
import LoggerAPI

/// Main object that connect components for chat bot application.
/// This class init and store chat providers, dispatcher and
/// bots handlers
internal final class Application {
    let health = Health()
    
    /// Chat messages dispatcher connect messages from providers to bots
    let dispatcher = ConnectorDispatcher()
    internal var routes: [RoutesFactory]
//    internal let connectionPool: ConnectionPool
    
    init(configuration: Configuration) throws {
        // Init default routes
        routes = [IndexRoutes()]
//        connectionPool =
        
        // Start application
        healthChecks()
        startBots(configuration: configuration)
    }
    
    private func healthChecks() {
        health.addCheck { () -> State in
            return State.UP
        }
        routes.append(health)
    }
    
    private func startBots(configuration: Configuration) {
        let token = configuration.fbSubscribeToken
        let accessToken = configuration.fbPageAccessToken
        let facebook = FacebookProvider(secretToken: token, accessToken: accessToken)
        
        let echoBot = EchoBot()
        dispatcher.register(bot: echoBot, in: facebook)
        
        routes.append(facebook)
    }
    
}
