import UIKit

class ToDoListTableViewCell: UITableViewCell {

    @IBOutlet var viewCell: UIView!
    @IBOutlet var textLabelCell: UILabel!
    @IBOutlet var imageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewCell.layer.cornerRadius = 5
        viewCell.layer.masksToBounds = true

        imageCell.layer.cornerRadius = imageCell.frame.size.width / 2
        imageCell.clipsToBounds = true
    }
    

}
