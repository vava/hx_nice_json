require 'rake/packagetask'

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

task :test_package => :package do
	sh 'haxelib test pkg/hx_nice_json.zip'
end

file 'test.n' => haxe_files do
	sh 'haxe test.hxml'
end

task :test => 'test.n' do
	sh 'neko test.n'
end
