require './lib/convert'

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
    name = file.gsub(%r{^output/}, '')
               .gsub(/\.svg$/, '')
    content = File.read(file)
                  .delete("\n") # Remove newlines
                  .gsub(/ {2,}/, '') # Remove whitespace between tags
    svgs[name] = content
  end

  f = File.open(dst, 'w')

  f.write("export default {\n")
  lines = []
  svgs.each do |name, svg|
    lines << "  '#{name}': '#{svg}'"
  end
  f.write(lines.join(",\n") + "\n")
  f.write("};\n")

  puts "\nWritten to #{dst}"
end

task :convert do
  puts 'Convert icons:'
  Dir['input/**/*.svg'].each do |file|
    Convert.convert(file)
  end
end

task clean: %i[clean_input clean_output]

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
