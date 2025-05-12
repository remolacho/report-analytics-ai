module ChatMessages
  module Serializer
    class Preview < Base
      def self.parse(response, df=nil)
        super("preview", response, df)
      end

      private

      # override
      def self.serialize_message(action, response, df)
        result = eval(response.metadata["source_code"], binding)
        table = <<~HTML.gsub(/\s+/, ' ').strip
          <table>
            <thead>
              <tr>
                #{result.columns.map { |col| "<th>#{col}</th>" }.join}
              </tr>
            </thead>
            <tbody>
              #{result.rows.map { |row|
                "<tr>#{row.map { |val| "<td>#{val}</td>" }.join}</tr>"
              }.join}
            </tbody>
          </table>
        HTML

        msg_success(save(response, table), action)
      end
    end
  end
end
