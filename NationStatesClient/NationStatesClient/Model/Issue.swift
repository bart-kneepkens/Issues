//
//  Issue.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import Foundation

struct Option {
    let id: Int
    let text: String
}

extension Option {
    init(_ dto: OptionDTO) {
        self.id = dto.id ?? 0
        self.text = dto.text ?? ""
    }
}

struct OptionDTO: Decodable {
    var id: Int?
    var text: String?
}

struct Issue: Identifiable {
    let id: Int
    let title: String
    let text: String
    let options: [Option]
}

extension Issue {
    init(_ dto: IssueDTO) {
        self.id = dto.id ?? 0
        self.title = dto.title ?? ""
        self.text = dto.text ?? ""
        self.options = dto.options.map({ Option($0) })
    }
}

struct IssueDTO: Decodable {
    var id: Int?
    var title: String?
    var author: String?
    var editor: String?
    var pic1: String?
    var pic2: String?
    var text: String?
    var options: [OptionDTO] = []
}
#if DEBUG
extension Issue {
    static let filler: Issue = Issue(id: -1,
                                     title: "Please Don’t Feed the (Copyright) Trolls",
                                     text: "Major film studio Werner Cousins recently began enforcing its copyright on the popular “Merry Birthday” song and has been demanding that everyone from schools, to small children, to your own government, pay royalties for its use. After one of the studio’s lawyers threatened to sue your secretary’s daughter for royalties, your government has finally agreed to address the issue of copyright trolling.",
                                     options: [
                                        .init(id: 0, text: "“It’s quite simple,” comments Werner Cousins’ notorious lawyer Don Taffs, with a team of well-dressed yes men behind him. “The holders of a copyright have every right to demand royalties for its use and remove all unlicensed use. Of course, you can still sing the Merry Birthday song to your kids every year; just remember to pay us instead of wasting your money on another pair of designer running shoes for little Timmy.”"),
                                        .init(id: 1, text: "“I want my Mommy to sing Merry Birthday to me... and to give me a new bicycle!” yells the visibly upset young girl as she smashes priceless family heirlooms on your desk. “Don’t listen to that evil lawyer; it’s not his song. It’s my song because it’s my birthday! Everybody should sing Merry Birthday if they want to!” The girl begins reading a cue card handed to her by her mother. “All culturally significant songs should be put into the public domain.”"),
                                        .init(id: 2, text: "“Why should we deal with copyright at all?” suggests longtime political activist Red Foreman as he hands out copies of &lt;i&gt;The Little Pinko Book&lt;/i&gt; to everyone in the room. “Nationalize the work of any author, including songs, movies, trademarks and even designs. Creativity is an important educational function, and the bourgeois copyright trolls have no right to censor it. Once the work is popular enough, it should be released into the public domain. Sure, some artists and creators might lose that financial incentive to create, but at least this copyright problem will be a thing of the past!”"),
                                        .init(id: 3, text: "“How about a system that allows fair use of copyrighted material, such as for satire and education?” muses popular WhoTube celebrity and free speech activist The Nostalgia Nerd. “This protects copyright creators from outright theft, but protects us smaller creators from censorship from the big guys. There’s a chance Werner Cousins might try to exploit it, but freedom of speech is at risk here. Surely these big studios can handle a few choice criticisms? Now if you’ll excuse me, I’m off to review &lt;i&gt;Unicorn Apocalypse 4: The Rise of Mad Max!&lt;/i&gt;”"),
                                     ])
}
#endif
