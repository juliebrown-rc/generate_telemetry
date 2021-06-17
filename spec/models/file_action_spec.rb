require './models/file_action'

describe FileAction do
  before :each do
    @file_action = FileAction.new({filename: 'test_file.txt'})
  end

  it 'has a disposition, filename, and ext' do
    expect(@file_action.disposition.present?).to eq(true)
    expect(@file_action.filename.present?).to eq(true)
    expect(@file_action.ext.present?).to eq(true)
  end

  it 'updates the object data to match the process that creates the file' do
    parent_pid = @file_action.pid
    expect(@file_action.commandline).to be_blank
    @file_action.execute
    expect(@file_action.commandline).to eq("touch test_file.txt")
    expect(@file_action.pid).not_to eq(parent_pid)
  end

  it 'creates a file' do
    @file_action.execute
    expect(File.file?('test_file.txt')).to eq(true)
  end

  it 'modifies a file' do
    @file_action.disposition = :modified
    @file_action.execute
    expect(File.file?('test_file.txt')).to eq(true)
    expect(File.mtime('test_file.txt')).not_to eq(File.birthtime('test_file.txt'))
  end

  it 'deletes a file' do
    @file_action.disposition = :deleted
    @file_action.execute
    expect(File.file?('test file.txt')).to eq(false)
  end
end
