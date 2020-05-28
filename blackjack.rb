require "./user"
require "./dealer"

class Blackjack

  def start
    puts <<~TEXT
    -------------------------------------
         　　　　ブラックジャック
    -------------------------------------
    TEXT

    # カード判定
    def card_judge(i)
      if i % 13 == 0
        mark_no = (i / 13) - 1
      else
        mark_no = i / 13
      end

      case mark_no
      when 0
        card_mark = "Spade"
      when 1
        card_mark = "Heart"
      when 2
        card_mark = "Diamond"
      when 3
        card_mark = "Crab"
      else
        puts "Error"
        exit
      end
      # カードの数値取得

      card_num = i - ( 13 * mark_no)
       # カードの種類
      disp_list = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
      # インデックス番号を元にdisp_numから文字列で番号取得
      disp_num = disp_list[(card_num - 1)]

      if card_num > 11
        card_num = 10
      end

      return card_num, card_mark, disp_num
    end

    me = User.new(money:100000, paymoney: 0, hand: [], totalscore: 0)
    dealer = Dealer.new(hand: [], totalscore: 0)

    @money = me.money

    puts "あなたの所持金は#{@money}円です"
    puts "掛け金を入力してください"
    me.paymoney = gets.to_i
    @money -= me.paymoney
    puts "#{me.paymoney}円を掛けました"
    puts "残金：#{@money}"
    puts "デッキをシャッフルします"

    deck = [*(1..52)]
    deck.shuffle!
    puts ""

    # 手札の設定

    me.hand = []
    hand_limit = 7
    me.totalscore = []
    # ドローのループ
    loop_flg = 0
    while loop_flg == 0 do
      # カードをドローする
      puts "deckからカードをドローします"
      draw_card = deck.shift(1)
      # cardにはcard_num,card_mark,disp_numが入ってる
      card = card_judge(draw_card[0])

      # if文の中に入れると２１超えてもバーストしないので手前に出しておく
      me.totalscore << card[0]
      # puts "合計：#{me.totalscore.sum}"
      if me.totalscore.sum < 21

      elsif me.totalscore.sum == 21
        puts "BlackJack!!"
        puts "あなたの勝ちです"
        exit
      else
        puts "バーストしました"
        exit
      end

      puts "#{card[1]} #{card[2]}"
      puts "deckの残り枚数は#{deck.length}枚"
      puts ""

      # 手札の表示をさせる
      me.hand.push(draw_card[0])
      puts "------あなたの手札一覧(#{me.hand.length}枚)------"
      i = 0
      # 手持ちのカード枚数分詳細を表示
      while i < me.hand.length do
        # handには１〜５２の乱数が格納されている
        # 下記はcard_judgeを同じ数字でもう一度行なっている
        puts "#{card_judge(me.hand[i])[1]} #{card_judge(me.hand[i])[2]}"
        i += 1
      end
      puts "TotalScore：#{me.totalscore.sum}"
      puts "handの中身#{me.hand}"
      puts "----------------------------------"

      if deck.length == 0
        # デッキを使い切った時の挙動
        puts "deckをつかいきりました"
        loop_flg = 1
      elsif me.hand.length >= hand_limit
        # 手札上限チェック
        puts "上限を超えているのでドローできません"
        puts "手札を全て捨てますか？[Y/N]"
        response = gets
        case response
        when /^[yY]/
          me.hand = []
        when /^[nN]/
          loop_flg = 1
        end
      else
        # さらにドローする
        puts "ドローしますか？[Y/N]"
        response = gets
        case response
        when /^[yY]/
          puts ""
        when /^[nN]/
          loop_flg = 1
        end
      end
    end
  end
end
