require "./user"
require "./dealer"
require "./deck"

class Blackjack

  def start
    
    puts <<~TEXT
    -------------------------------------
         　　　　ブラックジャック
    -------------------------------------
    TEXT

    me = User.new(money:100000, paymoney: 0, hand: [], totalscore: 0)
    dealer = Dealer.new(hand: [], totalscore: 0)
    decks = Deck.new(cards: [],card_num: nil, card_mark: nil, disp_num: nil)

    @money = me.money

    puts "あなたの所持金は#{@money}円です"
    puts "掛け金を入力してください"
    me.paymoney = gets.to_i
    @money -= me.paymoney
    puts "#{me.paymoney}円を掛けました"
    puts "残金：#{@money}"


    puts "デッキをシャッフルします"
    decks.cards = decks.deck_shuffle
    puts "#{decks.cards}"

    # 手札の設定

    me.hand = []
    hand_limit = 7
    me.totalscore = []
    # ドローのループ
    loop_flg = 0
    while loop_flg == 0 do
      # カードをドローする
      puts "deckからカードをドローします"
      # puts "#{decks.cards}"
      draw_card = decks.cards.shift(1)
      # cardにはcard_num,card_mark,disp_numが入ってる
      card = decks.card_judge(draw_card[0])

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
      # puts "deckの残り枚数は#{deck.length}枚"
      puts ""

      # 手札の表示をさせる
      me.hand.push(draw_card[0])
      puts "------あなたの手札一覧(#{me.hand.length}枚)------"
      i = 0
      # 手持ちのカード枚数分詳細を表示
      while i < me.hand.length do
        # handには１〜５２の乱数が格納されている
        # 下記はcard_judgeを同じ数字でもう一度行なっている
        puts "#{decks.card_judge(me.hand[i])[1]} #{decks.card_judge(me.hand[i])[2]}"
        i += 1
      end
      puts "TotalScore：#{me.totalscore.sum}"
      puts "handの中身#{me.hand}"
      puts "----------------------------------"

      if decks.cards.length == 0
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
