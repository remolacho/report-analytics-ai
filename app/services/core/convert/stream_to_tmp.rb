module Core
  module Convert
    class StreamToTmp
      class << self

        def file(attachment)
          temp_file = Tempfile.new(['analytic', File.extname(attachment.filename.to_s)])
          temp_file.binmode
          temp_file.write(attachment.download)
          temp_file.rewind
          temp_file
        end
      end
    end
  end
end
