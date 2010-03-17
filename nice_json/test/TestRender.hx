//This class intentionally left without package, so I can test packaged lib and lib under development independently

import nice_json.Render;

private class TestClass1 {
	public function new(s: String) { this.s = s; }
	public function toString() { return s; }
	private var s: String;
}

private class TestClass2 {
	public function new(keys: Array<String>, values: Array<String>) {
		this.keys = keys;
		this.values = values;
	}

	public function iterator() {
		var me = this;
		var it = (0...keys.length);
		return {
			hasNext: function() { return it.hasNext(); },
			next: function() { var i = it.next(); return {key: me.keys[i], value: me.values[i]};}
		}
	}

	private var keys: Array<String>;
	private var values: Array<String>;
}

class TestRender extends haxe.unit.TestCase {
	public function new() {
		super();
	}

	public function testSimple() {
		assertEquals('"hello"', Render.as_json("hello"));
		assertEquals('"hello"', Render.as_json(new TestClass1("hello")));
		assertEquals('"hello\\nhello"', Render.as_json(new TestClass1("hello\nhello")));
		assertEquals('10', Render.as_json(10));
		assertEquals('10.2', Render.as_json(10.2));
		assertEquals('null', Render.as_json(null));
	}

	public function testLinear() {
		assertEquals('[1,\n 2,\n 3]', Render.as_json([1, 2, 3]));
		assertEquals('["1",\n 2,\n null]', Render.as_json(["1", 2, null]));

		var l = new List();
		l.add(1);l.add(2);l.add(3);
		assertEquals('[1,\n 2,\n 3]', Render.as_json(l));
	}

	public function testKeyValue() {
		assertEquals('{"a": 1,\n "b": 2,\n "c": 3}', Render.as_json({a: 1, b: 2, c: 3}));
		assertEquals('{"a": 1,\n "b": "2",\n "c": null}', Render.as_json({a: 1, b: "2", c: null}));
		assertEquals('{}', Render.as_json({}));

		var t_int = new Hash();
		t_int.set("a", 1);
		t_int.set("b", 2);
		t_int.set("c", 3);
		assertEquals('{"a": 1,\n "c": 3,\n "b": 2}', Render.as_json(t_int));
		assertEquals('{"a": 1,\n "b": 2,\n "c": 3}', new Render({sort_keys: true}).json(t_int));

		var t_int2 = new IntHash();
		t_int2.set(1, "a");
		t_int2.set(2, "b");
		t_int2.set(3, "c");
		assertEquals('{"3": "c",\n "2": "b",\n "1": "a"}', Render.as_json(t_int2));
		assertEquals('{"1": "a",\n "2": "b",\n "3": "c"}', new Render({sort_keys: true}).json(t_int2));
	}

	public function testCustomKeyValueRender() {
		var render = new Render({
			  key_value_storages:[
					{name: "_TestRender.TestClass2",
					 storage_to_iterator: function(s) { return s.iterator(); }}
					 ]
					});
		assertEquals('{"a": "1",\n "b": "2",\n "c": "3"}',
					 render.json(new TestClass2(["a", "b", "c"], ["1", "2", "3"]))
			);
	}
}