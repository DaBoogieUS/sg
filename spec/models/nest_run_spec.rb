RSpec.describe NestRun do
  before(:each) do
    @client = Client.create!(name: 'client')
    @job = @client.jobs.create!(name: 'job')
    @phase = @job.phases.create!(name: 'phase')
    @structure = @phase.structures.create!(
      name: 'testSTRUCTURE', quick_h: 48, quick_w: 40, quick_l: 40, quick_bur: true
    )
    @structure.save!
    @mfg = ManufacturingJob.create!(name: 'TEST', phase: @phase, parts: @structure.parts)
  end

  it 'creates nest runs' do
    hdpe = Material.find_by(name: 'HDPE')
    hdpe_run = @mfg.nest_runs.find_by(material_id: hdpe.id)
    tp hdpe_run.nests
  end
end
