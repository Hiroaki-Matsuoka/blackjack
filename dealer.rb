class Dealer
  attr_accessor :hand, :totalscore

  def initialize(**params)
    @hand = params[:hand]
    @totalscore = params[:totalscore]
  end

end
