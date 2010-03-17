package nice_json.test;

class Test {
	static public function main() {
		var runner = new haxe.unit.TestRunner();
		runner.add(new TestTypeUtils());
		runner.add(new TestAssortedUtils());
		runner.add(new TestRender());
		runner.run();
	}
}