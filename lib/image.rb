class Image
  class << self
    def all
      files = File.join directory, "*#{extension}"
      Dir[files].collect{|f| File.basename f}.sort
    end

    def exists? image
      File.exists? fullpath(image)
    end

    def filename image
      image.to_s.parameterize('_') + extension
    end

    def for_select
      all.collect do |image|
        item_name = name image
        [item_name.titleize, item_name]
      end
    end

    def random
      all.shuffle.first
    end

    def valid? name
      !!(name.to_s =~ /[a-z][a-z ]+/)
    end

    private

    def directory name
      Rails.root.join 'app', 'assets', 'images', name
    end

    def extension
      '.png'
    end

    def fullpath file
      File.join directory, filename(file)
    end

    def name file
      File.basename(file, extension).gsub '_', ' '
    end
  end
end
