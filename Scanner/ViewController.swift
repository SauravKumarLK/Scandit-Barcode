//
//  ViewController.swift
//  Scanner
//
//  Created by Saurav on 27/08/24.
//
import UIKit

class ViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func tappedOnScanButton(_ sender: UIButton) {
        let barcodeVC = BarCodeScannerViewController()
        self.present(barcodeVC, animated: true)
    }
}



