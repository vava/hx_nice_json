package nice_json.internal_utils;

/**
   Few utilities to make my life simpler.
 **/
class AssortedUtils {
	/**
	   Given [Hash], returns iterator to {key, value} pairs. Used in [Render] to iterate through [Hash].
	 **/
	public static function hash_to_key_value_iterable(s: Hash<Dynamic>) {
		var iterator = s.keys();
		return {
		  hasNext: function() { return iterator.hasNext(); },
				next: function() { var k = iterator.next(); return {key: k, value: s.get(k)};}
		};
	}

	/**
	   Given [IntHash], returns iterator to {key, value} pairs. Used in [Render] to iterate through [IntHash].
	 **/
	public static function int_hash_to_key_value_iterable(s: IntHash<Dynamic>) {
		var iterator = s.keys();
		return {
		  hasNext: function() { return iterator.hasNext(); },
				next: function() { var k = iterator.next(); return {key: "" + k, value: s.get(k)};}
		};
	}

	/**
	   Given object, returns iterator to {key, value} pairs. Used in [Render] to iterate through simple objects.
	 **/
	public static function object_to_key_value_iterable(s: Dynamic) {
		var iterator = Reflect.fields(s).iterator();
		return {
		  hasNext: function() { return iterator.hasNext(); },
				next: function() { var k = iterator.next(); return {key: k, value: Reflect.field(s, k)};}
		};
	}

	/**
	   Return [Array] from [Iterator]
	 **/
	public static function array_from_iterator<T>(it: Iterator<T>): Array<T> {
		return Lambda.array({iterator: function() { return it;}});
	}

	/**
	   Given iterator to {key, value}, returns array with those {key, value} pairs, sorted by key.
	 **/
	public static function sort_by_keys(kv: Iterator<{key: String, value: Dynamic}>) : Array<{key: String, value: Dynamic}> {
		var local_storage = array_from_iterator(kv);
		local_storage.sort(function(a, b) {
				return compare_string(a.key, b.key);
			});
		return local_storage;
	}

	/**
	   Returns -1 if a < b, 0 if a = b, 1 if a > b. Used in [Array.sort].
	 **/
	public static function compare_string(a: String, b: String): Int {
		if (a < b) {
			return -1;
		} else if (a == b) {
			return 0;
		} else {
			return 1;
		}
	}
}