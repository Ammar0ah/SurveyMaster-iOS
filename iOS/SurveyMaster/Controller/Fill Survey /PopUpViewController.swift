//
//  PopUpViewController.swift
//  SurveyMaster
//
//  Created by Ammar Al-Helali on 7/20/19.
//  Copyright © 2019 Ammar Al-Helali. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    var SurveyID : String!
    @IBOutlet var qrImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        let myString = "http://192.168.1.1:5000/fill/" + SurveyID
        // 2
        let data = myString.data(using: String.Encoding.ascii)
        // 3
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        // 4
        qrFilter.setValue(data, forKey: "inputMessage")
        // 5
        guard let qrImage = qrFilter.outputImage else { return }
        let context = CIContext()
        guard let cgImage = context.createCGImage(qrImage, from: qrImage.extent) else { return }
        let processedImage = UIImage(cgImage: cgImage)
        qrImageView.image = processedImage
        // Do any additional setup after loading the view.
    }
    @IBAction func doneClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
