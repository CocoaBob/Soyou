//
//  RocketChatManager.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 10/10/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import Foundation
import RealmSwift
import UserNotifications

public struct RocketChatManager {

    private static let kApplicationServerURLKey = "RC_SERVER_URL"

    /**
     The app allows the user to fix a URL and disable the multi-server support
     by adding the value "RC_SERVER_URL" to the Info.plist file. This will imply
     in not allowing the user to type a custom server URL when authenticating.

     - returns: The custom URL, if this app has some URL fixed in the settings.
     */
    public static var applicationServerURL: URL? {
        if let serverURL = Bundle.main.object(forInfoDictionaryKey: kApplicationServerURLKey) as? String {
            return URL(string: serverURL)
        }

        return nil
    }

    /**
     The app won't support multi-server if we have a fixed URL into the app.

     - returns: If the server supports multi-server feature.
     */
    public static var supportsMultiServer: Bool {
        return applicationServerURL == nil
    }

    /**
     Default room Id

     If set, App will go straight to this room after launching
    */
    public static var initialRoomId: String?

}

// MARK: - Sign In/Out
public extension RocketChatManager {
    
    public static func signIn(socketServerAddress: String, userId: String, token: String, completion: (()->())?) {
        // Authentication
        var auth = Auth()
        
        if let oldAuth = AuthManager.isAuthenticated() {
            auth = oldAuth
        } else {
            auth.lastSubscriptionFetch = nil
            auth.lastAccess = Date()
            auth.serverURL = socketServerAddress
            auth.userId = userId
            auth.token = token
            
            Realm.executeOnMainThread({ (realm) in
                // Delete all the Auth objects, since we don't
                // support multiple-server per database
                realm.delete(realm.objects(Auth.self))
                
                PushManager.updatePushToken()
                realm.add(auth)
            })
        }
        
        AuthManager.persistAuthInformation(auth)
        DatabaseManager.changeDatabaseInstance()
        
        SocketManager.reconnect() {
            SubscriptionsViewController.shared?.subscribeModelChanges()
            ChatViewController.shared?.subscription = nil
            completion?()
        }
    }
    
    public static func signOut() {
        API.current()?.client(PushClient.self).deletePushToken()
    
        AuthManager.logout {
            AuthManager.recoverAuthIfNeeded()
        }
    }
}

// MARK: - Open Rooms
public extension RocketChatManager {
    
    public static func openDirectMessage(username: String, completion: (() -> ())? = nil) {
        
        func openDirectMessage() -> Bool {
            guard let directMessageRoom = Subscription.find(name: username, subscriptionType: [.directMessage]) else {
                completion?()
                return false
            }
            ChatViewController.shared?.subscription = directMessageRoom
            completion?()
            return true
        }

        // Check if already have a direct message room with this user
        if openDirectMessage() == true {
            return
        }

        // If not, create a new direct message
        SubscriptionManager.createDirectMessage(username, completion: { response in
            guard !response.isError() else {
                completion?()
                return
            }

            guard let auth = AuthManager.isAuthenticated() else {
                completion?()
                return
            }

            SubscriptionManager.updateSubscriptions(auth) { _ in
                _ = openDirectMessage()
            }
        })
    }

    public static func openChannel(name: String) {
        func openChannel() -> Bool {
            guard let channel = Subscription.find(name: name, subscriptionType: [.channel]) else { return false }

            ChatViewController.shared?.subscription = channel

            return true
        }

        // Check if we already have this channel
        if openChannel() == true {
            return
        }

        // If not, fetch it
        let request = SubscriptionInfoRequest(roomName: name)
        API.current()?.fetch(request, succeeded: { result in
            DispatchQueue.main.async {
                Realm.executeOnMainThread({ realm in
                    guard let values = result.channel else { return }

                    let subscription = Subscription.getOrCreate(realm: realm, values: values, updates: { object in
                        object?.rid = object?.identifier ?? ""
                    })

                    realm.add(subscription, update: true)
                })

                _ = openChannel()
            }
        }, errored: nil)
    }
}

// MARK: - UIApplicationDelegate

public extension RocketChatManager {
    
    public static func appDidFinishLaunchingWithOptions(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        PushManager.setupNotificationCenter()
        UIApplication.shared.registerForRemoteNotifications()
        if let launchOptions = launchOptions,
            let notification = launchOptions[.remoteNotification] as? [AnyHashable: Any] {
            PushManager.handleNotification(raw: notification)
        }
    }
    
    public static func appDidBecomeActive() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    public static func appDidEnterBackground() {
        SubscriptionManager.updateUnreadApplicationBadge()
        if AuthManager.isAuthenticated() != nil {
            UserManager.setUserPresence(status: .away) { (_) in
                SocketManager.disconnect({ (_, _) in })
            }
        }
    }
    
    public static func appDidRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        UserDefaults.standard.set(deviceToken.hexString, forKey: PushManager.kDeviceTokenKey)
    }
    
    public static func appDidFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        Log.debug("Fail to register for notification: \(error)")
    }
}

// MARK: - Unread Number

public extension RocketChatManager {
    
    public static func getUnreadNumber(_ completion: ((Int)->())?) {
        SubscriptionManager.getUnreadNumber(completion)
    }
}

// MARK: Deep Link

public extension RocketChatManager {
    
    public static func handleDeepLink(_ url: URL, completion: (()->())?) -> Bool {
        guard let deepLink = DeepLink(url: url) else { return false }
        RocketChatManager.handleDeepLink(deepLink, completion: completion)
        return true
    }
    
    internal static func handleDeepLink(_ deepLink: DeepLink, completion: (()->())?) {
        switch deepLink {
        case let .auth(_, _):
            return
        case let .room(_, _):
            return
        case let .mention(name):
            openDirectMessage(username: name, completion: completion)
        case let .channel(name):
            openChannel(name: name)
        }
    }
}
