require './tenis_score'
RSpec.describe TenisScore do
  describe '#list' do
    subject do
      tenis_score = TenisScore.new
      tenis_score.configuration(conf)
      tenis_score.win_LEFT
      tenis_score.list
    end
    context 'when sideA win' do
      it {is_expected eq [[0, 0, 1], [0, 0, 0]]}
    end
  end
end
