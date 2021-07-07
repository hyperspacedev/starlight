//
//  InstanceView.swift
//  Hyperspace
//
//  Created by Alex Modroño Vara on 2/1/21.
//

import SwiftUI
import FancyScrollView

struct InstanceView: View {

    var content: String {
        return """
                        <h3 id="summary">Summary</h3>
                        <i class="fa fa-times"></i>
                         No racism, sexism, homophobia, transphobia, xenophobia, casteism
                        <br>
                        <i class="fa fa-times"></i>
                         No sexual depictions of minors
                        <br>
                        <i class="fa fa-times"></i>
                         No spam
                        <br>
                        <i class="fa fa-times"></i>
                         No bots
                        <br>
                        <i class="fa fa-times"></i>
                         No cross-posting from Twitter


                        <h3 id="in-depth">In-depth</h3>
                        <p>The following guidelines are not a legal document, and final interpretation is up to the administration of mastodon.online; they are here to provide you with an insight into our content moderation policies:</p>
                        <ol>
                          <li>
                            The following types of content will be removed from the public timeline:
                            <ol type="a">
                              <li>Excessive advertising</li>
                              <li>Uncurated news bots posting from third-party news sources</li>
                              <li>Untagged nudity, pornography and sexually explicit content, including artistic depictions</li>
                              <li>Untagged gore and extremely graphic violence, including artistic depictions</li>
                            </ol>
                          </li>

                          <li>
                            The following types of content will be removed from the public timeline, and may result in account suspension and revocation of access to the service:
                            <ol type="a">
                              <li>Racism or advocation of racism</li>
                              <li>Sexism or advocation of sexism</li>
                              <li>Casteism or advocation of casteism</li>
                              <li>Discrimination against gender and sexual minorities, or advocation thereof</li>
                              <li>Xenophobic and/or violent nationalism</li>
                              <li>Spreading disinformation or conspiracy theories that undermine public health</li>
                            </ol>
                          </li>

                          <li>
                            The following types of content are explicitly disallowed and will result in revocation of access to the service:
                            <ol type="a">
                              <li>Sexual depictions of children</li>
                              <li>Content illegal in Germany, such as holocaust denial or Nazi symbolism</li>
                              <li>Conduct promoting the ideology of National Socialism</li>
                            </ol>
                          </li>

                          <li>
                            Any conduct intended to stalk or harass other users, or to impede other users from utilizing the service, or to degrade the performance of the service, or to harass other users, or to incite other users to perform any of the aforementioned actions, is also disallowed, and subject to punishment up to and including revocation of access to the service. This includes, but is not limited to, the following behaviors:
                            <ol type="a">
                              <li>Continuing to engage in conversation with a user that has specifically has requested for said engagement with that user to cease and desist may be considered harassment, regardless of platform-specific privacy tools employed.</li>
                              <li>Aggregating, posting, and/or disseminating a person's demographic, personal, or private data without express permission (informally called doxing or dropping dox) may be considered harassment.</li>
                              <li>Inciting users to engage another user in continued interaction or discussion after a user has requested for said engagement with that user to cease and desist (informally called brigading or dogpiling) may be considered harassment.</li>
                            </ol>
                          </li>
                        </ol>
                        <li>
                            The following types of content will be removed from the public timeline:
                            <ol type="a">
                              <li>Excessive advertising</li>
                              <li>Uncurated news bots posting from third-party news sources</li>
                              <li>Untagged nudity, pornography and sexually explicit content, including artistic depictions</li>
                              <li>Untagged gore and extremely graphic violence, including artistic depictions</li>
                            </ol>
                          </li>

                            The following types of content will be removed from the public timeline:
                            
                        <ol type="a">
                              <li>Excessive advertising</li>
                              <li>Uncurated news bots posting from third-party news sources</li>
                              <li>Untagged nudity, pornography and sexually explicit content, including artistic depictions</li>
                              <li>Untagged gore and extremely graphic violence, including artistic depictions</li>
                            </ol>
                        <li>Excessive advertising</li>
                        <li>Uncurated news bots posting from third-party news sources</li>
                        <li>Untagged nudity, pornography and sexually explicit content, including artistic depictions</li>
                        <li>Untagged gore and extremely graphic violence, including artistic depictions</li>
                        <ol type="a">
                              <li>Excessive advertising</li>
                              <li>Uncurated news bots posting from third-party news sources</li>
                              <li>Untagged nudity, pornography and sexually explicit content, including artistic depictions</li>
                              <li>Untagged gore and extremely graphic violence, including artistic depictions</li>
                            </ol>
                        <li>
                            The following types of content will be removed from the public timeline:
                            <ol type="a">
                              <li>Excessive advertising</li>
                              <li>Uncurated news bots posting from third-party news sources</li>
                              <li>Untagged nudity, pornography and sexually explicit content, including artistic depictions</li>
                              <li>Untagged gore and extremely graphic violence, including artistic depictions</li>
                            </ol>
                          </li>
                        <li>
                            The following types of content will be removed from the public timeline, and may result in account suspension and revocation of access to the service:
                            <ol type="a">
                              <li>Racism or advocation of racism</li>
                              <li>Sexism or advocation of sexism</li>
                              <li>Casteism or advocation of casteism</li>
                              <li>Discrimination against gender and sexual minorities, or advocation thereof</li>
                              <li>Xenophobic and/or violent nationalism</li>
                              <li>Spreading disinformation or conspiracy theories that undermine public health</li>
                            </ol>
                          </li>
                        <li>
                            The following types of content are explicitly disallowed and will result in revocation of access to the service:
                            <ol type="a">
                              <li>Sexual depictions of children</li>
                              <li>Content illegal in Germany, such as holocaust denial or Nazi symbolism</li>
                              <li>Conduct promoting the ideology of National Socialism</li>
                            </ol>
                          </li>
                        <li>
                            Any conduct intended to stalk or harass other users, or to impede other users from utilizing the service, or to degrade the performance of the service, or to harass other users, or to incite other users to perform any of the aforementioned actions, is also disallowed, and subject to punishment up to and including revocation of access to the service. This includes, but is not limited to, the following behaviors:
                            <ol type="a">
                              <li>Continuing to engage in conversation with a user that has specifically has requested for said engagement with that user to cease and desist may be considered harassment, regardless of platform-specific privacy tools employed.</li>
                              <li>Aggregating, posting, and/or disseminating a person's demographic, personal, or private data without express permission (informally called doxing or dropping dox) may be considered harassment.</li>
                              <li>Inciting users to engage another user in continued interaction or discussion after a user has requested for said engagement with that user to cease and desist (informally called brigading or dogpiling) may be considered harassment.</li>
                            </ol>
                          </li>
                        <ol>
                          <li>
                            The following types of content will be removed from the public timeline:
                            <ol type="a">
                              <li>Excessive advertising</li>
                              <li>Uncurated news bots posting from third-party news sources</li>
                              <li>Untagged nudity, pornography and sexually explicit content, including artistic depictions</li>
                              <li>Untagged gore and extremely graphic violence, including artistic depictions</li>
                            </ol>
                          </li>

                          <li>
                            The following types of content will be removed from the public timeline, and may result in account suspension and revocation of access to the service:
                            <ol type="a">
                              <li>Racism or advocation of racism</li>
                              <li>Sexism or advocation of sexism</li>
                              <li>Casteism or advocation of casteism</li>
                              <li>Discrimination against gender and sexual minorities, or advocation thereof</li>
                              <li>Xenophobic and/or violent nationalism</li>
                              <li>Spreading disinformation or conspiracy theories that undermine public health</li>
                            </ol>
                          </li>

                          <li>
                            The following types of content are explicitly disallowed and will result in revocation of access to the service:
                            <ol type="a">
                              <li>Sexual depictions of children</li>
                              <li>Content illegal in Germany, such as holocaust denial or Nazi symbolism</li>
                              <li>Conduct promoting the ideology of National Socialism</li>
                            </ol>
                          </li>

                          <li>
                            Any conduct intended to stalk or harass other users, or to impede other users from utilizing the service, or to degrade the performance of the service, or to harass other users, or to incite other users to perform any of the aforementioned actions, is also disallowed, and subject to punishment up to and including revocation of access to the service. This includes, but is not limited to, the following behaviors:
                            <ol type="a">
                              <li>Continuing to engage in conversation with a user that has specifically has requested for said engagement with that user to cease and desist may be considered harassment, regardless of platform-specific privacy tools employed.</li>
                              <li>Aggregating, posting, and/or disseminating a person's demographic, personal, or private data without express permission (informally called doxing or dropping dox) may be considered harassment.</li>
                              <li>Inciting users to engage another user in continued interaction or discussion after a user has requested for said engagement with that user to cease and desist (informally called brigading or dogpiling) may be considered harassment.</li>
                            </ol>
                          </li>
                        </ol>
                        <p>These provisions notwithstanding, the administration of the service reserves the right to revoke any user's access permissions, at any time, for any reason, except as limited by law.</p>
                        """
    }

