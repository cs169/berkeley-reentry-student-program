class AddRichTextDescriptionToScholarships < ActiveRecord::Migration[7.1]
  def up
    # Create Action Text association for scholarships
    Scholarship.all.find_each do |scholarship|
      # Convert existing description content to rich text
      scholarship.update_attribute(:description, scholarship.description)
    end
  end

  def down
    # No implementation needed
  end
end
