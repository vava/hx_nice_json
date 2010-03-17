require 'rake/packagetask'
require 'rake/clean'

CLOBBER.include('tests/test_packaged.n', 'tests/test.n')

test_files = FileList['nice_json/test/**/*.hx']
haxe_files = FileList['nice_json/**/*.hx']
package_files = FileList['haxedoc.xml', 'haxelib.xml', haxe_files]

#task :default => [:package]

Rake::PackageTask.new("hx_nice_json", :noversion) do |p|
    p.need_zip = true
    p.package_files.include(package_files)
end

file "haxedoc.xml" => haxe_files do
	sh 'haxe -xml haxedoc.xml nice_json.Render'
end

rule '.hx' do
	#nothing to do
end

desc "Install package locally"
task :install_package => :package do
	sh 'haxelib test pkg/hx_nice_json.zip'
end

file 'tests/test_packaged.n' => FileList[haxe_files, 'tests/test_packaged.hxml'] do
	cd 'tests' #I have to cd otherwise it will include development sources, not from the library
	sh 'haxe test_packaged.hxml'
	cd '..'
end

desc "Tests package"
task :test_package => ['tests/test_packaged.n', :install_package] do
	sh 'neko tests/test_packaged.n'
end

file 'tests/test.n' => FileList[haxe_files, 'tests/test.hxml'] do
	cd 'tests' #I have to cd otherwise it will include development sources, not from the library
	sh 'haxe test.hxml'
	cd '..'
end

desc "Run hxUnit tests"
task :test => 'tests/test.n' do
	sh 'neko tests/test.n'
end

desc "Upload package"
task :upload => :package do
	sh 'haxelib submit pkg/hx_nice_json.zip'
end
