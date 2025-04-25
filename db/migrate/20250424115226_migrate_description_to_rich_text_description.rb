class MigrateDescriptionToRichTextDescription < ActiveRecord::Migration[7.1]
  def up
    # For each scholarship record, create a corresponding ActionText::RichText record
    Scholarship.find_each do |scholarship|
      # Skip records that already have a rich text description
      next if ActionText::RichText.exists?(record_type: 'Scholarship', 
                                          record_id: scholarship.id,
                                          name: 'description')
      
      # Create a new rich text record
      ActionText::RichText.create!(
        record_type: 'Scholarship',
        record_id: scholarship.id,
        name: 'description',
        body: scholarship.description
      )
    end
  end

  def down
    # This migration doesn't need to be rolled back as we're keeping the original description column
  end
end
