guard :test do
  watch(%r{^lib/((?:[^/]+\/)*)(.+)\.rb$})     { |m| "test/unit/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/((?:[^/]+\/)*)test.+\.rb$})
  watch('test/helper.rb')  { "test" }
end

guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end

guard 'shell' do
  watch(%r{db/migrate/\d+_.+.rb}) {|m| `rake db:migrate[test]` }
end
