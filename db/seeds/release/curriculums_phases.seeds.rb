after 'release:curriculums_subjects' do
  Curriculums::Subject.find_by_name('计算机').tap do |subject|
    subject.phases.find_or_create_by(name: '一年级')
  end
end