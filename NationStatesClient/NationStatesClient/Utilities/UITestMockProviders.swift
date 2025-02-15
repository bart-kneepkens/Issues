//
//  UITestMockProviders.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 15/02/2021.
//

import Foundation

// TODO: remove DEBUG directive because it also needs to work for release test builds
#if DEBUG
struct UITestMockProviders {
    static var issueProvider: IssueProvider {
        MockedIssueProvider(issues: [
            .init(id: 1015, title: "Protestors Have Gone Too Far, Claim Police", text: "A group protesting against the Elest Adran government began a riot yesterday which resulted in the death of Mr. Benson, a police officer.", options: [
                .init(id: 0, text: "“This is an outrage!” cries Police Chief Hope Kowalski. “The people of Elest Adra just don’t know how good they have it! Our nation is a gem compared to many others, but if you give an inch they will take a mile. I had to tell officer Benson’s wife yesterday that their children will grow up without a father. Do I think public protests should be outlawed? You’re damn right I do.”"),
                .init(id: 1, text: "“It all happened so fast,” says Matt Rolfe, one of the protesters. “The crowd was just chanting, you know... and then they tear gassed us. I saw one cop, this Mr. Benson, club a teenager right in the face! For what? Speaking his mind! That’s when the crowd rushed him. I’m sorry he’s dead, but the police think they have a right to do whatever they want - things get out of hand sometimes. I think the police department should keep out of the way when we’re protesting - even if things do get... excited.”"),
                .init(id: 2, text: "“It’s because protests get out of hand sometimes that we need a police presence,” argues PC Siko Strength eventually after singing the national anthem to you. “Even violent protestors have a right to feel safe on the streets. If that means we have to die to protect the innocent, then that means we have to die. I think protests should be restricted to a designated area where police can keep an eye on the protestors. Then everything can go nice and smoothly and no one will have to worry about being beaten to death.”"),
            ], imageName: "p21"),
            .init(id: 1016, title: "Referenda: Are They Right for Elest Adra?", text: "", options: [], imageName: ""),
            .init(id: 1017, title: "Teenage Kicks", text: "", options: [], imageName: ""),
            .init(id: 1018, title: "A Textbook Cover-Up?", text: "", options: [], imageName: ""),
        ], answerResult: .filler, delay: 0)
    }
    
    static var completedIssueProvider: CompletedIssueProvider {
        MockedCompletedIssueProvider()
    }
    
    static var nationDetailsProvider: NationDetailsProvider {
        MockedNationDetailsProvider()
    }
    
    static var resolutionProvider: ResolutionProvider {
        let htmlText = """
        <div class="WA_thing_body"><p>The General Assembly,</p><p>Believing that access to encryption and other secure communication methods in the digital age yields numerous benefits in areas such as personal privacy, consumer protection, and ensuring the integrity of data that is transmitted from one party to another,</p><p>Seeking to prevent governments from restricting, compromising or hindering the access and usage of encrypted communication protocols and other means of achieving secure data exchanges,</p><p>Hereby:</p><p></p><ol><li><p>Defines for the purposes of this resolution: </p><ol style="list-style-type:lower-latin"><li><p>Encryption as any method which utilizes ciphers to protect the integrity of communications or any other digital data by rendering unencrypted data known as 'plaintext' into an indecipherable form known as 'ciphertext'; which can then only be rendered legible by using a decryption key available to authorized parties, thus denying access to unauthorized parties, and</p></li><li><p>A secure communication method as a relay, protocol, or standard other than an encryption method intended for communication or otherwise transmitting data and information between two or more digital devices that is intended to prevent the interception of this data or information by any unauthorized parties,</p></li></ol><p></p><p></p></li><li><p>Prohibits member states from:</p><ol style="list-style-type:lower-latin"><li><p>Banning or restricting user access to any encryption method or other secure communication method, and from enacting any prohibitions upon the implementation of encryption methods or secure communication methods, subject to Article 3, or</p></li><li><p>Acting to reduce the strength of any encryption method or secure communication method, or</p></li><li><p>Requiring the usage of insecure encryption methods, technologies, or standards, or</p></li><li><p>Requiring the insertion of "backdoors" into technologies, tools, or standards that allow states access to private communications through compromised methods of secure communication, or</p></li><li><p>Requiring third parties to implement methods that would grant an unauthorized party access to secure, private communications between authorized parties,</p></li></ol><p></p><p></p></li><li><p>Permits member states to restrict user access to secure communication methods provided that:</p><ol style="list-style-type:lower-latin"><li><p>These secure communication methods were originally intended for government or military use, and that </p></li><li><p>A significant detriment upon the strength or reliability of such secure communication methods can be foreseen or observed as a result of removing restrictions on user access to those outside the government or military,</p></li></ol><p></p><p></p></li><li><p>Clarifies that:</p><ol style="list-style-type:lower-latin"><li><p>Encryption methods may not be banned or restricted under any circumstances,</p></li><li><p>The foreseen or observed detriment upon the strength or reliability of secure communication methods required by Article 3(b) to restrict user access to secure communication methods originally intended for government or military use must be sufficient enough to render such secure communication methods either:</p><ol style="list-style-type:lower-roman"><li><p>Incapable of protecting the privacy and integrity of communications using this secure communication method, or</p></li><li><p>Unreliable to the extent that communications using this secure communication method are unlikely to reach their intended recipient(s), and that</p></li></ol><p></p></li><li><p>Member states shall not use any form of coercion in order to bypass any prohibition under Article 2.</p></li></ol><p></p></li></ol><p></p></div>
        """
        
        return MockedResolutionProvider(generalAssemblyResolution: .init(category: "Civil Rights", created: Date(), id: "0", name: "Right To Secure Digital Communication", option: "", promoted: Date(), proposedBy: "elest_adra", totalVotesAgainst: 2054, totalVotesFor: 10621, information: .init(localId: "localId", textHTML: htmlText)), delay: 0)
    }
    
    static var authenticationProvider: AuthenticationProvider {
        MockedAuthenticationProvider(success: true, delay: 0)
    }
    
    static var authenticationContainer: AuthenticationContainer {
        MockedAuthenticationContainer()
    }
    
    static var regionDetailsProvider: RegionDetailsProvider {
        MockedRegionDetailsProvider()
    }
    
    static var notificationFeatureInterestProvider: NotificationFeatureInterestProvider {
        MockedNotificationFeatureInterestProvider()
    }
}
#endif
