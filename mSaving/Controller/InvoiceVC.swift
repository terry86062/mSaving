//
//  InvoiceVC.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/21.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

import AVFoundation

class InvoiceVC: UIViewController {
    
    @IBOutlet weak var messageLabel:UILabel!

    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var qrCodeFrameView: UIView?
    
    // Added to support different barcodes
    let supportedBarCodes = [
        AVMetadataObject.ObjectType.qr,
        AVMetadataObject.ObjectType.code128,
        AVMetadataObject.ObjectType.code39,
        AVMetadataObject.ObjectType.code93,
        AVMetadataObject.ObjectType.upce,
        AVMetadataObject.ObjectType.pdf417,
        AVMetadataObject.ObjectType.ean13,
        AVMetadataObject.ObjectType.aztec
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpCaptureSession()
        
    }
    
    func setUpCaptureSession() {
        
//        // 取得後置鏡頭來擷取影片
//        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
//
//        guard let captureDevice = deviceDiscoverySession.devices.first else {
//            print("Failed to get the camera device")
//            return
//        }
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        do {
            // 使用前一個裝置物件來取得 AVCaptureDeviceInput 類別的實例
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // 在擷取 session 設定輸入裝置
            captureSession.addInput(input)
            
            // 初始化一個 AVCaptureMetadataOutput 物件並將其設定做為擷取 session 的輸出裝置
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // 設定委派並使用預設的調度佇列來執行回呼（call back）
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // 初始化影片預覽層，並將其作為子層加入 viewPreview 視圖的圖層中
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // 開始影片的擷取
            captureSession.startRunning()
            
            //移動訊息標籤與頂部列至上層
            view.bringSubviewToFront(messageLabel)
//            view.bringSubview(toFront: topbar)
            
            // 初始化 QR Code 框來突顯 QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            // 假如有錯誤產生、單純輸出其狀況不再繼續執行
            print(error)
            return
        }
        
    }

}

extension InvoiceVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // 檢查  metadataObjects 陣列為非空值，它至少需包含一個物件
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // 取得元資料（metadata）物件
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { return }
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // 倘若發現的元資料與 QR code 元資料相同，便更新狀態標籤的文字並設定邊界
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
}
