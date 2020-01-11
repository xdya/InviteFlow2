import UIKit

class ContactListViewController: UIViewController {
    
    @IBOutlet weak var contactTableView: UITableView!
    
    var multiSelectSection: Int = -1
    var sectionTitle: [String] = [NSLocalizedString("Contacts on Rolo", comment: ""), NSLocalizedString("Others", comment: "")]
    var contactDataSource: [[ContactData]] = []
    var selectedContact: [ContactData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initContactData()
        setupTableView()
    }
    
    private func setupTableView() {
        contactTableView.register(UINib(nibName: "ContactListViewCell", bundle: nil), forCellReuseIdentifier: "ContactListViewCell")
        contactTableView.register(UINib(nibName: "ContactListViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ContactListViewHeader")
        contactTableView.separatorStyle = .none
    }
    
    private func initContactData() {
        // TODO: Get the actual data
        contactDataSource.append([])
        contactDataSource.append([])
        for index in 1...4 {
            var id = String(index + 100)
            contactDataSource[0].append(ContactData(id: id,
                                                    type: .Rolo,
                                                    name: "🐬P" + id + " Alisa 🌸🌺🐱🦊🐼🐯🦁🐈🐾🐠🐟🐬",
                                                    email: id + "awjepgoaij@ajsdp.com",
                                                    company: "У этого термина существуют ",
                                                    title: "تنقسم المحافظة إلى مراكز ترتبط إداريًا بالمحافظة ",
                                                    avatarUrl: ""))
            id = String(index + 200)
            contactDataSource[0].append(ContactData(id: id,
                                                    type: .Other,
                                                    name: "M" + id + " Alisa 🌸🌺🐱🦊🐼🐯🦁🐈🐾🐠🐟🐬",
                                                    email: id + "awjepgoaij@ajsdp.com",
                                                    company: "У этого термина существуют ",
                                                    title: "تنقسم المحافظة إلى مراكز ترتبط إداريًا بالمحافظة ",
                                                    avatarUrl: ""))
            id = String(index + 300)
            contactDataSource[1].append(ContactData(id: id,
                                                    type: .Other,
                                                    name: "🐼R" + id + " Alisa 🌸🌺🐱🦊🐼🐯🦁🐈🐾🐠🐟🐬",
                                                    email: id + "awjepgoaij@ajsdp.com",
                                                    company: "У этого термина существуют ",
                                                    title: "تنقسم المحافظة إلى مراكز ترتبط إداريًا بالمحافظة ",
                                                    avatarUrl: ""))
            id = String(index + 400)
            contactDataSource[1].append(ContactData(id: id,
                                                    type: .Other,
                                                    name: "R" + id + " Alisa 🌸🌺🐱🦊🐼🐯🦁🐈🐾🐠🐟🐬",
                                                    email: id + "awjepgoaij@ajsdp.com",
                                                    company: "У этого термина существуют ",
                                                    title: "تنقسم المحافظة إلى مراكز ترتبط إداريًا بالمحافظة ",
                                                    avatarUrl: ""))
            id = String(index + 500)
            contactDataSource[1].append(ContactData(id: id,
                                                    type: .Other,
                                                    name: "P" + id + " Alisa 🌸🌺🐱🦊🐼🐯🦁🐈🐾🐠🐟🐬",
                                                    email: id + "awjepgoaij@ajsdp.com",
                                                    company: "У этого термина существуют ",
                                                    title: "تنقسم المحافظة إلى مراكز ترتبط إداريًا بالمحافظة ",
                                                    avatarUrl: ""))
        }
    }
}

// MARK: - UITableViewDelegate

extension ContactListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return contactDataSource[section].count > 0 ? 32 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let isMultiSelect: Bool = multiSelectSection == section
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContactListViewHeader") as! ContactListViewHeader
        // FIXME: [TableView] Setting the background color on UITableViewHeaderFooterView has been deprecated. Please set a custom UIView with your desired background color to the backgroundView property instead.
        headerView.contentView.backgroundColor = UIColor.init(hex:0xF1F3F7, alpha: 1)
        headerView.section = section
        headerView.delegate = self
        
        headerView.sectionTitle.text = getHeaderString(section: section, isMultiMode: multiSelectSection == section)
        
        headerView.btnMultiSelect.isHidden = isMultiSelect
        headerView.btnCancel.isHidden = !isMultiSelect
        headerView.btnInvite.isHidden = !isMultiSelect
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (multiSelectSection == indexPath.section) {
            if ((tableView.cellForRow(at: indexPath) as! ContactListViewCell).changeToSelect()) {
                selectedContact.append(contactDataSource[indexPath.section][indexPath.row])
            }
            else {
                selectedContact.removeAll { (contact: ContactData) -> Bool in
                    return contact.id == contactDataSource[indexPath.section][indexPath.row].id
                }
            }
            let headerView = tableView.headerView(forSection: indexPath.section) as! ContactListViewHeader
            headerView.sectionTitle.text = getHeaderString(section: indexPath.section, isMultiMode: true)
        }
    }
    
    private func getHeaderString(section: Int, isMultiMode multiMode: Bool) -> String {
        if (multiMode) {
            return String(format: NSLocalizedString("%d contacts selected", comment: ""), selectedContact.count)
        }
        return sectionTitle[section]
    }
}

// MARK: - UITableViewDataSource

extension ContactListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isMultiSelect: Bool = multiSelectSection == indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListViewCell") as! ContactListViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.selectionStyle = .none
        
        let contact = contactDataSource[indexPath.section][indexPath.row]
        var state : ContactListViewCell.SelectionState = .SingleMode
        if (isMultiSelect) {
            let select = selectedContact.contains { (data: ContactData) -> Bool in
                return data.id == contact.id
            }
            state = select ? .Selected : .Unselected
        }
        cell.updateUI(contact: contact, state: state)
        
        return cell
    }
}

// MARK: - ContactListViewHeaderDelegate

extension ContactListViewController: ContactListViewHeaderDelegate {
    
    func onTapMultiSelect(section: Int) {
        selectedContact.removeAll()
        let oldMultiSelectSection = multiSelectSection
        multiSelectSection = section
        if (oldMultiSelectSection != -1) {
            contactTableView.reloadSections([oldMultiSelectSection], with: .none)
        }
        contactTableView.reloadSections([section], with: .none)
    }
    
    func onTapCancel() {
        selectedContact.removeAll()
        let oldMultiSelectSection = multiSelectSection
        multiSelectSection = -1
        if (oldMultiSelectSection != -1) {
            contactTableView.reloadSections([oldMultiSelectSection], with: .none)
        }
    }
    
    func onTapInvite() {
        if (selectedContact.count > 0) {
            let viewController = InviteFormViewController()
            viewController.selectedContact = selectedContact
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

// MARK: - ContactListViewHeaderDelegate

extension ContactListViewController: ContactListViewCellDelegate {
    func onTapAdd(indexPath: IndexPath) {
        onTapCancel()
        selectedContact.append(contactDataSource[indexPath.section][indexPath.row])
        onTapInvite()
    }
}

// MARK: - ContactCellData

struct ContactData {
    var id: String
    var type: ContactType
    var name: String
    var email: String
    var company: String
    var title: String
    var avatarUrl: String
}

// MARK: - Others

enum ContactType {
    case Rolo
    case Other
}
