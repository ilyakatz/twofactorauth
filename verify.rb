# Load Yaml
require 'yaml'
require 'fastimage'
$output=0;
begin

  def error(msg)
    $output=$output+1;
    if($output == 1)
      puts "<------------ ERROR ------------>\n"
    end
    puts "#{$output}. #{msg}"

  end

  def sorted?(sites)
    sites.each_cons(2).all? do |x, y|
      (x["name"] <=> y["name"]) != 1
    end
  end

  # Load each section, check for errors such as invalid syntax
  # as well as if an image is missing
  main = YAML.load_file('_data/main.yml')
  main["sections"].each do |section|
    data = YAML.load_file('_data/' + section["id"] + '.yml')

    websites = data["websites"]

    unless sorted?(websites)
      error("Websites in section '#{section["id"]}' are not sorted")
    end

    websites.each do |website|
      image = "img/#{section['id']}/#{website['img']}"

      unless File.exists?(image)
        error("#{website['name']} image not found.")
      end

      image_dimensions = [32,32]

      unless FastImage.size(image) == image_dimensions
        error("#{image} is not #{image_dimensions.join("x")}")
      end

      ext = ".png"
      unless File.extname(image) == ext
        error("#{image} is not #{ext}")
      end
    end
  end

  # Load each provider and look for each image
  providers = YAML.load_file('_data/providers.yml')
  providers["providers"].each do |provider|
    pimage = "img/providers/#{provider['img']}";
    unless File.exists?(pimage)
      error("#{provider['name']} image not found.")
    end
    image_dimensions = [32,32]

    unless FastImage.size(pimage) == image_dimensions
      error("#{pimage} is not #{image_dimensions.join("x")}")
    end

    ext = ".png"
    unless File.extname(pimage) == ext
      error("#{pimage} is not #{ext}")
    end
  end
  if($output > 0 )
    exit 1
  end
rescue Psych::SyntaxError => e
  puts 'Error in the YAML'
  puts e
  exit 1
rescue => e
  puts e
  exit 1
else
  puts 'No errors. You\'re good to go!'
end
