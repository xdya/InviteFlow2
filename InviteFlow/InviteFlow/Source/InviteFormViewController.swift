import UIKit

class InviteFormViewController: UIViewController {

    @IBOutlet weak var backdropView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var invitationText: UITextView!
    
    // TODO: Handle input text in invitationText (calculate number of characters and set limitation) (shake invitationText when reach the limit)
    // TODO: [UI] Border color of invitationText
    
    var contactTableView: HorizontalUITableView!
    
    var selectedContact: [ContactData]!
    
    let menuHeight = UIScreen.main.bounds.width
    var isPresenting = false
    var isInvitationSent = false

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.translatesAutoresizingMaskIntoConstraints = false
        setupTableView()
        setupUIString()
        setupObserver()
        setupGesture()
    }
    
    private func setupTableView() {
        // TRICKY: Cacultae width here because cannot know the width of tableViewContainer in viewDidLoad
        contactTableView = HorizontalUITableView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: tableViewContainer.frame.height), style: .plain)
        contactTableView.register(UINib(nibName: "ContactListViewCell", bundle: nil), forCellReuseIdentifier: "ContactListViewCell")
        contactTableView.separatorStyle = .none
        contactTableView.dataSource = self
        contactTableView.delegate = self
        contactTableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewContainer.addSubview(contactTableView)
    }
    
    private func setupUIString() {
        titleLabel.text = "Invite \(selectedContact.count) contacts"
        btnSend.setTitle("Send \(selectedContact.count) invitations", for: .normal)
        btnSend.setTitle("Sending \(selectedContact.count) invitations...", for: .disabled)
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(InviteFormViewController.handleDismiss(_:)))
        backdropView.addGestureRecognizer(tapGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(InviteFormViewController.handleDismiss(_:)))
        swipeDownGesture.direction = .down
        menuView.addGestureRecognizer(swipeDownGesture)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // FIXME: The bottom constraint of btnSend may be wrong sometimes.
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    @objc func handleDismiss(_ sender: UITapGestureRecognizer?) {
        if (invitationText.isFirstResponder) {
            invitationText.resignFirstResponder()
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        handleDismiss(nil)
    }
    
    @IBAction func onTapSend(_ sender: Any) {
        if (isInvitationSent) {
            handleDismiss(nil)
        }
        else {
            // TODO: Adjust position of activityIndicator
            activityIndicator.isHidden = false
            transparentView.isHidden = false
            btnSend.isEnabled = false
            btnSend.backgroundColor = UIColor(hex: 0xF1F3F7, alpha: 1)
            invitationText.isEditable = false
            // TODO: Use actual API call and use weak reference if needed
            DispatchQueue.global().async {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.btnSend.setTitle("Sent \(self.selectedContact.count) invitations!", for: .normal)
                    self.btnSend.isEnabled = true
                    self.btnSend.backgroundColor = UIColor(hex: 0x6ED463, alpha: 1)
                    self.activityIndicator.isHidden = true
                    self.transparentView.isHidden = true
                    self.isInvitationSent = true
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension InviteFormViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return selectedContact.count > 1 ? 163 : tableViewContainer.bounds.width
    }
}

// MARK: - UITableViewDataSource

extension InviteFormViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedContact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListViewCell") as! ContactListViewCell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        
        let contact = selectedContact[indexPath.row]
        cell.updateUI(contact: contact, state: .None)

        return cell
    }
}

// MARK: - Transitioning

extension InviteFormViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        toViewController?.view.frame = containerView.frame
        guard let toVC = toViewController else { return }
        
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)

            menuView.frame.origin.y += menuHeight
            backdropView.alpha = 0

            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
        else {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
