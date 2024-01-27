import UIKit
import SwiftMessages

class SwiftMessagesClass {
    @MainActor static func showSwiftMessage(theme: Theme, title: String, body: String) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(theme)
        view.configureDropShadow()
        view.configureContent(title: title, body: body)
        view.button?.isHidden = true
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        SwiftMessages.show(view: view)
    }
}
