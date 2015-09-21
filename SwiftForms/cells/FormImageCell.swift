//
//  FormImageCell.swift
//  SwiftFormsApplication
//
//  Created by 遂 李 on 7/13/15.
//  Copyright (c) 2015 Miguel Angel Ortuno Ortuno. All rights reserved.
//

public class FormImageCell: FormTitleCell {
    
    /// MARK: Cell views
    
    public var cameraView = UIImageView()
    
    public var attachmentView = UIView()
    
    public var imageCache = [String : UIImage]()
    
    
    //public var showImage : UIImage?
    /// MARK: FormBaseCell
    
    //public var selectedImages = [UIImage]()
    
    public override func configure() {
        super.configure()
        
        let showImage = UIImage(named: "camera.png") as UIImage?
        
//        let button : UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
//        
//        button.frame = CGRectMake(100, 100, 100, 100)
//        
//        button.setImage(image, forState: UIControlState.Normal)
//        
//        button.addTarget(self, action: "btnTouched", forControlEvents: UIControlEvents.TouchUpInside)
//        
        
        let attachImg = UIImage(named: "系统截图.png") as UIImage?
        
        //let attachImg = UIImage(named: "Camera-50.png") as UIImage?
        
        cameraView = UIImageView(image: showImage)
        
        // let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
        
       // cameraView.addGestureRecognizer(tapGesture)
        
       // cameraView.userInteractionEnabled = true
        
        
        //attachmentView = UIImageView(image: attachImg)
        
        attachmentView = UIView()
        
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        cameraView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        
        attachmentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        cameraView.userInteractionEnabled = true
        
        cameraView.contentMode = UIViewContentMode.Right
        
        attachmentView.contentMode = UIViewContentMode.Center
        
        //sliderView.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(attachmentView)
        
        contentView.addSubview(cameraView)
        
        
//        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: cameraView, attribute: .Top, multiplier: 1.0, constant: 0.0))
//        
//        
//        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Bottom, relatedBy: .Equal, toItem: attachmentView, attribute: .Top, multiplier: 1.0, constant: 8.0))
//        
//        
//        contentView.addConstraint(NSLayoutConstraint(item: attachmentView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 8.0))
        
//        contentView.addConstraint(NSLayoutConstraint(item: attachmentView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 0.5, constant: 0.0))
        
//        contentView.addConstraint(NSLayoutConstraint(item: attachmentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: cameraView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
//        
       
//         contentView.addConstraint(NSLayoutConstraint(item: cameraView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 25))
//        
//        
//        contentView.addConstraint(NSLayoutConstraint(item: cameraView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 30))
        
        
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40))
        
        contentView.addConstraint(NSLayoutConstraint(item: attachmentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 60))
        
