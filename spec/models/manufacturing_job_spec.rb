RSpec.describe ManufacturingJob do
  before(:each) do
    @client = Client.create!(name: 'client')
    @job = @client.jobs.create!(name: 'job')
    @phase = @job.phases.create!(name: 'phase')
  end

  it 'creates nest runs' do
    @structure = @phase.structures.create!(
      name: '1', quick_w: 300, quick_h: 48, quick_l: 40)
    # ap @structure.parts.pluck(:id)
    # mj = @phase.manufacturing_jobs.new(part_ids: @structure.parts.pluck(:id))
    # mj.save!
    # tp mj.nest_runs
  end
end