    var body: some View {
        FancyScrollView(
            title: "mastodon.online",
            headerHeight: 300,
            scrollUpHeaderBehavior: .parallax,
            scrollDownHeaderBehavior: .sticky,
            header: {
                Image("mastodon.online")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        ) {

            VStack(alignment: .leading) {

                HStack {

                    VStack(alignment: .leading) {

                        Text("7.96k")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))

                        Text("Online")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    VStack(alignment: .leading) {

                        Text("30k")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))

                        Text("Members")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    VStack(alignment: .leading) {

                        Text("378k")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))

                        Text("Statuses")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                }
                .padding()

                Divider()
                    .padding(.leading)

                VStack(alignment: .leading, spacing: 10) {
                    Text("About")
                        .bold()
                        .font(.system(size: 20))

                    Text("This is a brand new server run by the main developers of the project as a spin-off of mastodon.social. It is not focused on any particular niche interest - everyone is welcome as long as you follow our code of conduct!")
                        .font(.system(size: 17))
                        
                }
                .padding(.horizontal)
                .padding(.vertical, 10)

                Divider()
                    .padding(.leading)

                VStack(alignment: .leading) {
                    Text("Admin")
                        .font(.system(size: 20, weight: .bold))

                    HStack(alignment: .top, spacing: 15) {

                        Image("amodrono")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(15)

                        VStack(alignment: .leading) {
                            Text("amodrono")
                                .font(.title2)
                                .bold()

                            Text("@amodrono")
                                .foregroundColor(.gray)

                            Spacer()

                            HStack(spacing: 5) {
                                Text("1.2k").bold() + Text(" followers –")
                                Text("1.2k").bold() + Text(" following")
                            }
                        }

                        Spacer()

                    }
                    .frame(height: 100)
                }
                .padding()

                Divider()
                    .padding(.leading)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Code of conduct")
                        .bold()
                    WebView(content: self.content)
                        .frame(width: UIScreen.main.bounds.width - 40, height: CGFloat(self.content.count) / 1.4 )
                }
                .font(.system(size: 20))
                .padding(.horizontal)
                .padding(.vertical, 10)

            }
            .toolbar(content: {
                ToolbarItem {
                    Text("JOIN")
                }
            })
        }
    }
}

struct InstanceView_Previews: PreviewProvider {
    static var previews: some View {
        InstanceView()
    }
}
