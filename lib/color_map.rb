require 'pry'
require 'nokogiri'
require 'active_support/inflector'

require_relative 'color'

class ColorMap
  attr_accessor :file_name, :map

  def initialize(file_name)
    self.file_name = file_name
    self.map = {}
    build_color_map
  end

  def exist?
    File.exist?(file_name)
  end

  def suffix_for(color)
    color = convert_color(color)
    return "-#{map[color]}" unless map[color].nil?
    return '' if map.empty?

    # Find closest match in color map
    distances = map.map{ |c, n| [Color.new(c).distance(color), n] }
    closest = distances.sort{|d| d[0] }.first[1]
    puts "      -> #{color} is not in map, closest to to #{closest}"

    "-#{closest}"
  end

  def each
    map.each do |color, name|
      yield(name, color)
    end
  end

  private

  def build_color_map
    return unless exist?

    each_node do |node|
      next if node[:id] == 'colorMap'
      next unless node[:id] =~ /color[A-Za-z]+/
      suffix = convert_name(node[:id])
      color = convert_color(node[:fill])
      map[color] = suffix
    end
  end

  def each_node
    return unless exist?

    svg = File.open(file_name, 'r') { |f| Nokogiri::XML(f) }
    svg.traverse do |node|
      yield(node)
    end
  end

  def convert_name(name)
    name.gsub(/^color/, '')
        .underscore
        .gsub(/([^0-9])([0-9])/, '\1_\2')
        .dasherize
  end

  def convert_color(color)
    Color.hex(color)
  end
end
