//
//  Promise.swift
//  SimpleManchkinCounter
//
//  Created by Antonov, Pavel on 3/24/18.
//  Copyright © 2018 paul. All rights reserved.
//

import Foundation

protocol Finishable {
    func done(done: @escaping(() -> ())) -> ()
}

class Promise : Finishable {
    // An array of callbacks (Void -> Void) to iterate through at resolve time.
    var pending: [(() -> ())] = []
    
    // A callback to call when we're completely done.
    var done: (() -> ()) = {}
    
    // A callback to invoke in the event of failure.
    var fail: (() -> ()) = {}
    
    // A simple way to track rejection.
    var rejected: Bool = false
    
    // Class ("static") method to return a new promise.
    class func deferPromise() -> Promise {
        return Promise()
    }
    
    // Resolve method.
    //
    // Returns a resolve function that loops through pending callbacks,
    // invoking each in sequence.
    //
    // Invokes fail callback in case of rejection (and swiftly abandons ship).
    func resolve() -> (() -> ()) {
        func resolve() -> () {
            for f in self.pending {
                if self.rejected {
                    fail()
                    return
                }
                f()
            }
            guard !self.rejected else {
                fail()
                return
            }
            done()
        }
        return resolve
    }
    
    // Reject method.
    //
    // Sets rejection flag to true to halt execution of subsequent callbacks.
    func reject() -> () {
        self.rejected = true
    }
    
    // Then method.
    //
    // This lets us chain callbacks together; it accepts one parameter, a Void -> Void
    // callback - can either be a function itself, or a Swift closure.
    func then(callback: @escaping (() -> ())) -> Promise {
        self.pending.append(callback)
        return self
    }
    
    // Then method override.
    //
    // This also lets us chain callbacks together; it accepts one parameter,
    // but unlike the previous implementation of then(), it accepts a Promise -> Void
    // callback (which can either be a function itself, or a Swift closure).
    //
    // This method then wraps that callback in a Void -> Void callback that
    // passes in this Promise object when invoking the callback() function.
    //
    // This allows users of our Promise library to have access to the Promise object,
    // so that they can reject a Promise within their then() clauses. Not the cleanest
    // way, but hey, this whole thing is a proof of concept, right? :)
    func then(callback: @escaping ((_ promise: Promise) -> ())) -> Promise {
        func thenWrapper() -> () {
            callback(self)
        }
        self.pending.append(thenWrapper)
        return self
    }
    
    // Fail method.
    //
    // This lets us chain a fail() method at the end of a set of then() clauses.
    //
    // Note that unlike then(), this does not return a Promise object. It returns
    // a "Finishable" object, which locks users down to only being able to specify
    // a done() clause after a fail() clause. This is to prevent users from being
    // able to do something like this:
    //
    // promise.then({}).fail({}).then({}).fail({})
    //
    func fail(fail: @escaping (() -> ())) -> Finishable {
        self.fail = fail
        let finishablePromise : Finishable = self
        return finishablePromise
    }
    
    // Done method.
    //
    // This lets us specify a done() callback to be invoked at the end of a set
    // of then() clauses (provided the promise hasn't been rejected).
    func done(done: @escaping (() -> ())) -> () {
        self.done = done
    }
}

//func flipAnimation(resultValue: Int, direction: FlipAnimationDirection) -> Promise {
//    let promise = Promise.deferPromise()
//    
//    flipAnimation(direction: direction) {
//        self.label.text = String(resultValue)
//        promise.resolve()()
//    }
//    
//    return promise
//}

