//
//  Loom.swift
//  Weavy
//
//  Created by Thibault Wittemberg on 17-07-25.
//  Copyright © 2017 Warp Factor. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

/// A WarpWeaver handles the weaving for a dedicated Warp
/// It will listen for Wefts emitted be the Warp Weftable companion or
/// the Weftables produced by the Warp.knit function along the way
class WarpWeaver {

    /// The warp to weave
    private let warp: Warp

    /// The Rx subject that holds all the wefts trigerred either by the Warp's Weftable
    /// or by the Weftables produced by the Warp.knit function
    private let wefts = PublishSubject<Weft>()

    /// The Rx subject that holds all the stitch emitted by the Warp.knit function.
    /// only the Stitches holding a Warp kind of presentable will be pushed into the subject
    private let stitchesSubject = PublishSubject<Stitch>()

    /// The Rx Stitched Observable fron the stitchesSubject
    /// It is listened by the Loom
    internal lazy var stitches: Observable<(Stitch)> = {
        return self.stitchesSubject.asObservable()
    }()

    internal let disposeBag = DisposeBag()

    /// Initialize a WarpWeaver
    ///
    /// - Parameter warp: The Warp to weave
    init(forWarp warp: Warp) {
        self.warp = warp
    }

    /// Launch the weaving process
    ///
    /// - Parameter weftable: The Weftable that goes with the Warp. It will trigger some Weft at the Warp level (the first one for instance)
    func weave (listeningToWeftable weftable: Weftable) {

        // Weft can be emitted by the Weftable companion of the Warp or the weftables in the Stitches fired by the Warp.knit function
        self.wefts.asObservable().subscribe(onNext: { [unowned self] (weft) in

            // a new Weft has been triggered for this Warp. Let's knit it and see what Stitches come from that
            let stitches = self.warp.knit(withWeft: weft)

            // we know which stitches have been triggered by this navigation action
            // each one of these stitches will lead to a weaving action (for example, new warps to handle and new weftable to listen)
            stitches.forEach({ [unowned self] (stitch) in

                // if the stitch next presentable represents a Warp, it has to be processed at a higher level because
                // the WarpWeaver only knowns about the warp it's in charge of.
                // The WarpWeaver will expose it to the Loom via the stitchesSubjects
                if stitch.nextPresentable is Warp {
                    self.stitchesSubject.onNext(stitch)
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
public class Loom {

    private var warpWeavers = [WarpWeaver]()
    private let disposeBag = DisposeBag()

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
        let warpWeaver = WarpWeaver(forWarp: warp)

        // we stack the WarpWeavers so that we do not lose there reference (whereas it could be a leak)
        self.warpWeavers.append(warpWeaver)

        // we listen for the Stitches that are exposed by this WarpWeaver
        // In case those Stitches hlods Warps kind of presentable
        // We launch a weaving process on them
        warpWeaver.stitches.subscribe(onNext: { [unowned self] (stitch) in

            guard   let nextWeftable = stitch.nextWeftable else {
                    print ("A Warp must have a Weftable companion")
                    return
            }

            if let nextWarp = stitch.nextPresentable as? Warp {
                print ("Warp \(warp) has triggered a new Warp \(nextWarp)")
                self.weave(fromWarp: nextWarp, andWeftable: nextWeftable)
            }

        }).disposed(by: self.disposeBag)

        // let's weave the Warp
        warpWeaver.weave(listeningToWeftable: weftable)

        // clear the WarpWeavers stack when the warp has been dismissed (its head has been dismissed)
        let warpIndex = self.warpWeavers.count-1
        warp.rxDismissed.subscribe(onSuccess: { [unowned self] (_) in
            self.warpWeavers.remove(at: warpIndex)
        }).disposed(by: self.disposeBag)
    }
}
