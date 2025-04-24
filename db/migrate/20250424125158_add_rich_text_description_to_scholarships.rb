class AddRichTextDescriptionToScholarships < ActiveRecord::Migration[7.1]
  def up
    # 为scholarships创建Action Text关联
    Scholarship.all.find_each do |scholarship|
      # 将现有的description内容转换为rich text
      scholarship.update_attribute(:description, scholarship.description)
    end
  end

  def down
    # 无需实现
  end
end
