//
//  SignInViewModel.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    @Published var nationName: String = ""
    @Published var password: String = ""
    
    var nationNameValidPublisher: AnyPublisher<Bool, Never> {
        $nationName
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    var passwordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    func attemptSignIn() {
        Authorization.shared.nationName = nationName
        Authorization.shared.password = password
        
        IssuesService.shared.fetchIssues()
        
//        NationStates.request(for: [.issues], nation: nationName) { result in
//            print(result)
//        }
        
//        let xml = """
//            <NATION id="elest_adra">
//        <ISSUES>
//        <ISSUE id="82">
//            <TITLE>AI Researchers Rally for Android Rights</TITLE>
//            <TEXT>Following recent advances in artificial intelligence, debate has arisen in Elest Adra over whether AI’s should have the right to citizenship.</TEXT>
//            <AUTHOR>eniqcir</AUTHOR>
//            <EDITOR>salusasecondus</EDITOR>
//            <PIC1>b5</PIC1>
//            <PIC2>p2</PIC2>
//            <OPTION id="0">“Giving citizenship to computers and software programs is just downright crazy,” says citizen Harley Perkins. “Who knows if they’re even really alive? Just because some of them may look human doesn’t mean they’re equal to us. It could all just be imitation.”</OPTION>
//            <OPTION id="1">“These beings have just as much of a right to citizenship as the rest of us,” argues civil rights activist Ludwig Watts. “True, we may not be able to tell if they’re really ‘alive’, per se, but how can we tell that they aren’t? But the androids should be put at the top of the list. At least we know that they have the same viewpoint as us humans.”</OPTION>
//            <OPTION id="2">“This is craziness!” says Samus Dax, a resident interviewed by the popular news show ‘Talk o’ the Town’. “It’s just blasphemy, plain and simple! We’re, like, playin’ God here! It’s evil, man, evil! What if they turned against us? All forms of computer should be banned, dudes.”</OPTION>
//        </ISSUE>
//        <ISSUE id="500">
//            <TITLE>Please Don’t Feed the (Copyright) Trolls</TITLE>
//            <TEXT>Major film studio Werner Cousins recently began enforcing its copyright on the popular “Merry Birthday” song and has been demanding that everyone from schools, to small children, to your own government, pay royalties for its use. After one of the studio’s lawyers threatened to sue your secretary’s daughter for royalties, your government has finally agreed to address the issue of copyright trolling.</TEXT>
//            <AUTHOR>the-cid</AUTHOR>
//            <EDITOR>nation_of_quebec</EDITOR>
//            <PIC1>p1</PIC1>
//            <PIC2>e12</PIC2>
//            <OPTION id="0">“It’s quite simple,” comments Werner Cousins’ notorious lawyer Don Taffs, with a team of well-dressed yes men behind him. “The holders of a copyright have every right to demand royalties for its use and remove all unlicensed use. Of course, you can still sing the Merry Birthday song to your kids every year; just remember to pay us instead of wasting your money on another pair of designer running shoes for little Timmy.”</OPTION>
//            <OPTION id="1">“I want my Mommy to sing Merry Birthday to me... and to give me a new bicycle!” yells the visibly upset young girl as she smashes priceless family heirlooms on your desk. “Don’t listen to that evil lawyer; it’s not his song. It’s my song because it’s my birthday! Everybody should sing Merry Birthday if they want to!” The girl begins reading a cue card handed to her by her mother. “All culturally significant songs should be put into the public domain.”</OPTION>
//            <OPTION id="2">“Why should we deal with copyright at all?” suggests longtime political activist Red Foreman as he hands out copies of &lt;i&gt;The Little Pinko Book&lt;/i&gt; to everyone in the room. “Nationalize the work of any author, including songs, movies, trademarks and even designs. Creativity is an important educational function, and the bourgeois copyright trolls have no right to censor it. Once the work is popular enough, it should be released into the public domain. Sure, some artists and creators might lose that financial incentive to create, but at least this copyright problem will be a thing of the past!”</OPTION>
//            <OPTION id="3">“How about a system that allows fair use of copyrighted material, such as for satire and education?” muses popular WhoTube celebrity and free speech activist The Nostalgia Nerd. “This protects copyright creators from outright theft, but protects us smaller creators from censorship from the big guys. There’s a chance Werner Cousins might try to exploit it, but freedom of speech is at risk here. Surely these big studios can handle a few choice criticisms? Now if you’ll excuse me, I’m off to review &lt;i&gt;Unicorn Apocalypse 4: The Rise of Mad Max!&lt;/i&gt;”</OPTION>
//        </ISSUE>
//        <ISSUE id="1275">
//            <TITLE>You Cruise, You Lose?</TITLE>
//            <TEXT>For years, small towns along the nation’s coast have been popular cruise ship destinations. However, with increasingly frequent visits by overwhelming numbers of passengers, one seaside town is attempting to ban all tourist vessels from stopping there.</TEXT>
//            <AUTHOR>pogaria</AUTHOR>
//            <EDITOR>candlewhisper_archive</EDITOR>
//            <PIC1>t9</PIC1>
//            <PIC2>e8</PIC2>
//            <OPTION id="0">“These massive ships have polluted our coastal waters, driven away all the fish and caused sizeable erosion damage with their wakes,” declares Heston Khan, spokesperson for the town’s commercial fishing consortium. “My colleagues and I used to be able to make a decent living from harvesting the abundant resources of our coastal waters. But ever since these bilge-spewing behemoths started showing up, we’ve had to sail out farther and farther, and still can’t catch more than a few minnows. The only way to ensure our industry’s survival is to allow this ban to go through.”</OPTION>
//            <OPTION id="2"> “Are you insane? Those tourists bring in tons of money,” sputters restaurant owner Melissa Rikkard, drying a handful of utensils with a rag that looks dirtier than the floor. “I can charge these camera-toting cruisers five dollars for a glass of water, and twelve for a sandwich — and they’ll happily pay it! The government should be encouraging tourism with an international advertising campaign.”</OPTION>
//            <OPTION id="3">“Businesses can’t function without customers, but we need corporate responsibility from the cruise line operators. What if we just apply fines every time they violate our town’s natural beauty?” suggests local police officer Themba Zaius, opening a new bag of plastic hand restraints labeled ‘now 20&#37; more circulation-restricting!’ “Chemical pollution, constant noise, tourists urinating in the fountains — all of these abhorrent side effects can be curbed by giving local governments the power to issue punitive fines. Of course, you should also hold CEOs more directly accountable...” He twirls a pair of handcuffs with a grin on his face.</OPTION>
//        </ISSUE>
//        <ISSUE id="607">
//            <TITLE>If Your Election Lasts Longer Than Four Weeks...</TITLE>
//            <TEXT>The next election is drawing near, and over drinks you flippantly mentioned to a few Party loyalists the idea of extending the political season to a whopping sixty-nine days. Upon hearing the plan, your campaign manager immediately passed out from an overwhelming panic attack, fearing the agony of such a long campaign.</TEXT>
//            <AUTHOR>nation_of_quebec</AUTHOR>
//            <EDITOR>lenyo</EDITOR>
//            <PIC1>e11</PIC1>
//            <PIC2>c3</PIC2>
//            <OPTION id="0">“I’m not sure what you hope to gain with this,” gasps Sven van Straaten, your trusted campaign manager, while holding a cold flannel to his forehead. “The Party’s funds can only be stretched so thin, and it’s only a matter of time before one of our candidates does something outrageously stupid that sabotages our reputation. What we need to do is make sure the election dates are fixed, with a fixed length and fixed results... I mean, fixed rules on campaign spending! Once the people see how open and transparent we are, we’ll all be re-elected in a landslide.”</OPTION>
//            <OPTION id="1">“The longer, the better!” enthuses Violet Contri, one of your top donors, who is rumored to have made a killing off the Wezeltonian War. “Prolonged election campaigns will bleed the Opposition dry of their campaign funds, while giving us more time to ask for donations and publicize the competition’s scandals. I’m sure some voters will get sick of the incessant ads, but their irritation is my golden opportunity!”</OPTION>
//            <OPTION id="2">“No! No! I can’t take another election circus!” panics Chun-Li Kenobi, a refugee from the United Federation. “Where I come from, election season lasts a painful twenty-four months, and the endless mudslinging during debates and advertisements between TV shows are slowly driving everyone insane. Insane I tell you! Please, for the sake of common decency, ban all political campaigns. We’re better off not being constantly bothered by political hacks, anyways.”</OPTION>
//        </ISSUE>
//        <ISSUE id="934">
//            <TITLE>Leader, Don’t Tear Down That Wall!</TITLE>
//            <TEXT>Plans to demolish a disused widget foundry in Elest Adra City have met unexpected controversy: work by Pranksy, the famous graffiti artist, has been discovered on its walls.</TEXT>
//            <AUTHOR>bears_armed</AUTHOR>
//            <EDITOR>candlewhisper_archive</EDITOR>
//            <PIC1>r6</PIC1>
//            <PIC2>u2</PIC2>
//            <OPTION id="0">“This looks to be a previously unknown work from his early ‘puke-green stick figures’ phase,” proclaims popular art-lover and broadcaster Melvyn Blogg. “The building must be preserved in its entirety so that those masterpieces can still be seen in their rightful context!”</OPTION>
//            <OPTION id="1">“Graffiti? Bah!” exclaims Mayor Rosita Filoni. “This is just vandalism, and so-called ‘artists’ should be forced to clean it up. My cousin is in charge of the site, and I’ve given ourselves planning permission, so let’s go ahead with demolition. Economic progress can’t be held up by a few wall-doodles.”</OPTION>
//            <OPTION id="2">“Let’s compromise,” suggests Charles Sourcheese, a modern art collector. “Why not just remove the sections of the walls that bear Pranksy’s works into a suitable museum - such as, ahem, mine - and then let the rest of the old building be demolished? I’d appreciate that greatly, and you do know I’m one of your party’s most public supporters, don’t you?”</OPTION>
//        </ISSUE>
//        </ISSUES>
//        </NATION>
//        """
//
//        let parser = XMLParser(data: xml.data(using: .utf8)!)
//        let pp = IssuesXMLParser()
//        parser.delegate = pp
//
//        parser.parse()
    }
}
