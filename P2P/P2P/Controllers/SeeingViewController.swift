//
//  SeeingViewController.swift
//  P2P
//
//  Created by Roma Babajanyan on 17/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import UIKit
import CoreImage

class SeeingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = tableData.data[myIndex].image
        
        //Set up zooming
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 5.0
        
    }
    @IBAction func doneTapped(_ sender: Any) {
                dismiss(animated: true, completion: nil)
        
        // UNWIND TO SETUP
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let data = UIImageJPEGRepresentation(imageView.image!, 0.5){
            let filename = getDocumentsDirectory().appendingPathComponent("img.jpeg")
            try? data.write(to: filename)
        }
    }
    
    func getDocumentsDirectory() -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func editTapped(_ sender: Any){
        UIGraphicsBeginImageContext((imageView.image?.size)!)
        let context = UIGraphicsGetCurrentContext()
        
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        
        context?.move(to: <#T##CGPoint#>)
    }

}
