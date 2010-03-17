//This class intentionally left without package, so I can test packaged lib and lib under development independently

import nice_json.internal_utils.TypeUtils;

private class TestClass1 {
	public function new() {}
	public function toString() { return "";}
	public function testMethod() {}
}

private class TestClass2 {
	public function new() {}
	public function iterator() {return {};}
}

private class TestClass3 extends TestClass2 {
	public function new() { super(); }
	public function toString() { return "";}
	public function anotherTestMethod() {}
}

class TestTypeUtils extends haxe.unit.TestCase {
	public function new() {
		super();
	}

	public function testClassName() {
		assertEquals("_TestTypeUtils.TestClass1", TypeUtils.class_name(new TestClass1()));
		assertEquals("_TestTypeUtils.TestClass2", TypeUtils.class_name(new TestClass2()));
		assertEquals("_TestTypeUtils.TestClass3", TypeUtils.class_name(new TestClass3()));
		assertEquals("Hash", TypeUtils.class_name(new Hash()));
		assertEquals("IntHash", TypeUtils.class_name(new IntHash()));
		assertEquals("String", TypeUtils.class_name("hello"));
	}

	public function testHasIterator() {
		assertFalse(TypeUtils.has_iterator(new TestClass1()));
		assertTrue(TypeUtils.has_iterator(new TestClass2()));
		assertTrue(TypeUtils.has_iterator(new TestClass3()));
	}

	public function testHasToString() {
		assertTrue(TypeUtils.has_to_string(new TestClass1()));
		assertFalse(TypeUtils.has_to_string(new TestClass2()));
		assertTrue(TypeUtils.has_to_string(new TestClass3()));
	}

	public function testHasField() {
		assertTrue(TypeUtils.has_field(new TestClass1(), "testMethod"));
		assertFalse(TypeUtils.has_field(new TestClass1(), "anotherTestMethod"));

		assertFalse(TypeUtils.has_field(new TestClass2(), "testMethod"));
		assertFalse(TypeUtils.has_field(new TestClass2(), "anotherTestMethod"));

		assertFalse(TypeUtils.has_field(new TestClass3(), "testMethod"));
		assertTrue(TypeUtils.has_field(new TestClass3(), "anotherTestMethod"));
	}

	public function testIsObject() {
		assertTrue(TypeUtils.is_object({}));
		assertTrue(TypeUtils.is_object({name: "hello"}));
		assertFalse(TypeUtils.is_object(5));
		assertFalse(TypeUtils.is_object(5.0));
		assertFalse(TypeUtils.is_object(true));

		var t_int: Dynamic = 5;
		assertFalse(TypeUtils.is_object(t_int));
		assertTrue(TypeUtils.is_object("hello"));
	}
}