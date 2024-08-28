//
//  BarCodeScannerViewController.swift
//  Scanner
//
//  Created by Saurav on 27/08/24.
//

import UIKit
import ScanditBarcodeCapture
extension DataCaptureContext {
    // Enter your Scandit License key here.
    // Your Scandit License key is available via your Scandit SDK web account.
    private static let licenseKey = "AiZ0jih5DYo4IEiCpAUrc8gjCMd9Jv2Iqja6M6AlwCtaOnljbVv9/4hOCZdZd5re/FdRWmVUZu2oNbGLwkGNDZ0JCYRWdQENywqfVg0IQ33WF8aOZyJH5DYnZucvGSHzY/EHlk5blMXNKpLmJnuW1fH5jm5Yzh/QjOG+xIf4ciO8LCdg0bmW7bYOTeEOz2x2zwJPcKrXxyXceSXa3E0lATo4KWtJKU9bJ2w3VYS/ut4eqrOzCETX8lulZQAre8d8Lq4kvRmZYaeu1MhvjQWChE1DHq9+MI0TyZbFEHPu/lIvOzwHVUkMnJuJv7f5Mgj96ueJyLateTgMB/Il8XeqN2CMeCpn0mJ336GdVwi97CC0EvRGnek4IIr76GhaWEpTM4fSxtFmPHAxClGDizltonF6lNCvEZ2nkkwiuCneBu7dphEZeG0HOtGoZBe+o/0kBRJ2AhubmVTvXUmVoYUt9STzt84bNmQZl0S/BkxwYVnkMyOUvKnq/X3zsPgYNqZqlJk+cXBysADh6P7AKEbZoy4N7ztsfrU42VZ/Nlyj0uwdyaGmET0ZnnEA4v4kRA14tDgv4opDOTMAdVmyUYoqm7fqt3DyuafWmuBWVwVXZESNtGH6ff1XyvF7Hg4MMa8O9JyAkvoRAcHsHUDGCzbr7aD73kPOYXrwurCTYwWRD1FPjYyPTlY9LBp3rQj3xCNkXvbsSMcRJCTLi3ZjRUDfQwKBBGRRzUovpfMAR/cH1A7NFNbZ7pyEdFo3EJlgt7/X9Vsqjp1ZXn/E4oaJDxq13jfMGdAxI8U9ZDQnjQ=="

    // Get a licensed DataCaptureContext.
    static var licensed: DataCaptureContext {
        return DataCaptureContext(licenseKey: licenseKey)
    }
}

class BarCodeScannerViewController: UIViewController {

    private var context: DataCaptureContext!
    private var camera: Camera?
    private var barcodeCapture: BarcodeCapture!
    private var captureView: DataCaptureView!
    private var overlay: BarcodeCaptureOverlay!
    private let viewModel = BarCodeScannerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecognition()
        startScanning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        barcodeCapture.isEnabled = true
        camera?.switch(toDesiredState: .on)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        barcodeCapture.isEnabled = false
        camera?.switch(toDesiredState: .off)
    }

    private func setupRecognition() {
        context = DataCaptureContext.licensed

   
        camera = Camera(position: .userFacing)
        context.setFrameSource(camera, completionHandler: nil)

        let recommendedCameraSettings = BarcodeCapture.recommendedCameraSettings
        camera?.apply(recommendedCameraSettings)


        let settings = BarcodeCaptureSettings()

        settings.set(symbology: .ean13UPCA, enabled: true)
        settings.set(symbology: .ean8, enabled: true)
        settings.set(symbology: .upce, enabled: true)
        settings.set(symbology: .qr, enabled: true)
        settings.set(symbology: .dataMatrix, enabled: true)
        settings.set(symbology: .code39, enabled: true)
        settings.set(symbology: .code128, enabled: true)
        settings.set(symbology: .pdf417, enabled: true)
        settings.set(symbology: .interleavedTwoOfFive, enabled: true)

        let symbologySettings = settings.settings(for: .code39)
        symbologySettings.activeSymbolCounts = Set(7...20)

        barcodeCapture = BarcodeCapture(context: context, settings: settings)

        barcodeCapture.addListener(self)

        captureView = DataCaptureView(context: context, frame: view.bounds)
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(captureView)

        overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture, view: captureView, style: .frame)
        overlay.viewfinder = RectangularViewfinder(style: .square, lineStyle: .light)
    }
    
    private func startScanning() {
        viewModel.scanStartTime = Date()
    }
}

// MARK: - BarcodeCaptureListener

extension BarCodeScannerViewController: BarcodeCaptureListener {

    func barcodeCapture(_ barcodeCapture: BarcodeCapture,
                        didScanIn session: BarcodeCaptureSession,
                        frameData: FrameData) {
        guard let barcode = session.newlyRecognizedBarcode else {
            return
        }
        
        barcodeCapture.isEnabled = false
        
        if let startTime = viewModel.scanStartTime {
            // Calculate the time elapsed
            viewModel.timeElapsed = Date().timeIntervalSince(startTime)
            // Reset start time for the next scan (if you want to perform multiple scans)
            viewModel.scanStartTime = nil
        }
        
        viewModel.type = SymbologyDescription(symbology: barcode.symbology).readableName
        
        if let data = barcode.data {
            viewModel.barCode = data
        }
        
        viewModel.saveBarCodeInfo()
        
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
        
    }

}
 
