import UIKit
import AVFoundation

class ScanViewController: UIViewController {
    
    var mainView: ScanView {
        return view as! ScanView
    }
    
    private var captureSession: AVCaptureSession = .init()
    private var cameraDeviceInput: AVCaptureDeviceInput!
    private var isBlindViewHidden: Bool = false
    
    private let selectionFeedback: UISelectionFeedbackGenerator = .init()
    private let notificationFeedback: UINotificationFeedbackGenerator = .init()
    
    private let scanQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).scanQueue")
    
    override func loadView() {
        view = ScanView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        mainView.flashButton.addTarget(self, action: #selector(flashButtonTapped), for: .touchUpInside)
        
        setupCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                
            }
        }
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func flashButtonTapped() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                device.torchMode = device.torchMode == .on ? .off : .on
                mainView.toggleFlashButton(isOn: device.torchMode == .on)
                
                if device.torchMode == .on   {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                } else {
                    selectionFeedback.selectionChanged()
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    // MARK: - Private methods
    
    private func setupCamera() {
        scanQueue.async {
            guard let device =  AVCaptureDevice.default(for: .video) else { return }
            
            self.captureSession.beginConfiguration()
                    
            do {
                let input = try AVCaptureDeviceInput(device: device)
                self.captureSession.addInput(input)
                self.cameraDeviceInput = input
            } catch {
                print(error)
                return
            }
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            output.setSampleBufferDelegate(self, queue: .main)
            self.captureSession.addOutput(output)
            
            
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    
    private func getImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) ->UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        guard let cgImage = context.makeImage() else {
            return nil
        }
        let image = UIImage(cgImage: cgImage, scale: 1, orientation:.right)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        return image
    }
    
    private func hideBlindViewIfNeeded() {
        if !isBlindViewHidden {
            isBlindViewHidden = true
            
            UIView.animate(withDuration: 0.6) {
                self.mainView.blindView.alpha = 0
            }
        }
    }
}

// MARK: - SampleBufferDelegate

extension ScanViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard
            let outputImage = getImageFromSampleBuffer(sampleBuffer: sampleBuffer)
        else {
            return
        }
        
        mainView.frameImageView.image = outputImage
        hideBlindViewIfNeeded()
    }
}
