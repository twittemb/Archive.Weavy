//
//  Loom.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-25.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import RxSwift

/// Delegate used to communicate from a WarpWeaver
protocol WarpWeaverDelegate: class {

    /// Used to tell the delegate a new Warp is to be weaved
    ///
    /// - Parameter stitch: this stitch has a Warp nextPresentable
    func weaveAnotherWarp (withStitch stitch: Stitch)

    /// Used to triggered the delegate before the warp/weft is knitted
    ///
    /// - Parameters:
    ///   - warp: the warp that is knitted
    ///   - weft: the weft that is knitted
    func willKnit (withWarp warp: Warp, andWeft weft: Weft)
    func didKnit (withWarp warp: Warp, andWeft weft: Weft)
}

/// A WarpWeaver handles the weaving for a dedicated Warp
/// It will listen for Wefts emitted be the Warp Weftable companion or
/// the Weftables produced by the Warp.knit function along the way
class WarpWeaver {

    /// The warp to weave
    private let warp: Warp

    /// The Rx subject that holds all the wefts trigerred either by the Warp's Weftable
    /// or by the Weftables produced by the Warp.knit function
    private let wefts = PublishSubject<Weft>()

    /// The delegate is used so that the WarpWeaver can communicate with the Loom
    /// in the case of a new Warp to weave or before and after a knit process
    private weak var delegate: WarpWeaverDelegate!

    internal let disposeBag = DisposeBag()

    /// Initialize a WarpWeaver
    ///
    /// - Parameter warp: The Warp to weave
    init(forWarp warp: Warp, withDelegate delegate: WarpWeaverDelegate) {
        self.warp = warp
        self.delegate = delegate
    }

    /// Launch the weaving process
    ///
    /// - Parameter weftable: The Weftable that goes with the Warp. It will trigger some Weft at the Warp level (the first one for instance)
    func weave (listeningToWeftable weftable: Weftable) {

        // Weft can be emitted by the Weftable companion of the Warp or the weftables in the Stitches fired by the Warp.knit function
        self.wefts.asObservable().subscribe(onNext: { [unowned self] (weft) in

            // a new Weft has been triggered for this Warp. Let's knit it and see what Stitches come from that
            self.delegate.willKnit(withWarp: self.warp, andWeft: weft)
            let stitches = self.warp.knit(withWeft: weft)
            self.delegate.didKnit(withWarp: self.warp, andWeft: weft)

            // we know which stitches have been triggered by this navigation action
            // each one of these stitches will lead to a weaving action (for example, new warps to handle and new weftable to listen)
            stitches.forEach({ [unowned self] (stitch) in

                // if the stitch next presentable represents a Warp, it has to be processed at a higher level because
                // the WarpWeaver only knowns about the warp it's in charge of.
                // The WarpWeaver will expose through its delegate
                if stitch.nextPresentable is Warp {
                    self.delegate.weaveAnotherWarp(withStitch: stitch)
                } else {
                    // the stitch next presentable is not a warp, it can be processed at the WarpWeaver level
                    if  let nextPresentable = stitch.nextPresentable,
                        let nextWeftable = stitch.nextWeftable {

                        // we have to wait for the presentable to be displayed at least once to be able to
                        // listen to the weftable. Indeed, we do not want to triggered another navigation action
                        // until there is a first ViewController in the hierarchy
                        nextPresentable.rxFirstTimeVisible.subscribe(onSuccess: { [unowned self, unowned nextPresentable, unowned nextWeftable] (_) in

                            // we listen to the presentable weftable. For each new weft value, we trigger a new weaving process
                            // this is the core principle of the whole navigation process
                            // The process is paused each time the presntable is not currently displayed
                            // for instance when another presentable is above it in the ViewControllers hierarchy.
                            nextWeftable.weft
                                .pausable(nextPresentable.rxVisible.startWith(true))
                                .asDriver(onErrorJustReturn: VoidWeft()).drive(onNext: { [unowned self] (weft) in
                                    // the nextPresentable's weftable fires a new weft

                                    self.wefts.onNext(weft)
                                }).disposed(by: nextPresentable.disposeBag)

                        }).disposed(by: self.disposeBag)
                    }
                }

                // when first presentable is discovered we can assume the Warp is ready to be used (its head can be used in other warps)
                self.warp.warpReadySubject.onNext(true)
            })
        }).disposed(by: self.disposeBag)

        // we listen for the Warp dedicated Weftable
        weftable.weft.pausable(self.warp.rxVisible.startWith(true)).asDriver(onErrorJustReturn: VoidWeft()).drive(onNext: { [unowned self] (weft) in
            // the warp's weftable fires a new weft (the initial weft for exemple)
            self.wefts.onNext(weft)
        }).disposed(by: warp.disposeBag)

    }
}

/// the only purpose of a Loom is to handle the navigation that is
/// declared in the Warps of the application.
final public class Loom {

    private var warpWeavers = [WarpWeaver]()
    private let disposeBag = DisposeBag()
    internal let willKnitSubject = PublishSubject<(String, String)>()
    internal let didKnitSubject = PublishSubject<(String, String)>()

    /// Initialize the Loom
    public init() {
    }

    /// Launch the weaving process
    ///
    /// - Parameters:
    ///   - warp: The warp to weave
    ///   - weftable: The Warp's Weftable companion that will determine the first navigation state for instance
    public func weave (fromWarp warp: Warp, andWeftable weftable: Weftable) {

        // a new WarpWeaver will handle this warp weaving
        let warpWeaver = WarpWeaver(forWarp: warp, withDelegate: self)

        // we stack the WarpWeavers so that we do not lose there reference (whereas it could be a leak)
        self.warpWeavers.append(warpWeaver)

        // let's weave the Warp
        warpWeaver.weave(listeningToWeftable: weftable)

        // clear the WarpWeavers stack when the warp has been dismissed (its head has been dismissed)
        let warpIndex = self.warpWeavers.count-1
        warp.rxDismissed.subscribe(onSuccess: { [unowned self] (_) in
            self.warpWeavers.remove(at: warpIndex)
        }).disposed(by: self.disposeBag)
    }
}

extension Loom: WarpWeaverDelegate {

    func weaveAnotherWarp(withStitch stitch: Stitch) {
        guard let nextWeftable = stitch.nextWeftable else {
            print ("A Warp must have a Weftable companion")
            return
        }

        if let nextWarp = stitch.nextPresentable as? Warp {
            self.weave(fromWarp: nextWarp, andWeftable: nextWeftable)
        }
    }

    func willKnit(withWarp warp: Warp, andWeft weft: Weft) {
        if !(weft is VoidWeft) {
            self.willKnitSubject.onNext(("\(warp)", "\(weft)"))
        }
    }

    func didKnit(withWarp warp: Warp, andWeft weft: Weft) {
        if !(weft is VoidWeft) {
            self.didKnitSubject.onNext(("\(warp)", "\(weft)"))
        }
    }
}

// swiftlint:disable identifier_name
extension Loom {

    /// Reactive extension to a Loom
    public var rx: Reactive<Loom> {
        return Reactive(self)
    }
}
// swiftlint:enable identifier_name

extension Reactive where Base: Loom {

    /// Rx Observable triggered before the Loom knit a Warp/Weft
    public var willKnit: Observable<(String, String)> {
        return self.base.willKnitSubject.asObservable()
    }

    /// Rx Observable triggered after the Loom knit a Warp/Weft
    public var didKnit: Observable<(String, String)> {
        return self.base.didKnitSubject.asObservable()
    }
}
