describe "A Line layer" do
  before(:each) do
    @layer = Scruffy::Layers::Line.new(:title => 'My Line Layer', :points => [100, 200, 300])
    
    svg = mock('svg')
    svg.should_receive(:polyline).once
    svg.should_receive(:circle).exactly(3).times
    
  end
end