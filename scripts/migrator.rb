Upload.find_each do |upload|
  if upload.attachment_file_name.present?
  # Construct the old Paperclip file path
    file_path = File.join(
    "/var/www/dv4/public/system/uploads/attachments",
    format("%09d", upload.id).scan(/\d{3}/).join("/"),
    "original",
    upload.attachment_file_name
    )

    if File.exist?(file_path)
      upload.attachment.attach(
      io: File.open(file_path),
      filename: upload.attachment_file_name,
      content_type: upload.attachment_content_type
      )
      puts "✔ Migrated file: #{file_path} -> Active Storage"
    else
      puts "❌ Missing file: #{file_path}"
    end
  end 
end