require './lib/color_map'
require './lib/convert'
require './lib/indent'

task default: [:usage] do
end

task js: [:clean_tmp, :convert] do
  dst = '/app/output/icons.js'
  svgs = {}
  Dir['/app/tmp/**/*.svg'].each do |file|
    next if file =~ /colorMap\.svg/

    name = file.gsub(/^\/app\/tmp\//, '')
               .gsub(/\.svg$/, '')
    content = File.read(file)
                  .delete("\n") # Remove newlines
                  .gsub(/ {2,}/, '') # Remove whitespace between tags
    svgs[name] = content
  end

  f = File.open(dst, 'w')
  f.write("/* eslint max-len: off */\n\n")
  f.write("export default {\n")
  lines = []
  Hash[svgs.sort].each do |name, svg|
    lines << "  '#{name}': '#{svg}'"
  end
  f.write(lines.join(",\n") + "\n")
  f.write("};\n")

  puts "\nWritten to #{dst}"
end

task json: [:clean_tmp, :convert] do
  dst = '/app/output/icons.json'
  svgs = {}
  svgs = {}
  Dir['/app/tmp/**/*.svg'].each do |file|
    next if file =~ /colorMap\.svg/

    name = file.gsub(/^\/app\/tmp\//, '')
               .gsub(/\.svg$/, '')
    content = File.read(file)
                  .delete("\n") # Remove newlines
                  .gsub(/ {2,}/, '') # Remove whitespace between tags
    svgs[name] = content
  end

  f = File.open(dst, 'w')
  f.write("{\n")
  lines = []
  Hash[svgs.sort].each do |name, svg|
    lines << "  \"#{name}\": \"#{svg.gsub('"', '\"')}\""
  end
  f.write(lines.join(",\n") + "\n")
  f.write("}\n")

  puts "\nWritten to #{dst}"
end

task preview: [:clean_tmp, :convert] do
  puts 'Create preview:'
  dst = '/app/output/preview.html'
  color_map = ColorMap.new('/app/input/colorMap.svg')
  icons = ''
  Dir['/app/tmp/**/*.svg'].each do |file|
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

  template = File.read('/app/preview_template.html')

  colors_indent = template.match(/^( +)\/\* COLORS \*\//)[1].length
  template.gsub!(/^ +\/\* COLORS \*\//, rules.join("\n").indent(colors_indent))

  icons_indent = template.match(/^( +)<!-- ICONS -->/)[1].length
  template.gsub!(/^ +<!-- ICONS -->/, icons.indent(icons_indent))
  File.open(dst, 'w') { |f| f.write(template) }

  puts '-> Done'
end

task :convert do
  puts 'Convert icons:'
  color_map = ColorMap.new('/app/input/colorMap.svg')
  Dir['/app/input/**/*.svg'].each do |file|
    next if file =~ /colorMap\.svg/

    Convert.convert(file, color_map)
  end
end

task clean: [:clean_input, :clean_output] do
end

task :clean_input do
  Dir.chdir('/app/input')

  # Remove folders
  Dir['/app/input/*/'].each do |dir|
    FileUtils.rm_rf(dir)
  end

  # Remove files
  Dir['/app/input/**/*.*'].each do |file|
    File.delete(file)
  end

  Dir.chdir('..')
end

task :clean_output do
  Dir.chdir('/app/output')

  # Remove folders
  Dir['/app/output/*/'].each do |dir|
    next if dir =~ /output\/input/

    FileUtils.rm_rf(dir)
  end

  # Remove files
  Dir['/app/output/**/*.*'].each do |file|
    next if file =~ /output\/input/

    File.delete(file)
  end

  Dir.chdir('..')
end

task :clean_tmp do
  Dir.chdir('/app/tmp')

  # Remove folders
  Dir['/app/tmp/*/'].each do |dir|
    FileUtils.rm_rf(dir)
  end

  # Remove files
  Dir['/app/tmp/**/*.*'].each do |file|
    File.delete(file)
  end

  Dir.chdir('..')
end

task :usage do
  puts <<~USAGE
    Usage:
      docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output madebytight/svg-icons COMMAND

    Commands:
      json      Export to JSON
      js        Export to JavaScript
      preview   Create preview in HTML
  USAGE
end
