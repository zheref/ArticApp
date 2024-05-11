import SwiftUI

extension Font {
    static let h1: Font = {
        .custom("Spartan-SemiBold", size: 32)
    }()
    
    static let h2: Font = {
        .custom("Spartan-SemiBold", size: 20)
    }()
    
    static let h3: Font = {
        .custom("Spartan-SemiBold", size: 16)
    }()
    
    static let h4: Font = {
        .custom("Spartan-SemiBold", size: 12)
    }()
    
    static let body1: Font = {
        .custom("Spartan-Medium", size: 12)
    }()
    
    static let body2: Font = {
        .custom("Spartan-Medium", size: 11)
    }()
    
    static let buttonTitle: Font = {
        .custom("Spartan-Bold", size: 12)
    }()
    
    enum Bold {
        static let h1: Font = {
            .custom("Spartan-Bold", size: 32)
        }()
        
        static let h2: Font = {
            .custom("Spartan-Bold", size: 20)
        }()
        
        static let h3: Font = {
            .custom("Spartan-Bold", size: 16)
        }()
        
        static let h4: Font = {
            .custom("Spartan-Bold", size: 12)
        }()
        
        static let body1: Font = {
            .custom("Spartan-SemiBold", size: 12)
        }()
        
        static let body2: Font = {
            .custom("Spartan-SemiBold", size: 11)
        }()
    }
}
