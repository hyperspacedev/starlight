//
//  asyncAfter.swift
//  Starlight
//
//  Created by Alex Modroño Vara on 26/3/22.
//

import Foundation

public func asyncAfter(_ timeInSeconds: Double, action: @escaping () -> Void) {

    //  A bit of a workaround until Apple releases a fully working
    //  alternative to DispatchQueue.main.asyncAfter()
    Task {

        //  For some reason Apple decided it was a good idea to have to
        //  pass the time as nanoseconds.
        //
        //  Delay of x seconds where 1 second = 1_000_000_000 nanoseconds
        //  1_000_000_000x/1= number of nanoseconds
        try? await Task.sleep(nanoseconds: UInt64(timeInSeconds * 1_000_000_000))

        action()

    }

}
