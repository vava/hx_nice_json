require 'rake/packagetask'

task :default => [:package]

Rake::PackageTask.new("hx_nice_json", :noversion) do |p|
    p.need_zip = true
#	p.package_dir = '.';
    p.package_files.include(["nice_json/**/*.hx", 'haxedoc.xml', 'haxelib.xml'])
end

# file 'hx_nice_json.zip' => ['haxedoc.xml', FileList['**/*.hx']] do
# 	#zip stuff
# end

file "hx_nice_json/haxedoc.xml" => ['nice_json/Render.hx', FileList['nice_json/**/*.hx']] do
	sh 'haxe -xml haxedoc.xml nice_json.Render'
end

rule '.hx' do
end
