module Collect
  module Utils
    def self.slugify(string)
      string.downcase.strip.gsub(' ', '_').gsub(/[^\w_]/, '')
    end
  end
end
