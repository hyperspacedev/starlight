/*
*   THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS
*   NON-VIOLENT PUBLIC LICENSE v4 ("LICENSE"). THE WORK IS PROTECTED BY
*   COPYRIGHT AND ALL OTHER APPLICABLE LAWS. ANY USE OF THE WORK OTHER THAN
*   AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS PROHIBITED. BY
*   EXERCISING ANY RIGHTS TO THE WORK PROVIDED IN THIS LICENSE, YOU AGREE
*   TO BE BOUND BY THE TERMS OF THIS LICENSE. TO THE EXTENT THIS LICENSE
*   MAY BE CONSIDERED TO BE A CONTRACT, THE LICENSOR GRANTS YOU THE RIGHTS
*   CONTAINED HERE IN AS CONSIDERATION FOR ACCEPTING THE TERMS AND
*   CONDITIONS OF THIS LICENSE AND FOR AGREEING TO BE BOUND BY THE TERMS
*   AND CONDITIONS OF THIS LICENSE.
*
*   This source file is part of the Codename Starlight open source project
*   This file was created by Alex Modroño Vara on 3/26/22.
*
*   See `LICENSE.txt` for license information
*   See `CONTRIBUTORS.txt` for project authors
*
*/
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
