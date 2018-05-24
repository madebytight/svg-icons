require './lib/color_map'
require './lib/convert'
require './lib/indent'

task default: [:clean_output, :convert] do
  puts "\n\n==== New SVG files: ====\n\n"

  Dir['output/**/*.svg'].each do |file|
    puts File.read(file)
    puts ''
  end
end

task js: [:clean_output, :convert] do
  dst = 'output/icons.js'
  svgs = {}
  Dir['output/**/*.svg'].each do |file|
    next if file =~ /colorMap\.svg/
    name = file.gsub(/^output\//, '')
               .gsub(/\.svg$/, '')
    content = File.read(file)
                  .delete("\n") # Remove newlines
                  .gsub(/ {2,}/, '') # Remove whitespace between tags
    svgs[name] = content
  end

  f = File.open(dst, 'w')

  f.write("export default {\n")
  lines = []
  Hash[svgs.sort].each do |name, svg|
    lines << "  '#{name}': '#{svg}'"
  end
  f.write(lines.join(",\n") + "\n")
  f.write("};\n")

  puts "\nWritten to #{dst}"
end

task preview: [:clean_output, :convert] do
  puts 'Create preview:'
  dst = 'output/preview.html'
  color_map = ColorMap.new('input/colorMap.svg')
  icons = ''
  Dir['output/**/*.svg'].each do |file|
    next if file =~ /colorMap\.svg/
    content = File.read(file)
    icons << "<div class=\"icon\">\n"
    icons << content.indent(2) + "\n"
    icons << "</div>\n"
  end

  rules = []
  color_map.each do |name, color|
    rules << ".icon .fill-#{name} { fill: #{color}; }"
    rules << ".icon .stroke-#{name} { stroke: #{color}; }"
  end

  template = File.read('preview_template.html')

  colors_indent = template.match(/^( +)\/\* COLORS \*\//)[1].length
  template.gsub!(/^ +\/\* COLORS \*\//, rules.join("\n").indent(colors_indent))

  icons_indent = template.match(/^( +)<!-- ICONS -->/)[1].length
  template.gsub!(/^ +<!-- ICONS -->/, icons.indent(icons_indent))
  File.open(dst, 'w') { |f| f.write(template) }
  `open #{dst}`
end

task :convert do
  puts 'Convert icons:'
  color_map = ColorMap.new('input/colorMap.svg')
  Dir['input/**/*.svg'].each do |file|
    next if file =~ /colorMap\.svg/
    Convert.convert(file, color_map)
  end
end

task clean: [:clean_input, :clean_output] do
end

task :clean_input do
  Dir.chdir('input')

  # Remove folders
  Dir['*/'].each do |dir|
    FileUtils.rm_rf(dir)
  end

  # Remove files
  Dir['**/*.*'].each do |file|
    File.delete(file)
  end

  Dir.chdir('..')
end

task :clean_output do
  Dir.chdir('output')

  # Remove folders
  Dir['*/'].each do |dir|
    FileUtils.rm_rf(dir)
  end

  # Remove files
  Dir['**/*.*'].each do |file|
    File.delete(file)
  end

  Dir.chdir('..')
end
