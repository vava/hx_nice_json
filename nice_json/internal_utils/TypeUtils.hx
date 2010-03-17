package nice_json.internal_utils;

/**
   Few utilities to operate on types
 **/
class TypeUtils {
	/**
	   Returns class name of an object.
	 **/
	public static inline function class_name(s: Dynamic) {
		return Type.getClassName(Type.getClass(s));
	}

	/**
	   Checks if object has [iterator] field
	 **/
	public static inline function has_iterator(s: Dynamic) {
		return has_field(s, "iterator");
	}

	/**
	   Checks if object has [toString] field
	 **/
	public static inline function has_to_string(s: Dynamic) {
		return has_field(s, "toString");
	}

	/**
	   Checks if object has given field
	 **/
	public static inline function has_field(s: Dynamic, field: String) {
		var klass = Type.getClass(s);
		return klass != null && Lambda.has(Type.getInstanceFields(klass), field);
	}

	/**
	   Checks if it is an object or primitive
	 **/
	public static inline function is_object(s: Dynamic) {
		return Reflect.isObject(s);
	}
}