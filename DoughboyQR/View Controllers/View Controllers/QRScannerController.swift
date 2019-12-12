import UIKit
import AVFoundation
import AudioToolbox

class QRScannerController: UIViewController {
  
  var viewModel: ViewModel? = nil
  var isCorrect: Bool = true
  var target: Int = 0
  
  func updateTarget() {
    self.target = self.viewModel!.rounds[self.viewModel!.currentRound][0] + 1
    self.title = String(self.target)
    print(self.viewModel!.currentRound)
  }
  
  // MARK: QR Scanner
  var captureSession = AVCaptureSession()
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  var qrCodeFrameView: UIView?
  
  private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                    AVMetadataObject.ObjectType.code39,
                                    AVMetadataObject.ObjectType.code39Mod43,
                                    AVMetadataObject.ObjectType.code93,
                                    AVMetadataObject.ObjectType.code128,
                                    AVMetadataObject.ObjectType.ean8,
                                    AVMetadataObject.ObjectType.ean13,
                                    AVMetadataObject.ObjectType.aztec,
                                    AVMetadataObject.ObjectType.pdf417,
                                    AVMetadataObject.ObjectType.itf14,
                                    AVMetadataObject.ObjectType.dataMatrix,
                                    AVMetadataObject.ObjectType.interleaved2of5,
                                    AVMetadataObject.ObjectType.qr]
  
  override func viewDidAppear(_ animated: Bool) {
    self.updateTarget()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.hidesBackButton = true
    guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
      print("Failed to get the camera device")
      return
    }
    
    do {
      let input = try AVCaptureDeviceInput(device: captureDevice)
      captureSession.addInput(input)
      
      let captureMetadataOutput = AVCaptureMetadataOutput()
      captureSession.addOutput(captureMetadataOutput)
      
      captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
    } catch {
      print(error)
      return
    }
    
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
    videoPreviewLayer?.frame = view.layer.bounds
    view.layer.addSublayer(videoPreviewLayer!)
    
    captureSession.startRunning()
    qrCodeFrameView = UIView()
    
    if let qrCodeFrameView = qrCodeFrameView {
      qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
      qrCodeFrameView.layer.borderWidth = 2
      view.addSubview(qrCodeFrameView)
      view.bringSubviewToFront(qrCodeFrameView)
    }
  }
  
  private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
    layer.videoOrientation = orientation
    videoPreviewLayer?.frame = self.view.bounds
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let coreMotionVC: CoreMotionController = segue.destination as? CoreMotionController {
      coreMotionVC.previousStepCorrect = self.isCorrect
      coreMotionVC.viewModel = self.viewModel
    }
  }
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    if metadataObjects.count == 0 {
      qrCodeFrameView?.frame = CGRect.zero
      return
    }
    let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
    
    if supportedCodeTypes.contains(metadataObj.type) {
      // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
      let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
      qrCodeFrameView?.frame = barCodeObject!.bounds
      
      if metadataObj.stringValue != nil {
        if metadataObj.stringValue! == String(self.target) {
          if let _: QRScannerController = self.navigationController?.viewControllers.last as? QRScannerController {
            // Vibration
             AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.isCorrect = true
            performSegue(withIdentifier: "qrConfirmed", sender: self)
          }
        }
        else {
          // Vibration
           AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
          self.isCorrect = false
          performSegue(withIdentifier: "qrConfirmed", sender: self)
        }
      }
    }
  }
}
