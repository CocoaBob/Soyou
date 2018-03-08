//
//  CircleSettingsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-03-06.
//  Copyright © 2018 Soyou. All rights reserved.
//

class CircleSettingsViewController: UIViewController {
    
    // Properties
    @IBOutlet var tableView: UITableView!
    
    var userID: Int = -1
    var isInvisibleToHim = false
    var isInvisibleToMe = false
    
    var completionHandler: ((_ isInvisibleToHim: Bool, _ isInvisibleToMe: Bool)->())?
    
    // Class methods
    class func instantiate() -> CircleSettingsViewController {
        return  UIStoryboard(name: "CirclesViewController", bundle: nil).instantiateViewController(withIdentifier: "CircleSettingsViewController") as! CircleSettingsViewController
    }
    
    // Life Cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Titles
        self.title = NSLocalizedString("circle_settings_vc_title")
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, true, true, false, false)
        
        // Setup Table
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Nav bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Workaround to make sure navigation bar is updated even the slide-back gesture is cancelled.
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CircleSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfRows() -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CircleSettingsTableViewCell", for: indexPath)
        if let cell = cell as? CircleSettingsTableViewCell {
            if indexPath.row == 0 {
                cell.lblTitle.text = NSLocalizedString("circle_settings_vc_is_invisible_to_him")
                cell.aSwitch.isOn = isInvisibleToHim
            } else if indexPath.row == 1 {
                cell.lblTitle.text = NSLocalizedString("circle_settings_vc_is_invisible_to_me")
                cell.aSwitch.isOn = isInvisibleToMe
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

// MARK: - Actions
extension CircleSettingsViewController {
    
    @IBAction func toggleSwitch(_ aSwitch: UISwitch) {
        guard let indexPath = self.tableView.indexPathForRow(at: self.tableView.convert(aSwitch.bounds.origin, from: aSwitch)) else {
            return
        }
        if indexPath.row == 0 {
            isInvisibleToHim = aSwitch.isOn
        } else if indexPath.row == 1 {
            isInvisibleToMe = aSwitch.isOn
        }
    }
    
    @IBAction func done() {
        MBProgressHUD.show(self.view)
        DataManager.shared.blockUser(self.userID, self.isInvisibleToHim, self.isInvisibleToMe) { (responseObject, error) in
            MBProgressHUD.hide(self.view)
            if error == nil {
                self.completionHandler?(self.isInvisibleToHim, self.isInvisibleToMe)
                self.dismissSelf()
            }
        }
    }
}

// MARK: - CircleVisibilityTagTableViewCell
class CircleSettingsTableViewCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var aSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        self.separatorInset = UIEdgeInsets.zero
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblTitle.text = nil
        self.aSwitch.isOn = false
    }
}
