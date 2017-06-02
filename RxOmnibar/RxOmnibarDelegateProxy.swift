//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Omnibar
import RxSwift
import RxCocoa

public class RxOmnibarDelegateProxy
    : DelegateProxy
    , DelegateProxyType
, OmnibarDelegate {

    public override class func createProxyForObject(_ object: AnyObject) -> AnyObject {

        let omnibar: Omnibar = castOrFatalError(object)
        return omnibar.createRxOmnibarDelegateProxy()
    }

    public class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {

        let omnibar: Omnibar = castOrFatalError(object)
        omnibar.delegate = castOptionalOrFatalError(delegate)
    }

    public class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {

        let omnibar: Omnibar = castOrFatalError(object)
        return omnibar.delegate
    }

    fileprivate var _contentChange: PublishSubject<RxOmnibarContentChange>?

    // Used instead of lazy var to not initialize the object in deinit.
    var contentChangePublishSubject: PublishSubject<RxOmnibarContentChange> {

        if let subject = _contentChange {
            return subject
        }

        let subject = PublishSubject<RxOmnibarContentChange>()
        _contentChange = subject
        return subject
    }

    deinit {

        _contentChange?.on(.completed)
    }

    public func omnibar(_ omnibar: Omnibar, contentChange: OmnibarContentChange, method: ChangeMethod) {

        _contentChange?.on(.next(RxOmnibarContentChange(contentChange: contentChange, method: method)))

        if let forwardingTo = self._forwardToDelegate as? OmnibarDelegate {
            forwardingTo.omnibar(omnibar, contentChange: contentChange, method: method)
        }
    }
}