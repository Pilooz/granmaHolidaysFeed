def readconf
  conf = Hash.new
  Dir.glob(__DIR__('../config/*.yml')).each { |f|  conf.merge! YAML::load(File.open(f))} 
  conf
end

MYCONF = readconf
