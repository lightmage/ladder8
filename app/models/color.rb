class Color
  class << self
    def all
      %w(red blue green purple black brown orange white teal)
    end

    def find number
      all[number.to_i - 1]
    end

    def for_select
      all.collect {|c| [c.titleize, c]}
    end
  end
end
