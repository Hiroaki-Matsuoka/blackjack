class Deck
  attr_accessor :cards, :card_num, :card_mark, :disp_num
  def initialize(**params)
    @cards = params[:cards]
    @card_num = params[:card_num]
    @card_mark = params[:card_mark]
    @disp_num = params[:disp_num]
  end
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

    if card_num >= 11
      card_num = 10
    end

    return card_num, card_mark, disp_num
  end

  def deck_shuffle
    deck = [*(1..52)]
    return deck.shuffle!
    puts ""
  end

end
