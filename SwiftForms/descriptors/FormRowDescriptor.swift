//
//  FormRowDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public enum FormRowType {
    case Unknown
    case Text
    case URL
    case Number
    case NumbersAndPunctuation
    case Decimal
    case Name
    case Phone
    case NamePhone
    case Email
    case Twitter
    case ASCIICapable
    case Password
    case Button
    case BooleanSwitch
    case BooleanCheck
    case SegmentedControl
    case Picker
    case Date
    case Time
    case DateAndTime
    case Stepper
    case Slider
    case MultipleSelector
    case MultilineText
    case Image
    case Percent
}

public typealias DidSelectClosure = (Void) -> Void
public typealias UpdateClosure = (FormRowDescriptor) -> Void
public typealias TitleFormatterClosure = (NSObject) -> String!
public typealias VisualConstraintsClosure = (FormBaseCell) -> NSArray
public typealias LinkedRowValueClosure = (NSObject?) -> String!


public class FormRowDescriptor: NSObject {

    /// MARK: Types
    
    public struct Configuration {
        public static let Required = "FormRowDescriptorConfigurationRequired"

        public static let CellClass = "FormRowDescriptorConfigurationCellClass"
        public static let CheckmarkAccessoryView = "FormRowDescriptorConfigurationCheckmarkAccessoryView"
        public static let CellConfiguration = "FormRowDescriptorConfigurationCellConfiguration"

        public static let Placeholder = "FormRowDescriptorConfigurationPlaceholder"
        
        public static let WillUpdateClosure = "FormRowDescriptorConfigurationWillUpdateClosure"
        public static let DidUpdateClosure = "FormRowDescriptorConfigurationDidUpdateClosure"
        
        public static let MaximumValue = "FormRowDescriptorConfigurationMaximumValue"
        public static let MinimumValue = "FormRowDescriptorConfigurationMinimumValue"
        public static let Steps = "FormRowDescriptorConfigurationSteps"
        
        public static let Continuous = "FormRowDescriptorConfigurationContinuous"
        
        public static let DidSelectClosure = "FormRowDescriptorConfigurationDidSelectClosure"
        
        public static let VisualConstraintsClosure = "FormRowDescriptorConfigurationVisualConstraintsClosure"
        
        public static let Options = "FormRowDescriptorConfigurationOptions"
        
        public static let TitleFormatterClosure = "FormRowDescriptorConfigurationTitleFormatterClosure"
        
        public static let SelectorControllerClass = "FormRowDescriptorConfigurationSelectorControllerClass"
        
        public static let AllowsMultipleSelection = "FormRowDescriptorConfigurationSelectorControllerClass"
        
        public static let ShowsInputToolbar = "FormRowDescriptorConfigurationShowsInputToolbar"
        
        public static let DateFormatter = "FormRowDescriptorConfigurationDateFormatter"
        
        //链接对应的字段
        public static let LinkedRowDescriptor = "FormRowDescriptorLinkedRowDescriptor"
        
        //链接字段对应的函数
        public static let LinkedRowValueClosure = "FormRowDescriptorLinkedRowValueClosure"
        
    }
    
    /// MARK: Properties
    
    public var title: String!
    public var rowType: FormRowType = .Unknown
    public var tag: String!
    
    public weak var parentFormCell : FormBaseCell!
    
    public var value: NSObject! {
        willSet {
            if let willUpdateBlock = self.configuration[Configuration.WillUpdateClosure] as? UpdateClosure {
                willUpdateBlock(self)
            }
        }
        didSet {
            if let didUpdateBlock = self.configuration[Configuration.DidUpdateClosure] as? UpdateClosure {
                didUpdateBlock(self)
            }
        }
    }
    
    public var value2 : NSObject! {
        get{
            println("start to get value with key:\(tag), value is \(value)")
            switch rowType{
            case .BooleanSwitch, .BooleanCheck:
                if value == true {
                    return Int(1)
                }else{
                    return Int(0)
                }
            case .Number:
                if let v = value as? Int{
                    return v
                }else if let s = value as? NSString{
                    return s.integerValue
                }else{
                    println("FAIL to convert")
                    return value.description
                }
            case .MultipleSelector:
                if let v = value as? NSNumber {
                    println("successfully convert to NSNumber with key:\(tag), value: \(value)")
                    return v
                }else{
                    println("FAIL convert to NSNumber with key:\(tag), value:\(value)")
                    return value.description
                }
            case .Decimal, .Percent, .NumbersAndPunctuation:
                if let v = value as? NSNumber {
                    return v
                }else if let s = value as? NSString{
                    return s.doubleValue
                }else{
                    println("Fail to convert")
                    return value.description
                }

            default:
                return value.description
            }
        }
    }
    
    public var configuration: [NSObject : Any] = [:]
    
    /// MARK: Init
    
    public override init() {
        super.init()
        configuration[Configuration.Required] = false  //不是必须输入的，除非手动设置为必填
        configuration[Configuration.AllowsMultipleSelection] = false
        configuration[Configuration.ShowsInputToolbar] = false

    }
    
    public convenience init(tag: String, rowType: FormRowType, title: String, placeholder: String! = nil) {
        self.init()
        self.tag = tag
        self.rowType = rowType
        self.title = title
        
        if placeholder != nil {
            configuration[FormRowDescriptor.Configuration.Placeholder] = placeholder
        }
    }
    
    /// MARK: Public interface
    
    public func titleForOptionAtIndex(index: Int) -> String! {
        if let options = configuration[FormRowDescriptor.Configuration.Options] as? NSArray {
            return titleForOptionValue(options[index] as! NSObject)
        }
        return nil
    }
    
    public func titleForOptionValue(optionValue: NSObject) -> String! {
        if let titleFormatter = configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] as? TitleFormatterClosure {
            return titleFormatter(optionValue)
        }
        else if optionValue is String {
            return optionValue as! String
        }
        return "\(optionValue)"
    }
}
