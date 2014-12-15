after 'release:curriculums_subjects' do
  Curriculums::Subject.find_by_name('语文').tap do |subject|
    subject.phases.find_or_create_by(name: '一年级')
    subject.phases.find_or_create_by(name: '二年级')
  end
  Curriculums::Subject.find_by_name('数学').tap do |subject|
    subject.phases.find_or_create_by(name: '一年级')
    subject.phases.find_or_create_by(name: '二年级')
    subject.phases.find_or_create_by(name: '三年级')
  end
  Curriculums::Subject.find_by_name('英语').tap do |subject|
    subject.phases.find_or_create_by(name: '初级')
    subject.phases.find_or_create_by(name: '中级')
    subject.phases.find_or_create_by(name: '高级')
  end
end