//
//  Colors.swift
//  DailyTask
//
//  Created by Eduardo on 20/09/23.
//

/// # Colors
///
/// The `Colors` module provides custom color definitions for use within the DailyTask application.
///
/// ## Custom Colors
///
/// The module defines an enumeration `CustomColor` that represents custom colors used in
/// the application's user interface. Currently, it includes the following color options:
///
/// - `.customRed`: Represents a custom red color.
/// - `.customGreen`: Represents a custom green color.
/// - `.customBlue`: Represents a custom blue color.
///
/// You can easily access these custom colors using the `UIColor` extension provided by
/// this module.
///
/// ### Example Usage
///
/// ```swift
/// // Access the custom red color
/// let redColor = UIColor(.customRed)
///
/// // Access the custom green color
/// let greenColor = UIColor(.customGreen)
/// ```
///
/// - Note: Additional color cases can be added to the `CustomColor` enumeration as needed.
import Foundation
import UIKit

/// An enumeration representing custom colors available for use in the application.
enum CustomColor {
    /// Represents a custom red color.
    case customRed
    
    /// Represents a custom green color.
    case customGreen
    
    /// Represents a custom blue color.
    case customBlue
    // Add more color cases as needed
}

extension UIColor {
    /// Creates a `UIColor` instance with the specified custom color.
     ///
     /// - Parameter customColor: The custom color to create.
     /// - Returns: A `UIColor` instance representing the specified custom color.
     ///
     /// You can use this convenience initializer to access custom colors defined in the
     /// `CustomColor` enumeration.
     ///
     /// ### Example Usage
     ///
     /// ```swift
     /// // Access the custom red color
     /// let redColor = UIColor(.customRed)
     ///
     /// // Access the custom green color
     /// let greenColor = UIColor(.customGreen)
     /// ```
     ///
     /// - Note: Additional cases and color values can be added to the `CustomColor`
     ///         enumeration as needed.
    convenience init?(_ customColor: CustomColor) {
        switch customColor {
        case .customRed:
            self.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case .customGreen:
            self.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        case .customBlue:
            self.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
            // Add more cases and color values as needed
        }
    }
}

// Extension created to give the ViewControllers permission to use the WCAG calculus
extension UIViewController{
    
    /// Function to calculate the luminance of a UIColor based on WCAG
    func calculateLuminance(_ color: UIColor) -> CGFloat {
        
        if color.cgColor.components?.count ?? 0 < 3 || color == .systemBackground{
            let colorLuminance = color.cgColor.components?[0] ?? 0
            
            return colorLuminance
            
        } else{
            
            if let color = color.cgColor.components {
                let rLuminance = pow(((color[0] + 0.055)/1.055), 2.4)
                let gLuminance = pow(((color[1] + 0.055)/1.055), 2.4)
                let bLuminance = pow(((color[2] + 0.055)/1.055), 2.4)
                let sum = (rLuminance * 0.2125) + (gLuminance * 0.7152) + (bLuminance * 0.0722)
                return sum
            }
            
            return 0
            
        }
        
    }

    /// Function to calculate if the black color looks good with the selected color
    func calculateBlackContrast(_ color: CGFloat) -> CGFloat {
        return (color + 0.05) / 0.10
    }

    /// Function to calculate if the white color looks good with the selected color
    func calculateWhiteContrast(_ color: CGFloat) -> CGFloat {
        return 1.05 / (color + 0.05)
    }

    /// This function use the WCAG formula to discover the best color choose to use with the background (white or black)
    ///
    ///  ## How to use?
    ///
    /// Just create an instace of the function to return an UIColor (Black or White)
    ///
    ///``` swift
    /// view.backgroundColor = .red
    /// let iconColor = selectTheBestColor(view.backgroundColor)
    ///
    ///```
    ///If the `blackContrast` is higher than the white it will be choosed and the same happens with the white color
    ///
    func selectTheBestColor(color: UIColor, isBackground: Bool) -> UIColor {
        let whiteContrast = calculateWhiteContrast(calculateLuminance(color))
        let blackContrast = calculateBlackContrast(calculateLuminance(color))
        
        if whiteContrast >= blackContrast {
            if isBackground{
                return .white
            } else {
                return .systemGray5
            }
            
        } else {
            return .black
        }
    }
    
}
