//
//  SubscriptionsViewController.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 7/21/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import RealmSwift

public protocol SubscriptionsViewControllerDelegate {
    
    func rocketChatDidUpdateSubscriptions()
}

// swiftlint:disable file_length
public final class SubscriptionsViewController: UIViewController {
    
    // Class methods
    public static let shared = UIStoryboard(name: "Subscriptions", bundle: Bundle(for: SubscriptionsViewController.self)).instantiateViewController(withIdentifier: "SubscriptionsViewController") as? SubscriptionsViewController

    @IBOutlet weak var tableView: UITableView!
    
    public var delegate: SubscriptionsViewControllerDelegate?

    var subscriptions = [Subscription]()
    var subscriptionResults: Results<Subscription>?
    var subscriptionsToken: NotificationToken?

    public override func awakeFromNib() {
        super.awakeFromNib()
        subscribeModelChanges()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if !SocketManager.isConnected() {
            SocketManager.reconnect() {
                self.reloadData()
            }
        }
    }
}

extension SubscriptionsViewController {

    func subscribeModelChanges() {
        if let token = subscriptionsToken {
            token.invalidate()
        }
        guard let auth = AuthManager.isAuthenticated() else { return }
        subscriptionResults = auth.subscriptions.sortedByLastSeen()
        subscriptionsToken = subscriptionResults?.observe(handleSubscriptionUpdates)
        reloadData()
    }
    
    func reloadData() {
        guard let subscriptionResults = subscriptionResults else { return }
        subscriptions.removeAll()
        for subscription in Array(subscriptionResults) {
            if subscription.type == .directMessage {
                subscriptions.append(subscription)
            }
        }
        tableView?.reloadData()
    }
    
    func handleSubscriptionUpdates<T>(changes: RealmCollectionChange<RealmSwift.Results<T>>?) {
        reloadData()
        delegate?.rocketChatDidUpdateSubscriptions()
    }

    func subscription(for indexPath: IndexPath) -> Subscription? {
        return subscriptions[indexPath.row]
    }
}

extension SubscriptionsViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionCell.identifier) as? SubscriptionCell else {
            return UITableViewCell()
        }

        if let subscription = subscription(for: indexPath) {
            cell.subscription = subscription
        }

        return cell
    }
}

extension SubscriptionsViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let subscription = subscription(for: indexPath) else { return }

        if let chatVC = ChatViewController.shared {
            chatVC.subscription = subscription
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SubscriptionCell else { return }
        guard let subscription = cell.subscription else { return }
        guard let selectedSubscription = ChatViewController.shared?.subscription else { return }
    }
}
