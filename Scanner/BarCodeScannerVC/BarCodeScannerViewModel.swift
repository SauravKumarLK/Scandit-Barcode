//
//  BarCodeScannerViewModel.swift
//  Scanner
//
//  Created by Saurav on 28/08/24.
//

import Foundation

final class BarCodeScannerViewModel {
    var scanStartTime: Date?
    var timeElapsed: Double?
    var barCode: String?
    var type: String?
    
    func saveBarCodeInfo() {
        let info = CoreDataManager.shared.createEntity(ofType: BarcodeInfo.self)
        info.timeElapsed = timeElapsed ?? 0.0
        info.barcode = barCode
        info.type = type
        CoreDataManager.shared.saveContext()
    }
    
}
