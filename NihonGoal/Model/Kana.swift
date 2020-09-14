//
//  Kana.swift
//  NihonGoal
//
//  Created by kuroro on 06/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import Foundation

struct KanaDatasType {
    let title: String
    let kanaTab: [[String]]
    let letterTab: [[String]]
}

class Kana {
    // MARK: Properties
    
    // --------------------------------------------- Hiragana ---------------------------------------------
    let hiraganaTab = [["あ", "い", "う", "え", "お"], ["か", "き", "く", "け", "こ"], ["さ", "し", "す", "せ", "そ"], ["た", "ち", "つ", "て", "と"], ["な", "に", "ぬ", "ね", "の"], ["は", "ひ", "ふ", "へ", "ほ"], ["ま", "み", "む", "め", "も"], ["や", " ", "ゆ", " ", "よ"], ["ら", "り", "る", "れ", "ろ"], ["わ", " ", " ", " ", "を"], ["ん", "", "", "", ""]]
    let hiraganaDerives = [["が", "ぎ", "ぐ", "げ", "ご"], ["ざ", "じ", "ず", "ぜ", "ぞ"], ["だ", "ぢ", "づ", "で", "ど"], ["ば", "び", "ぶ", "べ", "ぼ"], ["ぱ", "ぴ", "ぷ", "ぺ", "ぽ"]]
    
    let hiraganaDiphtongues = [["きゃ", "", "きゅ", "", "きょ"], ["しゃ", "", "しゅ", "", "しょ"], ["ちゃ", "", "ちゅ", "", "ちょ"], ["にゃ", "", "にゅ", "", "にょ"], ["ひゃ", "", "ひゅ", "", "ひょ"], ["みゃ", "", "みゅ", "", "みょ"], ["りゃ", "", "りゅ", "", "りょ"]]
    
    let hiraganaDerivesDiphtongues = [["ぎゃ", "", "ぎゅ", "", "ぎょ"], ["じゃ", "", "じゅ", "", "じょ"], ["びゃ", "", "びゅ", "", "びょ"], ["ぴゃ", "", "ぴゅ", "", "ぴょ"]]
    
    // --------------------------------------------- Katakana ---------------------------------------------
    let katakanaTab = [["ア", "イ", "ウ", "エ", "オ"], ["カ", "キ", "ク", "ケ", "コ"], ["サ", "シ", "ス", "セ", "ソ"], ["タ", "チ", "ツ", "テ", "ト"], ["ナ", "ニ", "ヌ", "ネ", "ノ"], ["ハ", "ヒ", "フ", "ヘ", "ホ"], ["マ", "ミ", "ム", "メ", "モ"], ["ヤ", "", "ユ", "", "ヨ"], ["ラ", "リ", "ル", "レ", "ロ"], ["ワ", "", "", "", "ヲ"], ["ン", "", "", "", ""]]
    let katakanaDerives = [["ガ", "ギ", "グ", "ゲ", "ゴ"], ["ザ", "ジ", "ズ", "ゼ", "ゾ"], ["ダ", "ヂ",  "ヅ", "デ", "ド"], ["バ", "ビ", "ブ", "ベ", "ボ"], ["パ", "ピ", "プ", "ペ", "ポ"]]
    let katakanaDiphtongues = [["キャ", "", "キュ", "", "キョ"], ["シャ", "", "シュ", "", "ショ"], ["チャ", "", "チュ", "", "チョ"], ["ニャ", "", "ニュ", "", "ニョ"], ["ヒャ", "", "ヒュ", "", "ヒョ"], ["ミャ", "", "ミュ", "", "ミョ"], ["リャ", "", "リュ", "", "りょ"]]
    let katakanaDerivesDiphtongues = [["ギャ", "", "ギュ", "", "ギョ"], ["ジャ", "", "ジュ", "", "ジョ"], ["ビャ", "", "ビュ", "", "ビョ"], ["ピャ", "", "ピュ", "", "ピョ"]]
    
    // --------------------------------------------- Traduction ---------------------------------------------
    let letterTab = [["a", "i", "u", "e", "o"], ["ka", "ki", "ku", "ke", "ko"], ["sa", "shi", "su", "se", "so"], ["ta", "chi", "tsu", "te", "to"], ["na", "ni", "nu", "ne", "no"], ["ha", "hi", "fu", "he", "ho"], ["ma", "mi", "mu", "me", "mo"], ["ya", "", "yu", "", "yo"], ["ra", "ri", "ru", "re", "ro"], ["wa", "", "", "", "wo"], ["n", "", "", "", ""]]
    let letterDerives = [["ga", "gi", "gu", "ge", "go"], ["za", "ji", "zu", "ze", "zo"], ["da", "ji", "zu", "de", "do"], ["ba", "bi", "bu", "be", "bo"], ["pa", "pi", "pu", "pe", "po"]]
    let letterDiphtongues = [["kya", "", "kyu", "", "kyo"], ["sha", "", "shu", "", "sho"], ["cha", "", "chu", "", "cho"], ["nya", "", "nyu", "", "nyo"], ["hya", "", "hyu", "", "hyo"], ["mya", "", "myu", "", "myo"], ["rya", "", "ryu", "", "ryo"]]
    let letterDerivesDiphtongues = [["gya", "", "gyu", "", "gyo"], ["ja", "", "ju", "", "jo"], ["bya", "", "byu", "", "byo"], ["pya", "", "pyu", "", "pyo"]]
    
    // MARK: Methods
    func setTab(tab: [[String]]) -> [String] {
        var fullTab = [[String]]()
        var transitionTab = [String]()
        var finalTab = [String]()

        fullTab = tab

        transitionTab = fullTab.flatMap({ $0 })

        for kana in transitionTab where kana != "" && kana != " " {
            finalTab.append(kana)
        }

        return finalTab
    }

    func deleteValueFromTab(tab: [String], index: Int) -> [String] {
        var transitionTab = tab

        transitionTab.remove(at: index)

        return transitionTab
    }

    func pullOutRandomNumber(from: Int, to: Int) -> Int {
        return Int.random(in: from...to)
    }
}
