# -*- encoding : utf-8 -*-

module ActiveSupport
  module Inflector
    def titleize word
      humanize(underscore word).gsub(/\b(['’`]?[a-z])/) {$1.capitalize}
    end
  end
end
