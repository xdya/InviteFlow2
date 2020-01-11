import UIKit

class ContactListViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var textAvatar: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var statusArea: UIView!
    @IBOutlet weak var statusAreaWidth: NSLayoutConstraint!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var avatarLeadingConstraint: NSLayoutConstraint!
    
    var indexPath: IndexPath?
    
    weak open var delegate: ContactListViewCellDelegate?
    
    @IBAction func onTapAdd(_ sender: Any) {
        delegate?.onTapAdd(indexPath: indexPath!)
    }
    
    func updateUI(contact: ContactData, state: SelectionState) {
        // TODO: Use different UILabel for company and title
        // TODO: [UI] Change the border color of email/company field
        // TODO: [UI] Add icon for email/company/title
        // YODO: [UI] Add seperator
        if (contact.type == .Rolo) {
            name.text = contact.name
            email.text = contact.company
        }
        else {
            name.text = contact.name
            email.text = contact.email
        }
        
        // TODO: Need modify the condition depending on the avatar showing mechanism
        if (contact.avatarUrl.count > 0) {
            avatar.isHidden = false
            textAvatar.isHidden = true
        }
        else {
            avatar.isHidden = true
            textAvatar.isHidden = false
            textAvatar.text = String(name.text?.first ?? " ")
            let color = getColor(num: contact.id.hashValue)
            textAvatar.textColor = color[.Text]
            textAvatar.backgroundColor = color[.Background]
        }
        
        if (state == .None) {
            statusArea.isHidden = true
            statusAreaWidth.constant = 0
            avatarLeadingConstraint.constant = 0
        }
        else {
            btnAdd.isHidden = state != .SingleMode
            imgCheck.isHidden = state == .SingleMode
            updateSelectUI(select: state == .Selected)
        }
    }
    
    func changeToSelect() -> Bool {
        let isChangeToSelect = !imgCheck.isHighlighted
        updateSelectUI(select: isChangeToSelect)
        return isChangeToSelect
    }
    
    func updateSelectUI(select: Bool) {
        imgCheck.isHighlighted = select
        backgroundColor = select ? UIColor(hex: 0x1895EB, alpha: 0.1) : UIColor.white
    }
    
    private func getColor(num: Int) -> [TextAvatarColor: UIColor] {
        // TODO: Border color
        switch num & 0x03 {
        case 0x00:
            return [.Background: UIColor.init(hex:0xFEEFCA, alpha:1.0),
                    .Text: UIColor.init(hex:0xFBA33D, alpha:1.0)]
        case 0x01:
            return [.Background: UIColor.init(hex:0xFFDFED, alpha:1.0),
                    .Text: UIColor.init(hex:0xF95CA1, alpha:1.0)]
        case 0x02:
            return [.Background: UIColor.init(hex:0xCAF4FF, alpha:1.0),
                    .Text: UIColor.init(hex:0x4ACFF1, alpha:1.0)]
        case 0x03:
            return [.Background: UIColor.init(hex:0xA4E9B3, alpha:1.0),
                    .Text: UIColor.init(hex:0x50B767, alpha:1.0)]
        default:
            return [.Background: UIColor.init(hex:0x000000, alpha:0.3),
                    .Text: UIColor.init(hex:0x000000, alpha:1.0)]
        }
    }
    
    private enum TextAvatarColor {
        case Background
        case Text
    }
    
    enum SelectionState {
        case Selected
        case Unselected
        case SingleMode
        case None
    }
}

public protocol ContactListViewCellDelegate : NSObjectProtocol {
    
    func onTapAdd(indexPath: IndexPath)
    
}
