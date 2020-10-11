//
//  AnswerIssueResponseXMLParserTests.swift
//  NationStatesClientTests
//
//  Created by Bart Kneepkens on 11/10/2020.
//

import XCTest
@testable import NationStatesClient

class AnswerIssueResponseXMLParserTests: XCTestCase {
    
    let OK_RESPONSE = """
        <NATION id="elest_adra">
    <ISSUE id="991" choice="1">
        <OK>1</OK>
        <DESC>charities reserve the right to not help those who go against religious teachings</DESC>
        <RANKINGS>
            <RANK id="1">
                <SCORE>73.75</SCORE>
                <CHANGE>-0.50</CHANGE>
                <PCHANGE>-0.673401</PCHANGE>
            </RANK>
            <RANK id="4">
                <SCORE>15.81</SCORE>
                <CHANGE>-0.46</CHANGE>
                <PCHANGE>-2.827289</PCHANGE>
            </RANK>
            <RANK id="5">
                <SCORE>30.58</SCORE>
                <CHANGE>0.01</CHANGE>
                <PCHANGE>0.032712</PCHANGE>
            </RANK>
            <RANK id="10">
                <SCORE>7699.07</SCORE>
                <CHANGE>-50.65</CHANGE>
                <PCHANGE>-0.653572</PCHANGE>
            </RANK>
            <RANK id="11">
                <SCORE>3498.07</SCORE>
                <CHANGE>-23.01</CHANGE>
                <PCHANGE>-0.653493</PCHANGE>
            </RANK>
            <RANK id="12">
                <SCORE>5070.12</SCORE>
                <CHANGE>-33.36</CHANGE>
                <PCHANGE>-0.653672</PCHANGE>
            </RANK>
            <RANK id="13">
                <SCORE>3317.49</SCORE>
                <CHANGE>-21.82</CHANGE>
                <PCHANGE>-0.653428</PCHANGE>
            </RANK>
            <RANK id="14">
                <SCORE>4131.21</SCORE>
                <CHANGE>-27.18</CHANGE>
                <PCHANGE>-0.653618</PCHANGE>
            </RANK>
            <RANK id="15">
                <SCORE>2920.33</SCORE>
                <CHANGE>-19.21</CHANGE>
                <PCHANGE>-0.653504</PCHANGE>
            </RANK>
            <RANK id="16">
                <SCORE>2378.57</SCORE>
                <CHANGE>-15.65</CHANGE>
                <PCHANGE>-0.653658</PCHANGE>
            </RANK>
            <RANK id="17">
                <SCORE>5243.50</SCORE>
                <CHANGE>-34.50</CHANGE>
                <PCHANGE>-0.653657</PCHANGE>
            </RANK>
            <RANK id="18">
                <SCORE>359.92</SCORE>
                <CHANGE>-2.36</CHANGE>
                <PCHANGE>-0.651430</PCHANGE>
            </RANK>
            <RANK id="20">
                <SCORE>6447.19</SCORE>
                <CHANGE>-42.41</CHANGE>
                <PCHANGE>-0.653507</PCHANGE>
            </RANK>
            <RANK id="21">
                <SCORE>4381.58</SCORE>
                <CHANGE>-28.83</CHANGE>
                <PCHANGE>-0.653681</PCHANGE>
            </RANK>
            <RANK id="22">
                <SCORE>3630.46</SCORE>
                <CHANGE>-23.88</CHANGE>
                <PCHANGE>-0.653470</PCHANGE>
            </RANK>
            <RANK id="23">
                <SCORE>500.75</SCORE>
                <CHANGE>-3.30</CHANGE>
                <PCHANGE>-0.654697</PCHANGE>
            </RANK>
            <RANK id="24">
                <SCORE>3286.19</SCORE>
                <CHANGE>-21.62</CHANGE>
                <PCHANGE>-0.653605</PCHANGE>
            </RANK>
            <RANK id="25">
                <SCORE>7424.95</SCORE>
                <CHANGE>-63.02</CHANGE>
                <PCHANGE>-0.841617</PCHANGE>
            </RANK>
            <RANK id="26">
                <SCORE>15147.76</SCORE>
                <CHANGE>-99.66</CHANGE>
                <PCHANGE>-0.653619</PCHANGE>
            </RANK>
            <RANK id="29">
                <SCORE>782.43</SCORE>
                <CHANGE>-5.14</CHANGE>
                <PCHANGE>-0.652640</PCHANGE>
            </RANK>
            <RANK id="30">
                <SCORE>1173.64</SCORE>
                <CHANGE>-7.72</CHANGE>
                <PCHANGE>-0.653484</PCHANGE>
            </RANK>
            <RANK id="31">
                <SCORE>78.24</SCORE>
                <CHANGE>-0.52</CHANGE>
                <PCHANGE>-0.660234</PCHANGE>
            </RANK>
            <RANK id="33">
                <SCORE>6.33</SCORE>
                <CHANGE>0.18</CHANGE>
                <PCHANGE>2.926829</PCHANGE>
            </RANK>
            <RANK id="35">
                <SCORE>64.13</SCORE>
                <CHANGE>-0.39</CHANGE>
                <PCHANGE>-0.604464</PCHANGE>
            </RANK>
            <RANK id="42">
                <SCORE>52.75</SCORE>
                <CHANGE>0.06</CHANGE>
                <PCHANGE>0.113874</PCHANGE>
            </RANK>
            <RANK id="43">
                <SCORE>39.21</SCORE>
                <CHANGE>0.26</CHANGE>
                <PCHANGE>0.667522</PCHANGE>
            </RANK>
            <RANK id="44">
                <SCORE>72.08</SCORE>
                <CHANGE>-0.03</CHANGE>
                <PCHANGE>-0.041603</PCHANGE>
            </RANK>
            <RANK id="45">
                <SCORE>18.61</SCORE>
                <CHANGE>-0.25</CHANGE>
                <PCHANGE>-1.325557</PCHANGE>
            </RANK>
            <RANK id="46">
                <SCORE>1173.64</SCORE>
                <CHANGE>-7.72</CHANGE>
                <PCHANGE>-0.653484</PCHANGE>
            </RANK>
            <RANK id="47">
                <SCORE>35.13</SCORE>
                <CHANGE>0.07</CHANGE>
                <PCHANGE>0.199658</PCHANGE>
            </RANK>
            <RANK id="48">
                <SCORE>69.62</SCORE>
                <CHANGE>-0.76</CHANGE>
                <PCHANGE>-1.079852</PCHANGE>
            </RANK>
            <RANK id="49">
                <SCORE>5.51</SCORE>
                <CHANGE>0.02</CHANGE>
                <PCHANGE>0.364299</PCHANGE>
            </RANK>
            <RANK id="50">
                <SCORE>124.91</SCORE>
                <CHANGE>-0.13</CHANGE>
                <PCHANGE>-0.103967</PCHANGE>
            </RANK>
            <RANK id="53">
                <SCORE>249.10</SCORE>
                <CHANGE>3.88</CHANGE>
                <PCHANGE>1.582253</PCHANGE>
            </RANK>
            <RANK id="56">
                <SCORE>73.78</SCORE>
                <CHANGE>-0.11</CHANGE>
                <PCHANGE>-0.148870</PCHANGE>
            </RANK>
            <RANK id="57">
                <SCORE>156.49</SCORE>
                <CHANGE>-1.02</CHANGE>
                <PCHANGE>-0.647578</PCHANGE>
            </RANK>
            <RANK id="58">
                <SCORE>212.28</SCORE>
                <CHANGE>3.46</CHANGE>
                <PCHANGE>1.656929</PCHANGE>
            </RANK>
            <RANK id="59">
                <SCORE>1.91</SCORE>
                <CHANGE>-0.01</CHANGE>
                <PCHANGE>-0.520833</PCHANGE>
            </RANK>
            <RANK id="61">
                <SCORE>9.84</SCORE>
                <CHANGE>-0.01</CHANGE>
                <PCHANGE>-0.101523</PCHANGE>
            </RANK>
            <RANK id="64">
                <SCORE>68.68</SCORE>
                <CHANGE>-1.57</CHANGE>
                <PCHANGE>-2.234875</PCHANGE>
            </RANK>
            <RANK id="67">
                <SCORE>36.39</SCORE>
                <CHANGE>0.25</CHANGE>
                <PCHANGE>0.691754</PCHANGE>
            </RANK>
            <RANK id="68">
                <SCORE>59.30</SCORE>
                <CHANGE>-0.24</CHANGE>
                <PCHANGE>-0.403090</PCHANGE>
            </RANK>
            <RANK id="72">
                <SCORE>74518.89</SCORE>
                <CHANGE>-504.44</CHANGE>
                <PCHANGE>-0.672378</PCHANGE>
            </RANK>
            <RANK id="73">
                <SCORE>16080.88</SCORE>
                <CHANGE>171.08</CHANGE>
                <PCHANGE>1.075312</PCHANGE>
            </RANK>
            <RANK id="74">
                <SCORE>254191.00</SCORE>
                <CHANGE>-4690.00</CHANGE>
                <PCHANGE>-1.811643</PCHANGE>
            </RANK>
            <RANK id="75">
                <SCORE>1095.40</SCORE>
                <CHANGE>-7.20</CHANGE>
                <PCHANGE>-0.653002</PCHANGE>
            </RANK>
            <RANK id="76">
                <SCORE>117963000000000.02</SCORE>
                <CHANGE>-799000000000.00</CHANGE>
                <PCHANGE>-0.672774</PCHANGE>
            </RANK>
            <RANK id="77">
                <SCORE>14.72</SCORE>
                <CHANGE>-0.05</CHANGE>
                <PCHANGE>-0.338524</PCHANGE>
            </RANK>
            <RANK id="79">
                <SCORE>588600000000.00</SCORE>
                <CHANGE>10200000000.00</CHANGE>
                <PCHANGE>1.763485</PCHANGE>
            </RANK>
            <RANK id="85">
                <SCORE>70420.35</SCORE>
                <CHANGE>-476.70</CHANGE>
                <PCHANGE>-0.672383</PCHANGE>
            </RANK>
        </RANKINGS>
        <RECLASSIFICATIONS>
            <RECLASSIFY type="1">
                <FROM>Very Strong</FROM>
                <TO>Strong</TO>
            </RECLASSIFY>
        </RECLASSIFICATIONS>
        <HEADLINES>
            <HEADLINE>Leader Honored With New Statue </HEADLINE>
            <HEADLINE>Modern Generation Lacks Patience, Artisan Basket Weavers Say</HEADLINE>
            <HEADLINE>Military Base Converted To Well-Defended Retirement Village</HEADLINE>
            <HEADLINE>Demonstration Ends In Reasonable Discussion, Handshakes</HEADLINE>
        </HEADLINES>
    </ISSUE>
    </NATION>
    """
    
    func testOkResponse() throws {
        let parser = AnswerIssueResponseXMLParser(OK_RESPONSE.data(using: .utf8)!)
        parser.parse()
        
        XCTAssert(parser.ok == true)
        XCTAssert(parser.text == "charities reserve the right to not help those who go against religious teachings")
    }
    
}
