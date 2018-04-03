//
//  SubscriptionsViewController.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 7/21/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import RealmSwift

// swiftlint:disable file_length
public final class SubscriptionsViewController: UIViewController {
    
    // Class methods
    public static var shared: SubscriptionsViewController? {
        return UIStoryboard(name: "Subscriptions", bundle: Bundle(for: self)).instantiateViewController(withIdentifier: "SubscriptionsViewController") as? SubscriptionsViewController
    }

    @IBOutlet weak var tableView: UITableView!

    var assigned = false
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
        guard !assigned else { return }
        guard let auth = AuthManager.isAuthenticated() else { return }
        assigned = true
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

    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
        return indexPath
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

        if subscription.identifier == selectedSubscription.identifier {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}
