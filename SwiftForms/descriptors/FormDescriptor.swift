//
//  FormDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit


public class FormDescriptor: NSObject {

    /// MARK: Properties
    
    public var title: String!
    
    public var sections: [FormSectionDescriptor] = []
    
    /// MARK: Public
    
    public func addSection(section: FormSectionDescriptor) {
        sections.append(section)
    }
    
    public func removeSection(section: FormSectionDescriptor) {
        if let index = find(sections, section) {
            sections.removeAtIndex(index)
        }
    }
    
    public func formValues() -> NSDictionary {
        
        var formValues = NSMutableDictionary()

        for section in sections {
            for row in section.rows {
                if row.tag != nil && row.rowType != .Button {
                    if row.value != nil {
                        formValues[row.tag!] = row.value!
                    }
                    else {
                       //remove the key field
                       // formValues[row.tag!] = NSNull()
                    }
                }
            }
        }
        return formValues.copy() as! NSDictionary
    }
    
    public func formValuesArray() -> [String : NSObject] {
        
        var formValues = [String : NSObject]()
        
        for section in sections {
            for row in section.rows {
                if row.tag != nil && row.rowType != .Button {
                    if row.value != nil {
                        if row.tag.rangeOfString(".") != nil {
                            
                            var keyList = row.tag.componentsSeparatedByString(".")
                            
                            if let d = formValues[keyList[0]] as? NSMutableDictionary{
                                
                                d[keyList[1]] = row.value2
//                                switch row.rowType {
//                                case .Number, .Percent, .NumbersAndPunctuation, .Decimal, .BooleanCheck, .BooleanSwitch:
//                                    
//                                    if let v = row.value as? NSNumber{
//                                        formValues[keyList[1]] = v
//                                    }else{
//                                        println("warning :the number type can't cast to number, key:\(row.tag!), and value : ==\(row.value)==")
//                                    }
//                                default:
//                                    d[keyList[1]] = row.value!.description
//                                }
                                
                                
                                //d[keyList[1]] = row.value!.description
                                
                            }else{
                                
                                formValues[keyList[0]] = NSMutableDictionary(object: row.value2, forKey: keyList[1])
                                
//                                switch row.rowType{
//                                case .Number, .Percent, .NumbersAndPunctuation, .Decimal, .BooleanCheck, .BooleanSwitch:
//                                    if let v = row.value as? NSNumber {
//                                        formValues[keyList[0]] = NSMutableDictionary(object: v, forKey: keyList[1])
//                                    }else{
//                                        println("warning :the number type can't cast to number key:\(keyList[1]), and value : ==\(row.value)==")
//                                    }
//                                    
//                                default:
//                                    formValues[keyList[0]] = NSMutableDictionary(object: row.value!.description, forKey: keyList[1])
//                                }
                            }
                            
                        }else{
//                            println("the value of \(row.tag) is \(row.value)")
//                            
//                            switch row.rowType {
//                                case .Number, .Percent, .NumbersAndPunctuation, .Decimal, .BooleanCheck:
//                                    if let v = row.value as? NSNumber{
//                                        formValues[row.tag!] = v
//                                    }else{
//                                        println("warning :the number type can't cast to number, key:\(row.tag!), and value : ==\(row.value)==")
//                                    }
//                                default:
//                                    formValues[row.tag!] = row.value!.description
//                            }
                            formValues[row.tag!] = row.value2
                            
                        }
                        
                    }
                    else {
                        //remove the key field
                        // formValues[row.tag!] = NSNull()
                    }
                }
            }
        }
        return formValues
    }

    
    public func formValuesJSON() -> JSON {
        
        var formValues = JSON("{}")
        
        for section in sections {
            for row in section.rows {
                if row.tag != nil && row.rowType != .Button {
                    if row.value != nil {
                        formValues[row.tag!] = JSON(row.value!)
                    }
                    else {
                        //remove the key field
                        // formValues[row.tag!] = NSNull()
                    }
                }
            }
        }
        return formValues
    }
    
    public func validateForm() -> FormRowDescriptor! {
        for section in sections {
            for row in section.rows {
                if let required = row.configuration[FormRowDescriptor.Configuration.Required] as? Bool {
                    //println("the required filed \(row.title) ? \(required)")
                    if required && row.value == nil {
                        return row
                    }
                }
            }
        }
        return nil
    }
}
