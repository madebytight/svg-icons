require 'nokogiri'

class Convert
  attr_accessor :input, :output, :color_map, :element_classes

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
    map_class_names
    clean_svg
    inject_class_names
    replace_strokes
    replace_fills
    replace_dimensions
  end

  private

  def ensure_output_folder
    output_folder = output.gsub(/\/[^\/]+$/, '')
    return if Dir.exist?(output_folder)
    puts "    -> Create output folder: #{output_folder}"
    FileUtils.mkdir_p(output_folder)
  end

  def clean_svg
    puts '    -> Run svgo'
    options = [
      '--pretty',
      '--indent 2',
      '--disable=mergePaths',
      '--disable=convertPathData'
    ]
    args = "#{input} -o #{output} #{options.join(' ')}"
    `#{Dir.pwd}/node_modules/.bin/svgo #{args}`
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

  def map_class_names
    indexes = {}
    classes = []
    each_node(input) do |node|
      type = node_type(node)
      indexes[type] ||= -1
      indexes[type] += 1
      next if node[:id].nil?
      next unless node[:id].start_with?('.')
      classes << {
        type: type,
        index: indexes[type],
        class: node[:id][1..-1]
      }
    end
    self.element_classes = classes
  end

  def inject_class_names
    return if element_classes.length.zero?
    ending = element_classes.count == 1 ? 'class name' : 'class names'
    puts "    -> Inject #{element_classes.count} #{ending}"
    svg = read_svg(output)
    element_classes.each do |element_class|
      type = element_class[:type]
      index = element_class[:index]
      svg.css(type)[index][:class] = element_class[:class]
    end
    File.write(output, svg.root.to_s)
  end

  def each_node(filename = nil)
    filename = output if filename.nil?
    svg = read_svg(filename)
    svg.traverse do |node|
      yield(node)
    end
    File.write(output, svg.root.to_s)
  end

  def read_svg(filename)
    File.open(filename, 'r') { |f| Nokogiri::XML(f) }
  end

  def node_type(node)
    return 'path' if ['polyline', 'polygon'].include?(node.name)
    node.name
  end
end
