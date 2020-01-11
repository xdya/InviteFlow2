import UIKit

class ContactListViewHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var btnMultiSelect: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnInvite: UIButton!
    
    var section: Int!
    
    weak open var delegate: ContactListViewHeaderDelegate?
    
    @IBAction func onTapMultiSelect(_ sender: Any) {
        delegate?.onTapMultiSelect(section: section)
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        delegate?.onTapCancel()
    }
    
    @IBAction func onTapInvite(_ sender: Any) {
        delegate?.onTapInvite()
        
    }
}

public protocol ContactListViewHeaderDelegate : NSObjectProtocol {
    
    func onTapMultiSelect(section: Int)
    func onTapCancel()
    func onTapInvite()

}
