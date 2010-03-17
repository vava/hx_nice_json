//This class intentionally left without package, so I can test packaged lib and lib under development independently

class Test {
	static public function main() {
		var runner = new haxe.unit.TestRunner();
		runner.add(new TestTypeUtils());
		runner.add(new TestAssortedUtils());
		runner.add(new TestRender());
		runner.run();
	}
}