NAMED_COLORS = {
  white: '#ffffff',
  silver: '#c0c0c0',
  gray: '#808080',
  black: '#000000',
  red: '#ff0000',
  maroon: '#800000',
  yellow: '#ffff00',
  olive: '#808000',
  lime: '#00ff00',
  green: '#008000',
  aqua: '#00ffff',
  teal: '#008080',
  blue: '#0000ff',
  navy: '#000080',
  fuchsia: '#ff00ff',
  purple: '#800080'
}.freeze

class Color
  attr_accessor :color, :components

  def initialize(hex)
    hex = sanitize(hex)
    self.color = convert(hex)
    self.components = extract_components(color)
  end

  def distance(other)
    c = extract_components(other)
    (r - c[:r]) * (r - c[:r]) +
      (g - c[:g]) * (g - c[:g]) +
      (b - c[:b]) * (b - c[:b])
  end

  def hex
    "##{color.to_s(16)}"
  end

  def self.hex(raw)
    new(raw).hex
  end

  private

  def r
    components[:r]
  end

  def g
    components[:g]
  end

  def b
    components[:b]
  end

  def convert(color)
    color.gsub('#', '0x').to_i(16)
  end

  def extract_components(color)
    color = convert(color) unless color.is_a?(Integer)
    {
      r: (color & 0xff0000) >> 16,
      g: (color & 0xff00) >> 8,
      b: (color & 0xff)
    }
  end

  def sanitize(raw)
    return named_color(raw) if named_color?(raw)
    raw = "##{raw[1] * 6}" if raw.squeeze.length == 2
    raw
  end

  def named_color(raw)
    NAMED_COLORS[raw.to_sym]
  end

  def named_color?(raw)
    !named_color(raw).nil?
  end
end
