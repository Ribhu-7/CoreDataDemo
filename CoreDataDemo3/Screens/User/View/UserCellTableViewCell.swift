//
//  UserCellTableViewCell.swift
//  CoreDataDemo3
//
//  Created by Apple on 02/08/24.
//

import UIKit

class UserCellTableViewCell: UITableViewCell {

    @IBOutlet weak var tblImage: UIImageView!
    
    @IBOutlet weak var tblHead: UILabel!
    
    @IBOutlet weak var tblSubhead: UILabel!
    
    var user: UserEntity? {
        didSet{
            cellConfiguration()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tblImage.layer.cornerRadius = tblImage.frame.size.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfiguration(){
        guard let user else {return }
      
        tblHead.text = (user.firstname ?? "") + " " + (user.lastname ?? "")
        tblSubhead.text = "Email: \(user.emailID ?? "")"
        
        let imageURL = URL.documentsDirectory.appending(components: user.imageName ?? "").appendingPathExtension("png")
        tblImage.image = UIImage(contentsOfFile: imageURL.path)
        
        
        
        
    }
}
