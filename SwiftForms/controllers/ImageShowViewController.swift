//
//  ImageShowViewController.swift
//  SwiftFormsApplication
//
//  Created by 遂 李 on 7/21/15.
//  Copyright (c) 2015 Miguel Angel Ortuno Ortuno. All rights reserved.
//

import UIKit

class ImageShowViewController: UIViewController, UIScrollViewDelegate{

    var selectedImageList = [UIImage]()
    
    var selectedImage : UIImage?
    
    var imageView : UIImageView!
    
    var formCell : FormBaseCell?
    
    @IBOutlet weak var scrollView: UIScrollView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        if selectedImage?.size.width > displayImageView.frame.width{
//            selectedImage?.size.width = displayImageView.frame.width
//        }
//        
//        if selectedImage.size.height  > displayImageView.frame.height{
//            selectedImage!.size.height = displayImageView.frame.height
//        }
        
        imageView = UIImageView(image: selectedImage)
        
//        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: scrollView.frame.size)
        
        scrollView.addSubview(imageView)
        
        //let containerSize = selectedImage!.size
        let containerSize = scrollView.bounds.size
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        imageView.frame.size = containerSize
        

        
        //tell the scroll view the size of the contents
        
//        scrollView.contentSize = containerSize
//        
//        //setup the minimum & maximum zoom scales
//        let scrollViewFrame = scrollView.frame
//        
//        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
//        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
//        
//        
//        let minScale = min(scaleWidth, scaleHeight)
//        
//        println("the minScale is \(minScale)")
//        
//        scrollView.minimumZoomScale = minScale
//        scrollView.maximumZoomScale = 1.0
//        
//        scrollView.zoomScale = minScale
//        
        
    }
    
    @IBAction func deleteImage(sender: AnyObject) {
        for var index = 0 ; index < selectedImageList.count ; ++index {
            if selectedImage == selectedImageList[index] {
                println("should remove the image \(index)")
                selectedImageList.removeAtIndex(index)
                
                println("after deleted \(selectedImageList)")
                
                if let imageCell = formCell as? FormImageCell{
                    
                    //imageCell.formselectedImages.removeAtIndex(index)
                    
                    imageCell.rowDescriptor.value = nil
                    
                    imageCell.update()
                    
                    dismissViewControllerAnimated(true, completion: nil)
                    
                }

            }
        }
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @IBAction func closeShower(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        println("zoommmm..")
        
        return imageView
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
