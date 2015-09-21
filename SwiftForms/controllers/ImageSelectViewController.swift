//
//  ImageSelectViewController.swift
//  SwiftFormsApplication
//
//  Created by 遂 李 on 7/16/15.
//  Copyright (c) 2015 Miguel Angel Ortuno Ortuno. All rights reserved.
//

import UIKit

public class ImageSelectViewController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public var formCell: FormBaseCell!
    
    @IBOutlet weak var imageView: UIImageView!
    
    //let imagePicker = UIImagePickerController()
    
    var showType : UIImagePickerControllerSourceType?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
      
        self.allowsEditing = false
        self.sourceType = showType!
        
        self.delegate = self
        
        
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        
//        imagePicker.delegate = self
        
        

    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            println("selected image is \(pickedImage)")
            
            if let imageCell = formCell as? FormImageCell{
               
                if imageCell.rowDescriptor.value == nil {
                    
                   // println(info[UIImagePickerControllerMediaURL])
                    
                    imageCell.rowDescriptor.value = ([pickedImage] as [NSObject])
                    
                }else{
                   
                    if var casted = imageCell.rowDescriptor.value as? [NSObject]{
                        casted.append(pickedImage)
                        
                        imageCell.rowDescriptor.value = casted
                    }
                    
                }

                
               imageCell.update()
            }
            
            dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
   
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        if let pickedImage = editingInfo[UIImagePickerControllerOriginalImage] as? UIImage{
            
            println("the selected Image is \(imageView)")
            
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }

   
}
