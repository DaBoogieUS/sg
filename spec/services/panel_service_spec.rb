RSpec.describe PanelService do
  before(:each) do
    @client = Client.create!(name: 'client')
    @job = @client.jobs.create!(name: 'job')
    @phase = @job.phases.create!(name: 'phase')
    @structure = Structure.create!(
      name: 'testSTRUCTURE', phase_id: @phase.id, quick_h: 48, quick_w: 40,
      quick_l: 40
    )
    @panel_f = @structure.panels.find_by(side_position: 1)
    @panel_b = @structure.panels.find_by(side_position: 3)
  end

  it 'repositions panels' do
    @panel_f.side_position = 2
    @panel_f.save!
    expect(@panel_f.side_position).to eq(2)
    expect(@structure.panels.where(side_position: 1).last).to_not be_nil
    expect(@structure.panels.where(side_position: 3).last).to_not be_nil
    expect(@structure.panels.where(side_position: 4).last).to_not be_nil
  end

  it 'generates side parts' do
    side_ids = @structure.parts.pluck(:id).to_a
    @panel_f.width = 30
    @panel_f.save!
    expect(@structure.parts.pluck(:id).to_a).to_not eq(side_ids)
  end
end