//        cameraView.backgroundColor = UIColor.lightGrayColor()
//        titleLabel.backgroundColor = UIColor.greenColor()
//        attachmentView.backgroundColor = UIColor.grayColor()
        
    }
    
    public override class func formRowCellHeight() -> CGFloat {
        return 100.0
    }
    
    
    //弹出选择菜单
    public class func generateAlertController(parentViewController : UIViewController, selectedRow : FormBaseCell) -> UIAlertController{
        
        
        let optionMenu = UIAlertController(title: "option menu", message: "Choose Option", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        //2
        let album = UIAlertAction(title: "从手机相册里面选择", style: UIAlertActionStyle.Default, handler: {
            (alert : UIAlertAction!) -> Void in
            
            //let imageV = ImageSelectViewController()
            //let imageV = ImageSelectViewController(nibName: "ImageSelectViewController", bundle: nil)
            
//            let imagePicker = UIImagePickerController()
//            
//            imagePicker.allowsEditing = false
//            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
//            
//            if let selectViewController = parentViewController as? ImageSelectViewController{
//                    imagePicker.delegate = selectViewController
//            }
//            
            let imagePicker = ImageSelectViewController()
            
            imagePicker.formCell = selectedRow
            
            imagePicker.showType = UIImagePickerControllerSourceType.PhotoLibrary
            
            parentViewController.presentViewController(imagePicker, animated: true){
                println("the image picker completed")
            }
            
           // parentViewController.navigationController?.pushViewController(imagePicker, animated: true)
            
        })
    
        let takephoto = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default, handler: {
            (alert : UIAlertAction!) -> Void in
            println("Take photo")
            
            let imagePicker = ImageSelectViewController()
            
            imagePicker.formCell = selectedRow
            
            imagePicker.showType = UIImagePickerControllerSourceType.Camera
            
            
            //parentViewController.navigationController?.pushViewController(imageV, animated: true)
            
            parentViewController.presentViewController(imagePicker, animated: true){
                println("the image pcker completed")
            }
            
        })
    
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {
            (alert : UIAlertAction!) -> Void in
            
            println("cancelled")
            
            
        })
    
        optionMenu.addAction(album)
        
        optionMenu.addAction(takephoto)
        
        optionMenu.addAction(cancel)
        
        
        return optionMenu
    }
    
   
    
    public override func constraintsViews() -> [String : UIView] {
        
        return ["titleLabel" : titleLabel, "attachView" : attachmentView, "cameraView" : cameraView]
    }
    
    public override func defaultVisualConstraints() -> [String] {
        var constraints: [String] = []
        
        constraints.append("V:|[titleLabel]-0-[attachView]|")
       // constraints.append("V:|[attachView]|")
        
        constraints.append("V:|[cameraView]-0-[attachView]|")
        
        constraints.append("H:|-15-[titleLabel(>=100)]-[cameraView]-15-|")

        constraints.append("H:|-15-[attachView]-15-|")
        
        return constraints

    }
    
    public override func update() {
        super.update()
        
         titleLabel.text = rowDescriptor.title
        
        //reset attachmentView
        
        let subViews = attachmentView.subviews
        
        
        for subview in subViews{
            
            println("subview is \(subview)")
            
            if let _ = subview as? UIImageView{
                println("is imageview")
                subview.removeFromSuperview()
            }else{
                println("this is not iamgeView \(subview)")
            }
           
        }
        
        if rowDescriptor.value != nil {
            if let selectedImages = rowDescriptor.value as? [NSObject]{
                
                for var i = 0 ; i < selectedImages.count ; ++i {
                    //let row = i / 2
                    //let col = i % 2
                    
                    //let x  = CGFloat(row) * 60.0
                    //let y  = CGFloat(col) * 60.0
                    let x = CGFloat(i) * 60
                    let y = CGFloat(0)
                    var newImageView = UIImageView(frame: CGRectMake(x, y, 50, 50))
                    
                    newImageView.userInteractionEnabled = true
                    
                    var imageTapRecognizer = UITapGestureRecognizer(target: self, action: "imageShowTapped:")
                    
                    newImageView.addGestureRecognizer(imageTapRecognizer)
                    
                    if let localImage = selectedImages[i] as? UIImage {
                        
                        newImageView.image = localImage
                    
                    }else{
                        
                        if let remoteImageURL = selectedImages[i] as? String{
                            
                            println("this is remote image, need download " + "http://oss-cn-beijing.aliyuncs.com" + remoteImageURL)
                            
                            let imageURL = NSURL(string: "http://oss-cn-beijing.aliyuncs.com" + remoteImageURL)
                            
                            //cache, 从远程获取
                            let request : NSURLRequest = NSURLRequest(URL: imageURL!)
                            
                            let mainQueue = NSOperationQueue.mainQueue()
                            
                            newImageView.image = UIImage(named: "camera.png")
                            
                            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler : {
                                (response, data, error) in
                                if error == nil {
                                    
                                    let image = UIImage(data: data)
                                    
                                    self.imageCache[remoteImageURL] = image
                                    
                                    //How to update the cell?
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        println("更新下载后的图片.....")
                                        
                                        newImageView.image = image
                                    
                                    })
                                }else{
                                    
                                    println("下载图片发生错误")
                                    
                                }
                            })
                        }
                        
                    }
                    
                    attachmentView.addSubview(newImageView)
                    
                    
                }
           }
        }
        
    
    }
    
    
    public func imageShowTapped(recognizer : UITapGestureRecognizer){
        
        println("the image is clicked")
        
        var imageShower = ImageShowViewController(nibName: "ImageShowViewController", bundle: NSBundle(forClass: ImageShowViewController.classForCoder()))
       
        println(recognizer.view)
        
        imageShower.formCell = self
        
        if let imageView = recognizer.view as? UIImageView{
            
            if let selectedImages = self.rowDescriptor.value as? [UIImage]{
                imageShower.selectedImageList = selectedImages
                
                imageShower.selectedImage = imageView.image
                
            }
        }
        
        //imageShower.selectedImageList = self.selectedImages
        
        println(self.formViewController)
        
        self.formViewController!.presentViewController(imageShower, animated: true, completion: nil)
    
        
    }
    
    public  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            println("the picked image is \(pickedImage)")
            
            imageView?.contentMode = .ScaleAspectFit
            imageView!.image = pickedImage
            
        }
    
    }
    
    public override class func formViewController(formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {

        if let row = selectedRow as? FormImageCell {
            
            formViewController.view.endEditing(true)
            
            var selectorClass: UIViewController.Type!
            
            if let selectorControllerClass: AnyClass = row.rowDescriptor.configuration[FormRowDescriptor.Configuration.SelectorControllerClass] as? AnyClass {
                selectorClass = selectorControllerClass as? UIViewController.Type
            }
            else { // fallback to default cell class
                selectorClass = ImageViewController.self
            }
            
            if selectorClass != nil {
                println("the selectorClass is \(selectorClass)")
                
                let selectorController = selectorClass()
                
                let v = generateAlertController(formViewController, selectedRow: row)
//                
                formViewController.presentViewController(v, animated: true){
                    
                    println("the select completed")
                    
                }
                
                
//                if let formRowDescriptorViewController = selectorController as? FormSelector {
//                    formRowDescriptorViewController.formCell = row
//                    formViewController.navigationController?.pushViewController(selectorController, animated: true)
//                }
//                else {
//                    fatalError("FormRowDescriptor.Configuration.SelectorControllerClass must conform to FormSelector protocol.")
//                }
            }else{
                println("the sectorClass is null")
            }
        }
    }
    
    
   
    
}
