//
//  FormImageCell.swift
//  SwiftFormsApplication
//
//  Created by 遂 李 on 7/13/15.
//  Copyright (c) 2015 Miguel Angel Ortuno Ortuno. All rights reserved.
//

public class FormImageCell: FormBaseCell {
    
    /// MARK: Cell views
    
    public var cameraView = UIImageView()
    
    public var attachmentView = UIView()
    
    public var imageCache = [String : UIImage]()
    
    public let titleLabel = UILabel()
    
    //public var showImage : UIImage?
    
    
    //public var selectedImages = [UIImage]()
    
    public override func configure() {
        super.configure()
        
        let showImage = UIImage(named: "camera.png") as UIImage?
        
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        // apply constant constraints
        attachmentView = UIView()
        
        cameraView = UIImageView(image: showImage)
        
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        cameraView.setTranslatesAutoresizingMaskIntoConstraints(false)
        attachmentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        

        cameraView.userInteractionEnabled = true
        cameraView.contentMode = UIViewContentMode.Right
        attachmentView.contentMode = UIViewContentMode.Center
     
        
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(attachmentView)
        
        contentView.addSubview(cameraView)
        
        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        
        
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 200))
        
          contentView.addConstraint(NSLayoutConstraint(item: attachmentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        
//        cameraView.backgroundColor = UIColor.lightGrayColor()
//        titleLabel.backgroundColor = UIColor.greenColor()
//        attachmentView.backgroundColor = UIColor.grayColor()
        
    }
    
    public override class func formRowCellHeight
        () -> CGFloat {
        return 100.0
    }
    
    //弹出选择菜单
    public class func generateAlertController(parentViewController : UIViewController, selectedRow : FormBaseCell) -> UIAlertController{
        
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //2
        let album = UIAlertAction(title: "从手机相册里面选择", style: UIAlertActionStyle.Default, handler: {
            (alert : UIAlertAction!) -> Void in
            
            let imagePicker = ImageSelectViewController()
            
            imagePicker.formCell = selectedRow
            
            imagePicker.showType = UIImagePickerControllerSourceType.PhotoLibrary
            
            parentViewController.presentViewController(imagePicker, animated: true){
                println("the image picker completed")
            }
            
        })
    
        let takephoto = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default, handler: {
            (alert : UIAlertAction!) -> Void in
            println("Take photo")
            
            let imagePicker = ImageSelectViewController()
            
            imagePicker.formCell = selectedRow
            
            imagePicker.showType = UIImagePickerControllerSourceType.Camera
            
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
        
        constraints.append("V:|[titleLabel(==44)]-1-[attachView]|")
        
        constraints.append("V:|[cameraView(==44)]-1-[attachView]|")
        
        constraints.append("H:|-15-[titleLabel]-50-[cameraView]-15-|")
        
        constraints.append("H:|-15-[attachView]-15-|")
        
        return constraints

    }
    
    public override func update() {
        super.update()
        
        titleLabel.text = rowDescriptor.title
        
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
        
//        println("needs display")
//        
//        contentView.setNeedsUpdateConstraints()
//
//        
//        contentView.setNeedsDisplay()
    
        
        
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
