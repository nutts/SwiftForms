//
//  FormViewController.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuño on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit
import SwiftForms

public class FormViewController : UITableViewController {

    /// MARK: Types
    
    private struct Static {
        static var onceDefaultCellClass: dispatch_once_t = 0
        static var defaultCellClasses: [FormRowType : FormBaseCell.Type] = [:]
    }
    
    /// MARK: Properties
    
    public var form: FormDescriptor!
    
    public var enabled : Bool = false  //设置当前的表单是否能够编辑, 默认不能编辑，只能查看
    
    private var overlay : UIView?  //用于显示加载的状态
    
    /// MARK: Init
    
    public convenience init() {
        self.init(style: .Grouped)
    }
    
    public convenience init(form: FormDescriptor) {
        self.init()
        self.form = form
    }
    
    public override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    public override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        baseInit()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    private func baseInit() {
    }
    
    /// MARK: View life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        assert(form != nil, "self.form property MUST be assigned!")
        navigationItem.title = form.title
    }
    
    /// MARK: Public interface
    
    public func valueForTag(tag: String) -> NSObject! {
        for section in form.sections {
            for row in section.rows {
                if row.tag == tag {
                    return row.value
                }
            }
        }
        return nil
    }
    
    
//    public func showLoadingSpining(){
//        
//        overlay = UIView(frame : self.tableView.frame)
//        
//        overlay?.backgroundColor = UIColor.blackColor()
//        
//        overlay?.alpha = 0.8
//        
//        let indicator = UIActivityIndicatorView()
//        
//        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
//        
//        indicator.center = overlay!.center
//        
//        indicator.hidesWhenStopped = true
//        
//        overlay?.addSubview(indicator)
//        
//        indicator.startAnimating()
//        
//        self.tableView.addSubview(overlay!)
//        
//        
//    }
//    
//    public func stopLoadingSpining(){
//        
//        overlay?.removeFromSuperview()
//        
//    }

    public func setValue(value: NSObject, forTag tag: String) {
        
        var sectionIndex = 0
        var rowIndex = 0
        
        for section in form.sections {
            for row in section.rows {
                if row.tag == tag {
                    row.value = value
                    if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: sectionIndex)) as? FormBaseCell {
                        cell.update()
                    }
                    return
                }
                ++rowIndex
            }
            ++sectionIndex
            rowIndex = 0
        }
    }
    
    /// MARK: UITableViewDataSource
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return form.sections.count
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.sections[section].rows.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        var formBaseCellClass = formBaseCellClassFromRowDescriptor(rowDescriptor)
        
        let reuseIdentifier = NSStringFromClass(formBaseCellClass)
        
        var cell: FormBaseCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? FormBaseCell
        
        if cell == nil {
            
            cell = formBaseCellClass(style: .Default, reuseIdentifier: reuseIdentifier)
            cell?.formViewController = self
            cell?.configure()
        }else{
            
            cell?.update()
        }
        
        
        cell?.rowDescriptor = rowDescriptor
        
        rowDescriptor.parentFormCell = cell
        
        // apply cell custom design
        if let cellConfiguration = rowDescriptor.configuration[FormRowDescriptor.Configuration.CellConfiguration] as? NSDictionary {
            println("apply custom design")
            
            for (keyPath, value) in cellConfiguration {
                cell?.setValue(value, forKeyPath: keyPath as! String)
            }
        }
        
        //进行其他的一些通用的设置
        switch(rowDescriptor.rowType){
        case FormRowType.Name, FormRowType.Number, FormRowType.NamePhone, FormRowType.MultilineText, FormRowType.Text, FormRowType.Decimal,FormRowType.Percent,
            FormRowType.Email, FormRowType.Phone:
                cell?.setValue(NSTextAlignment.Right.rawValue, forKeyPath: "textField.textAlignment")
                //设置是否能够进行编辑
                cell?.setValue(self.enabled, forKeyPath: "textField.enabled")
        case FormRowType.SegmentedControl:
                cell?.setValue(self.enabled, forKeyPath: "segmentedControl.enabled")
        default:
                println("not need text alignment")
        }
        
        
        
        return cell!
    }
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.sections[section].headerTitle
    }
    
    public override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return form.sections[section].footerTitle
    }
    
    /// MARK: UITableViewDelegate
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)

        if let formBaseCellClass = formBaseCellClassFromRowDescriptor(rowDescriptor) {
            return formBaseCellClass.formRowCellHeight()
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        if let selectedRow = tableView.cellForRowAtIndexPath(indexPath) as? FormBaseCell {
            if let formBaseCellClass = formBaseCellClassFromRowDescriptor(rowDescriptor) {
                formBaseCellClass.formViewController(self, didSelectRow: selectedRow)
            }
        }
        
        if let didSelectClosure = rowDescriptor.configuration[FormRowDescriptor.Configuration.DidSelectClosure] as? DidSelectClosure {
            didSelectClosure()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private class func defaultCellClassForRowType(rowType: FormRowType) -> FormBaseCell.Type {
        dispatch_once(&Static.onceDefaultCellClass) {
            Static.defaultCellClasses[FormRowType.Text] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Number] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.NumbersAndPunctuation] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Decimal] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Name] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Phone] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.URL] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Twitter] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.NamePhone] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Email] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.ASCIICapable] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Password] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Button] = FormButtonCell.self
            Static.defaultCellClasses[FormRowType.BooleanSwitch] = FormSwitchCell.self
            Static.defaultCellClasses[FormRowType.BooleanCheck] = FormCheckCell.self
            Static.defaultCellClasses[FormRowType.SegmentedControl] = FormSegmentedControlCell.self
            Static.defaultCellClasses[FormRowType.Picker] = FormPickerCell.self
            Static.defaultCellClasses[FormRowType.Date] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.Time] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.DateAndTime] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.Stepper] = FormStepperCell.self
            Static.defaultCellClasses[FormRowType.Slider] = FormSliderCell.self
            Static.defaultCellClasses[FormRowType.MultipleSelector] = FormSelectorCell.self
            Static.defaultCellClasses[FormRowType.MultilineText] = FormTextViewCell.self
            Static.defaultCellClasses[FormRowType.Image] = FormImageCell.self
            Static.defaultCellClasses[FormRowType.Percent] = FormTextFieldCell.self
            
        }
        return Static.defaultCellClasses[rowType]!
    }
    
    private func formRowDescriptorAtIndexPath(indexPath: NSIndexPath!) -> FormRowDescriptor {
        let section = form.sections[indexPath.section]
        let rowDescriptor = section.rows[indexPath.row]
        return rowDescriptor
    }
    
    private func formBaseCellClassFromRowDescriptor(rowDescriptor: FormRowDescriptor) -> FormBaseCell.Type! {
        
        var formBaseCellClass: FormBaseCell.Type!
        
        if let cellClass: AnyClass = rowDescriptor.configuration[FormRowDescriptor.Configuration.CellClass] as? AnyClass {
            formBaseCellClass = cellClass as? FormBaseCell.Type
        }
        else {
            formBaseCellClass = FormViewController.defaultCellClassForRowType(rowDescriptor.rowType)
        }
        
        assert(formBaseCellClass != nil, "FormRowDescriptor.Configuration.CellClass must be a FormBaseCell derived class value.")
        
        return formBaseCellClass
    }
    
    
      
}
