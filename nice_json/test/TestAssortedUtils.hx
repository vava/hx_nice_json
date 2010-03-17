//This class intentionally left without package, so I can test packaged lib and lib under development independently

import nice_json.internal_utils.AssortedUtils;
import nice_json.internal_utils.TypeUtils;

class TestAssortedUtils extends haxe.unit.TestCase {
	public function new() {
		super();
	}

 	public function assertArrayEquals<T>(expected: Array<T>, actual: Array<T>, ?c: haxe.PosInfos) {
 		assertEquals(expected.length, actual.length, c);
		for (i in 0...expected.length) {
			if (TypeUtils.is_object(expected[i]) && TypeUtils.class_name(expected[i]) != "String") {
				assertObjectEquals(expected[i], actual[i], c);
			} else {
				assertEquals(expected[i], actual[i], c);
			}
		}
	}

 	public function assertObjectEquals<T>(expected: T, actual: T, ?c: haxe.PosInfos) {
		assertTrue(TypeUtils.is_object(actual), c);
		var actual_array = AssortedUtils.sort_by_keys(AssortedUtils.object_to_key_value_iterable(actual));
		var expected_array = AssortedUtils.sort_by_keys(AssortedUtils.object_to_key_value_iterable(expected));
 		assertEquals(expected_array.length, actual_array.length, c);

		for (i in 0...expected_array.length) {
			assertEquals(expected_array[i].key, actual_array[i].key, c);
			assertEquals(expected_array[i].value, actual_array[i].value, c);
		}
	}

	public function testHash2KeyValueIterable() {
		var t_int = new Hash<Int>();
		t_int.set("a", 1);
		t_int.set("b", 2);
		t_int.set("c", 3);

		var expected_int: Array<{key: String, value: Dynamic}> = [{key: "a", value: 1}, {key: "b", value: 2}, {key: "c", value: 3}];
		assertArrayEquals(expected_int,
					 AssortedUtils.sort_by_keys(AssortedUtils.hash_to_key_value_iterable(t_int)));

		var t_string = new Hash<String>();
		t_string.set("a", "1");
		t_string.set("b", "2");
		t_string.set("c", "3");

		var expected_string: Array<{key: String, value: Dynamic}> = [{key: "a", value: "1"}, {key: "b", value: "2"}, {key: "c", value: "3"}];
		assertArrayEquals(expected_string,
					 AssortedUtils.sort_by_keys(AssortedUtils.hash_to_key_value_iterable(t_string)));
	}

	public function testIntHash2KeyValueIterable() {
		var t_int = new IntHash<Int>();
		t_int.set(1, 1);
		t_int.set(2, 2);
		t_int.set(3, 3);

		var expected_int: Array<{key: String, value: Dynamic}> = [{key: "1", value: 1}, {key: "2", value: 2}, {key: "3", value: 3}];
		assertArrayEquals(expected_int,
					 AssortedUtils.sort_by_keys(AssortedUtils.int_hash_to_key_value_iterable(t_int)));

		var t_string = new IntHash<String>();
		t_string.set(1, "1");
		t_string.set(2, "2");
		t_string.set(3, "3");

		var expected_string: Array<{key: String, value: Dynamic}> = [{key: "1", value: "1"}, {key: "2", value: "2"}, {key: "3", value: "3"}];
		assertArrayEquals(expected_string,
					 AssortedUtils.sort_by_keys(AssortedUtils.int_hash_to_key_value_iterable(t_string)));
	}

	public function testObject2KeyValueIterable() {
		var t_int = {
			a: 1,
			b: 2,
			c: 3
		};

		var expected_int: Array<{key: String, value: Dynamic}> = [{key: "a", value: 1}, {key: "b", value: 2}, {key: "c", value: 3}];
		assertArrayEquals(expected_int,
					 AssortedUtils.sort_by_keys(AssortedUtils.object_to_key_value_iterable(t_int)));

		var t_string = {
			a: "1",
			b: "2",
			c: "3"
		};

		var expected_string: Array<{key: String, value: Dynamic}> = [{key: "a", value: "1"}, {key: "b", value: "2"}, {key: "c", value: "3"}];
		assertArrayEquals(expected_string,
					 AssortedUtils.sort_by_keys(AssortedUtils.object_to_key_value_iterable(t_string)));
	}

	public function testArrayFromIterator() {
		var l_int = new List();
		l_int.add(1);
		l_int.add(2);
		l_int.add(3);
		assertArrayEquals([1, 2, 3], AssortedUtils.array_from_iterator(l_int.iterator()));

		var l_string = new List();
		l_string.add("1");
		l_string.add("2");
		l_string.add("3");
		assertArrayEquals(["1", "2", "3"], AssortedUtils.array_from_iterator(l_string.iterator()));
	}

	public function testSortByKeys() {
		var expected_int: Array<{key: String, value: Dynamic}> = [{key: "a", value: 1}, {key: "b", value: 2}, {key: "c", value: 3}];
		assertArrayEquals(expected_int, AssortedUtils.sort_by_keys([{key: "c", value: 3}, {key: "b", value: 2}, {key: "a", value: 1}].iterator()));

		var expected_string: Array<{key: String, value: Dynamic}> = [{key: "a", value: "1"}, {key: "b", value: "2"}, {key: "c", value: "3"}];
		assertArrayEquals(expected_string, AssortedUtils.sort_by_keys([{key: "c", value: "3"}, {key: "b", value: "2"}, {key: "a", value: "1"}].iterator()));
	}

	public function testCompareString() {
		assertEquals(-1, AssortedUtils.compare_string("a", "b"));
		assertEquals(0, AssortedUtils.compare_string("a", "a"));
		assertEquals(1, AssortedUtils.compare_string("c", "a"));
	}
}