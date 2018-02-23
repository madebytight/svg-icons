require 'nokogiri'

class Convert
  attr_accessor :input, :output

  def initialize(file)
    self.input = file
    self.output = file.gsub(/^input/, 'output')
  end

  def self.convert(file)
    new(file).convert
  end

  def convert
    puts "  #{input} -> #{output}:"
    clean_svg
    replace_strokes
    replace_fills
    replace_dimensions
  end

  private

  def clean_svg
    puts '    -> Run svgo'
    `svgo #{input} -o #{output} --pretty`
  end

  def replace_strokes
    puts '    -> Replace strokes'
    each_node do |node|
      next unless node['stroke']
      node.remove_attribute('stroke')
      node['class'] = 'stroke'
    end
  end

  def replace_fills
    puts '    -> Replace fills'
    each_node do |node|
      next unless node['fill']
      next if node['fill'] == 'none'
      node.remove_attribute('fill')
      node['class'] = 'fill'
    end
  end

  def replace_dimensions
    each_node do |node|
      next unless node.name == 'svg'
      next unless node['width']
      next unless node['height']
      node['viewBox'] = "0 0 #{node['width']} #{node['height']}"
      node.remove_attribute('width')
      node.remove_attribute('height')
    end
  end

  def each_node
    svg = File.open(output, "r") { |f| Nokogiri::XML(f) }
    svg.traverse do |node|
      yield(node)
    end
    File.write(output, svg.root.to_s)
  end
end
