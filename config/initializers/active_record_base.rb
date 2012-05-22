class ActiveRecord::Base
  class << self
    def column_list
      column_names.collect do |column|
        "#{table_name}.#{column}"
      end.join ', '
     end
  end
end
