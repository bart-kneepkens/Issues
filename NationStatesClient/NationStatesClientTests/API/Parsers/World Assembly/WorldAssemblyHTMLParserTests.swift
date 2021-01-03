//
//  GeneralAssemblyHTMLParserTests.swift
//  NationStatesClientTests
//
//  Created by Bart Kneepkens on 30/12/2020.
//

import XCTest
@testable import NationStatesClient

class WorldAssemblyHTMLParserTests: XCTestCase {
    
    func testValidResponse() {
        let parser = WorldAssemblyHTMLParser(responseWithLocalId("test_local_id"))
        
        XCTAssertEqual(parser.localId, "test_local_id")
    }
    
    func testInvalidResponse() {
        let parser = WorldAssemblyHTMLParser(responseWithLocalId(nil))
        
        XCTAssert(parser.localId?.isEmpty == true)
    }
    
    func responseWithLocalId(_ id: String?) -> String {
        """
            <h1 class="pcenter"><a href="/page=ga"><img src="/images/ga.jpg" class="bigflag" alt=""> General Assembly</a></h1>
            <p class="smalldesc pcenter">Improving the World One Resolution at a Time
            <p>The oldest Council of the World Assembly, the General Assembly concerns itself with international law. Its resolutions are applied immediately upon passing in all WA member nations.
            <div class="hzln"></div>
            <div id="WAvoteendsbox"><p>Voting Closes
            <div class="countdown" id="voteends"></div>
            </div>
            <h2 class="resatvote">Resolution At Vote</h2>
            <div class="WA_thing"><div class="WA_thing_icon"><img src="/images/ga.jpg" alt=""></div><div class="WA_thing_header"><p class="WA_rtitle">General Assembly Resolution At Vote<h2><a href="/page=ga">International Radio Standards Act</a></h2><p>A resolution to enact uniform standards that protect workers, consumers, and the general public.</div>
            <div class="WA_thing_rbox"><p><span class="WA_leader">Category:</span> Regulation<p><span class="WA_leader">Area of Effect: </span> Safety<p><span class="WA_leader">Proposed by:</span> <a href="nation=merni" class="nlink"><img src="/images/flags/uploads/merni__418909t2.png" class="miniflag" alt=""><span class="nnameblock">Merni</span></a></div>
            <div class="WA_thing_body"><p>The World Assembly,<p><i>Recognising</i> that radio technology is used by many member states for communication,<p><i>Lamenting</i> the lack of international standards for radio communication,<p><i>Considering</i> the detrimental effects that a lack of standards has on international radio communication, such as incompatibilities in equipment,<p><i>Especially worried</i> that a lack of international cooperation could result in non-coordination and even interference in essential radio communications,<p><i>Aware</i> that sudden regulatory changes are likely to cause severe confusion in existing radio transmissions,<p>Hereby enacts as follows:<p><ol><li><p><b>International Radiocommunications Authority</b>: There shall be an International Radiocommunications Authority (IRA), which shall be an organ of the WA Scientific Programme.<li><p><b>Radio spectrum allocations</b>: For each member state using radio for communication, the IRA shall allocate parts of the radio spectrum for each relevant kind of communication in that state, which shall include at least public broadcasting and recreational use. The allocations shall be made considering the existing use in that state and other nearby states, in order to increase compatibility of standards between nations while minimising inconvenience to existing radio transmission. Member states shall be required to comply with these allocations after a reasonable transition period fixed by the IRA. The allocations may be changed from time to time by consultation between the IRA and member states.<li><p><b>Registry of radio transmitters</b>: Member states shall maintain a registry, revised frequently, of all persons or institutions equipped to transmit radio signals which can be recieved over long distances, and shall allocate frequencies to each of them if necessary to avoid interference of signals. Member states shall submit this registry to the IRA regularly. Member states shall make freely available all portions of the registry for which doing so would not unduly infringe on privacy or national security.<li><p><b>Restrictions on equipment</b>: <ol style="list-style-type:lower-latin"><li><p>Member states may: <ol style="list-style-type:lower-roman"><li><p>Prohibit or restrict the manufacture, sale or purchase of equipment capable of transmitting radio signals outside the ranges allocated for public broadcasting and recreational use,<li><p>Require that equipment capable of transmitting radio signals, other than equipment solely for private communication on frequencies specified for that purpose (such as mobile telephones) only be sold to persons licensed to operate such equipment, provided such licensing is widely available without unreasonable costs or restrictions,<li><p>Prohibit or restrict the manufacture, sale or purchase of equipment capable of receiving radio signals in any ranges allocated for secret military or security communication, or<li><p>Prohibit the transmission of radio signals at a power which is likely to injure or kill any sentient beings living in that area, except in a contained environment for scientific research.</ol><p><li><p>Member states may not impose unreasonable restrictions on the manufacture, sale or purchase of equipment for transmitting or receiving radio signals which are not covered by article 4a.</ol><p></ol><p></div></div><div class="WA_livevote WA_livevotebar"><div class="lvbox lvblabel">For</div><div class="lvbox"><div class="g-bar"><div class="g-bar-arrow g-bar-arrow-up">&#9660;</div><div class="g-bar-arrow g-bar-arrow-down">&#9650;</div><div class="g-bar-label t-bar-left">6,985</div><div class="g-bar-label t-bar-middle-left WA_votepos2_for">77.3% For</div><div class="g-bar-label t-bar-right">2,056</div><div class="g-bar-fill" style="width:77.259153%;"></div></div></div><div class="lvbox lvblabel">Against</div></div><p class="WA_voteperc floatrightbox">22.7%</p><p class="WA_voteperc">77.3%</p><div id="wa-chart-container"></div>
            <div id="WA_livevote_myvote">
            <form method="post" action="page=ga">
            \(id != nil ? "<input type=\"hidden\" name=\"localid\" value=\"\(id!)\">" : "")
            <p class="WA_livevote_myvote_line"><a href="nation=elest_adra" class="nlink"><img src="/images/flags/Djiboutit1.png" class="smallflag" alt=""><span class="nnameblock">Elest Adra</span></a>: <span class="WA_votepos_undecided">Undecided</span><p><button type="submit" name="vote" class="button WA_votebutton_for" value="Vote For">Vote <b>For</b></button> <button type="submit" name="vote" class="button WA_votebutton_against" value="Vote Against">Vote <b>Against</b></button> </form>
            <fieldset class="WA_livevote_rvote"><legend class="WA_livevote_myvote_reg"><a href="region=balder" class="rlink">Balder</a></legend><div class="WA_livevote WA_livevotebar"><div class="lvbox lvblabel">For</div><div class="lvbox"><div class="g-bar"><div class="g-bar-arrow g-bar-arrow-up">&#9660;</div><div class="g-bar-arrow g-bar-arrow-down">&#9650;</div><div class="g-bar-label t-bar-left">40</div><div class="g-bar-label t-bar-middle-left WA_votepos2_for">76.9% For</div><div class="g-bar-label t-bar-right">12</div><div class="g-bar-fill" style="width:76.923077%;"></div></div></div><div class="lvbox lvblabel">Against</div></div>
            <p>WA Delegate <a href="nation=north_east_somerset" class="nlink"><img src="/images/flags/uploads/north_east_somerset__842361t2.png" class="miniflag" alt=""><span class="nnameblock">North East Somerset</span></a>: <span class="WA_votepos_undecided">Undecided</span></fieldset></div><p style="clear:right"><a href="page=UN_delegate_votes/council=1">Show Delegate Votes</a>
            <p>Debate this resolution in the <a href="https://forum.nationstates.net/viewforum.php?f=9"><img src="/images/forumlink.png" class="exlink" alt="">General Assembly forum</a>.
            <h2>Last Decision</h2>
            <p>The General Assembly resolution <strong><a href="/page=WA_past_resolution/id=531/council=1">Tariffs and Trade Convention</a></strong> was passed 8,420 votes to 5,183, and implemented in all WA member nations.
            <p><a href="page=WA_past_resolutions/council=1"><span class="muchlarger">531</span> General Assembly Resolutions</a>
            <h2>Proposals</h2>
            <p>Proposals are suggestions for resolutions. Any WA member nation with at least two endorsements may
            make a proposal, which, if it gains the necessary support, will become a resolution.
            <p><a href="page=UN_proposal/council=1"><span class="muchlarger">4</span> General Assembly Proposals</a>
            <script type="text/javascript">
              var chart;
              $(document).ready(function() {
              chart = new Highcharts.Chart({
                chart: {
                renderTo: 'wa-chart-container',
                    defaultSeriesType: 'area',
                    zoomType: 'x',
                    backgroundColor: 'rgba(255, 255, 255, 0.1)'
                },
                colors: [ '#4572A7', '#AA4643' ],
                title: { text: null },
                credits: { enabled:false },
                xAxis: {
                labels: {
                    formatter: function() { return 'Day ' + (1 + Math.floor(this.value / 24)); }
                    },
                    tickInterval:24,
                    max:96
                },
                yAxis: { allowDecimals: false, title: { text: null } },
                tooltip: {
                formatter: function() { var txt; if (this.x === this.points[0].series.data.length - 1) { txt = 'Now'; } else { txt = (this.points[0].series.data.length - this.x - 1); if (txt == '1') { txt += ' hour ago'; } else { txt += ' hours ago'; } } txt += '<br><br><span style="color:#4572A7"><b>' + Highcharts.numberFormat(this.points[0].y, 0) + '</b> For</span><br><span style="color:#AA4643"><b>' + Highcharts.numberFormat(this.points[1].y, 0) + '</b> Against</span>'; return txt; },
                useHTML: true,
                shared: true
                },
                plotOptions: {
                    area: {
                    marker: { enabled: false, symbol: 'circle', radius: 2,
                           states: { hover: { enabled: true } }
                        }
                    }
                },
                legend: { floating:true, backgroundColor: 'white', layout: 'vertical',
            align:'right', verticalAlign:'middle', y:40 },
            series: [ { name: 'For', data:[0,1282,1586,1808,1986,2173,2384,2531,3936,4075,4335,4455,4619,4813,4886,5091,5877,5934,6000,6200,6257,6326,6388,6446,6518,6589,6776,6835,6878,6946,6981,6985] },{ name: 'Against', data:[0,697,1106,1203,1296,1359,1417,1473,1516,1574,1632,1649,1674,1692,1707,1735,1735,1850,1869,1881,1900,1911,1932,1954,1961,1988,2007,2020,2030,2045,2053,2056] }]
            }); });
            </script>
            <script>$(document).ready(function(){  $("#WAvoteendsbox").show(); $("#voteends").countdown({showDays:true, hideSeconds:true, timestamp:new Date(1609606800000)});});</script>
    """
    }
}
