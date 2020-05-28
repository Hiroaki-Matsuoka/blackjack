class Dealer
  attr_accessor :money, :paymoney, :hand, :totalscore

  def initialize(**params)
    @money = params[:money]
    @paymoney = params[:paymoney]
    @hand = params[:hand]
    @totalscore = params[:totalscore]
  end

end
