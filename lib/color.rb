class Color
  attr_accessor :color, :components

  def initialize(hex)
    self.color = convert(hex)
    self.components = extract_components(color)
  end

  def distance(other)
    c = extract_components(other)
    (r - c[:r]) * (r - c[:r]) +
      (g - c[:g]) * (g - c[:g]) +
      (b - c[:b]) * (b - c[:b])
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
end
