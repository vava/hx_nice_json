package nice_json.internal_utils;

class TypeUtils {
	public static inline function class_name(s: Dynamic) {
		return Type.getClassName(Type.getClass(s));
	}

	public static inline function has_iterator(s: Dynamic) {
		return has_field(s, "iterator");
	}

	public static inline function has_to_string(s: Dynamic) {
		return has_field(s, "toString");
	}

	public static inline function has_field(s: Dynamic, field: String) {
		var klass = Type.getClass(s);
		return klass != null && Lambda.has(Type.getInstanceFields(klass), field);
	}

	public static inline function is_object(s: Dynamic) {
		return Reflect.isObject(s);
	}
}