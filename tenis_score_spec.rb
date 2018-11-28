require './tenis_score'
RSpec.describe TenisScore do
  describe '#list' do
    subject do
      tenis_score = TenisScore.new
      tenis_score.configuration(conf)
      tenis_score.win_LEFT
      tenis_score.list
    end
    context 'when side_LEFT win' do
      let(:conf){}
      it {is_expected.to eq [[0, 0, 1], [0, 0, 0]]}
    end
  end
  
  xdescribe '#status' do
  end
end
