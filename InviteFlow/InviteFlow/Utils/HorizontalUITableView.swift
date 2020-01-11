import UIKit

class HorizontalUITableView: UITableView {
    let cellID: String! = "MCUI.HCellID"
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        let xOrigin = (frame.size.width - frame.size.height) / 2.0;
        let yOrigin = (frame.size.height - frame.size.width) / 2.0;
        self.frame = CGRect(x: xOrigin, y: yOrigin, width: frame.size.height, height: frame.size.width);
        self.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        self.scrollIndicatorInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: self.bounds.size.width-10);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
