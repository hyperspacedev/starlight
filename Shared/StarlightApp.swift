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
*   This file was created by Marquis Kurt on 6/23/20.
*
*   See `LICENSE.txt` for license information
*   See `CONTRIBUTORS.txt` for project authors
*
*/
import SwiftUI
import Chica
import KeychainAccess

@main
struct StarlightApp: App {

    @State var deeplink: Deeplinker.Deeplink? {
        didSet {

            //  A bit of a workaround until Apple releases a fully working
            //  alternative to DispatchQueue.main.asyncAfter()
            Task {

                //  For some reason Apple decided it was a good idea to have to
                //  pass the time as nanoseconds.
                //
                //  Delay of 0.2 seconds (1 second = 1_000_000_000 nanoseconds)
                try? await Task.sleep(nanoseconds: 200_000_000)

                //  Now we refresh the deeplink
                Deeplinker.shared.refresh(&deeplink)

            }

        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.deeplink, self.deeplink)
                .onOpenURL { url in

                    // TODO: Add different URL endpoints here for deep linking.
                    // Maybe like Apollo?
                    do {
                        self.deeplink = try Deeplinker.shared.manage(url: url)
                    } catch {
                        print(error)
                    }

                }
        }
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
