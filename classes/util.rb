# module Util
module Util
  def self.load_yaml(file_name, path = 'config')
    YAML.load(ERB.new(File.read(
      Dir.glob("#{File.expand_path("../../#{path}", __FILE__)}/#{file_name}")[0]
    )).result)
  end

  def self.resize_len(str, len)
    (str.to_s + ' ' * len)[0, len]
  end
end
