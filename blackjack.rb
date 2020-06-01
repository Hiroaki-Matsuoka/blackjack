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

    me = User.new(money:100000, paymoney: 0, hand: [], totalscore: [])
    dealer = Dealer.new(hand: [], totalscore: [])
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

    hand_limit = 7
    draw_times = 0
    loop_flg = 0

    puts "deckからカードをドローします"

    # 初回のカードドロー処理
    def first_draw(decks, me, dealer)
      draw_card = decks.cards.shift(2)
      puts "#{draw_card}"
      draw_card.each do |n|
        card = decks.card_judge(n)
        me.hand.push(n)
        me.totalscore << card[0]
      end

      del_draw_card = decks.cards.shift(2)
      puts "#{del_draw_card}"

      del_draw_card.each do |n|
        del_card = decks.card_judge(n)
        dealer.hand.push(n)
        dealer.totalscore << del_card[0]
      end
    end
    # 初回カードのドロー処理ここまで

    if draw_times == 0
      first_draw(decks, me, dealer)
      draw_times = 1
    end

    def open_hand(me, dealer, decks)
      puts "------ディーラーの手札一覧(#{dealer.hand.length}枚)------"
      i = 0
      while i < dealer.hand.length do
        puts "#{decks.card_judge(dealer.hand[i])[1]} #{decks.card_judge(dealer.hand[i])[2]}"
        i += 1
      end
      puts "TotalScore：#{dealer.totalscore.sum}"

      puts "------あなたの手札一覧(#{me.hand.length}枚)------"
      i = 0
      while i < me.hand.length do
        puts "#{decks.card_judge(me.hand[i])[1]} #{decks.card_judge(me.hand[i])[2]}"
        i += 1
      end
      puts "TotalScore：#{me.totalscore.sum}"
      puts "----------------------------------"
    end

    while loop_flg == 0 do
      puts "deckからカードをドローします"
      puts "deckの残り枚数は#{decks.cards.length}枚"
      puts ""
    open_hand(me, dealer, decks)
      if decks.cards.length == 0
        # デッキを使い切った時の挙動
        puts "deckをつかいきりました"
        loop_flg = 1
      elsif me.hand.length >= hand_limit
        # 手札上限チェック
        puts "上限を超えているのでドローできません"
        puts "Y:HIT   N:STAND   [Y/N]"
        response = gets
        case response
        when /^[yY]/
          me.hand = []
        when /^[nN]/
          loop_flg = 1
        end
      else
        # 行動選択
        puts "Y:HIT   N:STAND   [Y/N]"
        response = gets
        case response
        when /^[yY]/
          draw_card = decks.cards.shift(1)
          card = decks.card_judge(draw_card[0])
          me.hand.push(draw_card[0])
          me.totalscore << card[0]
          if dealer.totalscore.sum <= 17
            del_card = decks.card_judge(draw_card[0])
            dealer.hand.push(draw_card[0])
            dealer.totalscore << del_card[0]
          end
          open_hand(me, dealer, decks)
          if me.totalscore.sum == 21
            puts "BlackJack!!"
            puts "あなたの勝ちです"
            exit
          elsif me.totalscore.sum > 21
            puts "バーストしました"
            exit
          end
        when /^[nN]/
          loop_flg = 1
        open_hand(dealer, decks, me)
          if me.totalscore.sum < dealer.totalscore.sum
            puts "あなたは負けました"
          else
            puts "あなたの勝ち！"
          end
        end
      end
    end
  end
end
