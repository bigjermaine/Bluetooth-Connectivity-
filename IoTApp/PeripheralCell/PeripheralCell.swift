//
//  PeripheralCell.swift
//  IoTApp
//
//  Created by Daniel Jermaine on 08/08/2024.
//

import UIKit

class PeripheralCell: UITableViewCell {
    @IBOutlet weak var peripheralNameLbl: UILabel!
    
    @IBOutlet weak var statusLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
