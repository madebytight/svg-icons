class IdMap
  attr_accessor :ids

  def initialize
    self.ids = {}
  end

  def convert_clip_path(clip_path)
    id = convert_id(clip_path[/url\(#([^)]+)/, 1])

    "url(##{id})"
  end

  def convert_id(id)
    return ids[id] unless ids[id].nil?

    ids[id] = generate_id
    ids[id]
  end

  def include?(id)
    ids.keys.include?(id)
  end

  private

  def generate_id(length = 4)
    id = (('a'..'z').to_a + ('A'..'Z').to_a).sample(length).join

    return id unless ids.values.include?(id)

    generate_id(length)
  end
end
