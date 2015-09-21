//
//  FormSelectorCell.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 23/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormSelectorCell: FormValueCell {
    
    /// MARK: FormBaseCell
    
    public override func update() {
        super.update()
        
        titleLabel.text = rowDescriptor.title

        var title: String!
        
        if let selectedValues = rowDescriptor.value as? NSArray { // multiple values
            
            let indexedSelectedValues = NSSet(array: selectedValues as [AnyObject])
            
            if let options = rowDescriptor.configuration[FormRowDescriptor.Configuration.Options] as? NSArray {
                for optionValue in options {
                    if indexedSelectedValues.containsObject(optionValue) {
                        let optionTitle = rowDescriptor.titleForOptionValue(optionValue as! NSObject)
                        if title != nil {
                            title = title + ", \(optionTitle)"
                        }
                        else {
                            title = optionTitle
                        }
                    }
                }
            }
        }
        else if let selectedValue = rowDescriptor.value { // single value
            title = rowDescriptor.titleForOptionValue(selectedValue)
        }
        
        if title != nil && count(title) > 0 {
            valueLabel.text = title
            valueLabel.textColor = UIColor.blackColor()
        }
        else {
            valueLabel.text = rowDescriptor.configuration[FormRowDescriptor.Configuration.Placeholder] as? String
            valueLabel.textColor = UIColor.lightGrayColor()
        }
        
        println(rowDescriptor.configuration[FormRowDescriptor.Configuration.LinkedRowDescriptor])
        
        if let linkedRow = rowDescriptor.configuration[FormRowDescriptor.Configuration.LinkedRowDescriptor] as? FormRowDescriptor{
            
            println("will update \(rowDescriptor.value)")
            
            println(rowDescriptor.configuration[FormRowDescriptor.Configuration.LinkedRowValueClosure])
            
            if let valueFunc = rowDescriptor.configuration[FormRowDescriptor.Configuration.LinkedRowValueClosure] as? LinkedRowValueClosure {
                
                
                linkedRow.value =  valueFunc(rowDescriptor.value)
                println("the corresponding value are \(linkedRow.value)")
                
                //更新
                linkedRow.parentFormCell?.update()
            
            }
           
            
            
            

            
        }else{
            println("no, has no linked row ")
        }
        
    }
    
    public override class func formViewController(formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        if let row = selectedRow as? FormSelectorCell {
            
            formViewController.view.endEditing(true)
            
            var selectorClass: UIViewController.Type!
            
            if let selectorControllerClass: AnyClass = row.rowDescriptor.configuration[FormRowDescriptor.Configuration.SelectorControllerClass] as? AnyClass {
                selectorClass = selectorControllerClass as? UIViewController.Type
            }
            else { // fallback to default cell class
                selectorClass = FormOptionsSelectorController.self
            }
            
            if selectorClass != nil {
                println("the selectorClass is \(selectorClass)")
                
                let selectorController = selectorClass()
                if let formRowDescriptorViewController = selectorController as? FormSelector {
                    formRowDescriptorViewController.formCell = row
                    formViewController.navigationController?.pushViewController(selectorController, animated: true)
                }
                else {
                    fatalError("FormRowDescriptor.Configuration.SelectorControllerClass must conform to FormSelector protocol.")
                }
            }else{
                println("the sectorClass is null")
            }
        }
    }
}
