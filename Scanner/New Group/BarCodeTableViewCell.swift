//
//  BarCodeTableViewCell.swift
//  Scanner
//
//  Created by Saurav on 28/08/24.
//

import UIKit

class BarCodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var codeLable: UILabel!
    @IBOutlet weak var timeElapsed: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with barcodeInfo: BarcodeInfo) {
        codeLable.text = "\(barcodeInfo.type ?? ""): \(barcodeInfo.barcode ?? "")"
        timeElapsed.text = String(format: "%.2f", barcodeInfo.timeElapsed) + " Seconds"
    }
}
