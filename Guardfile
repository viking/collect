guard :test do
  watch(%r{^lib/((?:[^/]+\/)*)(.+)\.rb$})     { |m| "test/unit/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/((?:[^/]+\/)*)test.+\.rb$})
  watch('test/helper.rb')  { "test" }
  watch(%r{^views/(?:([^/]+)\/)?.+\.erb}) do |m|
    m[1] ? "test/unit/collect/extensions/test_#{m[1]}.rb" : "test/unit/collect/test_application.rb"
  end
end

guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end

guard 'shell' do
  watch(%r{db/migrate/\d+_.+.rb}) do |m|
    `rake db:migrate[test]`
    `rake db:migrate[development]`
  end
end
