//
//  UIScreen.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 4/21/21.
//

#if canImport(UIKit)
import UIKit


extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
   static var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
}
#endif
