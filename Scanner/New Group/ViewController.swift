//
//  ViewController.swift
//  Scanner
//
//  Created by Saurav on 27/08/24.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var barCodeInfo: [BarcodeInfo] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func registerCell() {
        let nib = UINib(nibName: "BarCodeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "BarCodeTableViewCell")
    }
    
    @IBAction func clear(_ sender: Any) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Are you sure you want to delete?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                CoreDataManager.shared.deleteAllEntities(ofType: BarcodeInfo.self)
                self?.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedOnScanButton(_ sender: UIButton) {
        let barcodeVC = BarCodeScannerViewController()
        barcodeVC.modalPresentationStyle = .fullScreen
        self.present(barcodeVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barCodeInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BarCodeTableViewCell", for: indexPath) as? BarCodeTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: barCodeInfo[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
}

extension ViewController {
    func fetchData() {
        barCodeInfo = CoreDataManager.shared.fetchEntities(ofType: BarcodeInfo.self)
        self.tableView.reloadData()
    }
}


