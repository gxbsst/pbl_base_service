after 'release:curriculums_phases' do
  Curriculums::Subject.find_by_name('语文').tap do |subject|
    subject.phases.find_by_name('一年级').tap do |phase|
      phase.standards.find_or_create_by(title: '课程标准1').tap do |standard|
        standard.items.find_or_create_by(content: '课程标准条目1.1')
        standard.items.find_or_create_by(content: '课程标准条目1.2')
        standard.items.find_or_create_by(content: '课程标准条目1.3')
      end
      phase.standards.find_or_create_by(title: '课程标准2').tap do |standard|
        standard.items.find_or_create_by(content: '课程标准条目2.1')
        standard.items.find_or_create_by(content: '课程标准条目2.2')
        standard.items.find_or_create_by(content: '课程标准条目2.3')
      end
    end
  end
end