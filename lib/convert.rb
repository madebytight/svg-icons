require 'nokogiri'

class Convert
  attr_accessor :input, :output, :color_map

  def initialize(file, color_map)
    self.input = file
    self.output = file.gsub(/^input/, 'output')
    self.color_map = color_map
  end

  def self.convert(file, color_map)
    new(file, color_map).convert
  end

  def convert
    puts "  #{input} -> #{output}:"
    ensure_output_folder
    clean_svg
    replace_strokes
    replace_fills
    replace_dimensions
  end

  private

  def ensure_output_folder
    output_folder = output.gsub(%r{\/[^\/]+$}, '')
    return if Dir.exist?(output_folder)
    puts "    -> Create output folder: #{output_folder}"
    FileUtils.mkdir_p(output_folder)
  end

  def clean_svg
    puts '    -> Run svgo'
    `svgo #{input} -o #{output} --pretty`
  end

  def replace_strokes
    puts '    -> Replace strokes'
    each_node do |node|
      next unless node['stroke']
      color = node['stroke']
      node.remove_attribute('stroke')
      suffix = color_map.suffix_for(color)
      node['class'] = "#{node['class']} #{"stroke#{suffix}"}".strip
    end
  end

  def replace_fills
    puts '    -> Replace fills'
    each_node do |node|
      next unless node['fill']
      next if node['fill'] == 'none'
      color = node['fill']
      node.remove_attribute('fill')
      suffix = color_map.suffix_for(color)
      node['class'] = "#{node['class']} #{"fill#{suffix}"}".strip
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
    svg = File.open(output, 'r') { |f| Nokogiri::XML(f) }
    svg.traverse do |node|
      yield(node)
    end
    File.write(output, svg.root.to_s)
  end
end
