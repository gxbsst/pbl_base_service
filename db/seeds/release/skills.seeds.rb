Skills::Category.find_or_create_by(name: '技能种类1').tap do |category|
  category.sub_categories.find_or_create_by(name: '技能分类1.1').tap do |sub_category|
    sub_category.techniques.find_or_create_by(title: '技能1.1.1')
    sub_category.techniques.find_or_create_by(title: '技能1.1.2')
    sub_category.techniques.find_or_create_by(title: '技能1.1.3')
  end
  category.sub_categories.find_or_create_by(name: '技能分类1.2').tap do |sub_category|
    sub_category.techniques.find_or_create_by(title: '技能1.2.1')
    sub_category.techniques.find_or_create_by(title: '技能1.2.2')
    sub_category.techniques.find_or_create_by(title: '技能1.2.3')
  end
  end
Skills::Category.find_or_create_by(name: '技能种类2').tap do |category|
  category.sub_categories.find_or_create_by(name: '技能分类2.1').tap do |sub_category|
    sub_category.techniques.find_or_create_by(title: '技能2.1.1')
    sub_category.techniques.find_or_create_by(title: '技能2.1.2')
    sub_category.techniques.find_or_create_by(title: '技能2.1.3')
  end
  category.sub_categories.find_or_create_by(name: '技能分类2.2').tap do |sub_category|
    sub_category.techniques.find_or_create_by(title: '技能2.2.1')
    sub_category.techniques.find_or_create_by(title: '技能2.2.2')
    sub_category.techniques.find_or_create_by(title: '技能2.2.3')
  end
end