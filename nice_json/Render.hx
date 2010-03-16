package nice_json;

import nice_json.internal_utils.AssortedUtils;
import nice_json.internal_utils.TypeUtils;

private enum RenderType {
	Simple;
	KeyValue(storage: Iterator<{key: String, value: Dynamic}>);
	Linear(storage: Iterator<Dynamic>);
}

class Render {
	public function new(?params: Dynamic) {
		if (params == null) {
			params = {};
		}

		if (params.indent != null) {
			indent = params.indent;
		} else {
			indent = "";
		}

		if (params.sort_keys != null) {
			sort_keys = params.sort_keys;
		} else {
			sort_keys = false;
		}

		if (params.key_value_storages != null) {
			key_value_storages = params.key_value_storages;
		} else {
			key_value_storages = [];
		}

		key_value_storages.push({name: "Hash", storage_to_iterator: AssortedUtils.hash_to_key_value_iterable});
		key_value_storages.push({name: "IntHash", storage_to_iterator: AssortedUtils.int_hash_to_key_value_iterable});
	}

	public static function as_json(s: Dynamic): String {
		return new Render().json(s);
	}

	public function json(s: Dynamic): String {
		return switch(chooseRender(s)) {
			case Simple: render_simple(s);
			case KeyValue(iterator): render_key_value_storage(iterator);
			case Linear(iterator): render_linear_storage(iterator);
		}
	}

	//private parts
	private var indent: String;
	private var sort_keys: Bool;
	private var key_value_storages: Array<{name: String, storage_to_iterator: Dynamic -> Iterator<{key: String, value: Dynamic}>}>;

	private inline function indent_out() {
		indent += " ";
	}

	private inline function indent_in() {
		indent = indent.substr(0, indent.length - 1);
	}

	private function is_key_value_storage(s: Dynamic) {
		var s_name = TypeUtils.class_name(s);
		return Lambda.exists(key_value_storages, function(elt) {
				return elt.name == s_name;
			});
	}

	private function get_key_value_storage_iterator(s: Dynamic) {
		var s_name = TypeUtils.class_name(s);
		for (elt in key_value_storages) {
			if (elt.name == s_name) {
				return elt.storage_to_iterator(s);
			}
		}
		return null;
	}

	private inline function has_complicated_rendering(s: Dynamic) {
		return chooseRender(s) != Simple;
	}

	private function render_key_value_storage(storage: Iterator<{key: String, value: Dynamic}>) {
		if (sort_keys) {
			storage = AssortedUtils.sort_by_keys(storage).iterator();
		}
		var buf = new StringBuf();
		buf.add("{");
		indent_out();
		var first = true;
		for (f in storage) {
			if (!first) {
				buf.add(',\n' + indent);
			} else {
				first = false;
			}
			buf.add('"');buf.add(escape(f.key));buf.add('":');
			if (has_complicated_rendering(f.value)) {
				indent_out();
				buf.add('\n' + indent);
				buf.add(json(f.value));
				indent_in();
			} else {
				buf.add(' ');
				buf.add(json(f.value));
			}
		}
		indent_in();
		buf.add("}");
		return buf.toString();
	}

	private function render_linear_storage(storage: Iterator<Dynamic>) {
		var buf = new StringBuf();
		buf.add("[");
		indent_out();
		var first = true;
		for (f in storage) {
			if (!first) {
				buf.add(',\n' + indent);
			} else {
				first = false;
			}
			buf.add(json(f));
		}
		indent_in();
		buf.add("]");
		return buf.toString();
	}

	private function render_simple(s: Dynamic) {
		if (s == null) {
			return "null";
		} else if (TypeUtils.is_object(s)) {
			return '"' + escape('' + s) + '"';
		} else { //numeric
			return '' + s;
		}
	}

	private static function escape(s: String) {
		s = StringTools.replace(s, '\n', '\\n');
		s = StringTools.replace(s, '\r', '\\r');
		s = StringTools.replace(s, '"', '\\"');
		return s;
	}

	private function chooseRender(s: Dynamic) {
		if (is_key_value_storage(s)) {
			return KeyValue(get_key_value_storage_iterator(s));
		} else if (TypeUtils.has_iterator(s)) {
			return Linear(s.iterator());
		} else if (TypeUtils.has_to_string(s)) {
			return Simple;
		} else if (TypeUtils.is_object(s)) {
			return KeyValue(AssortedUtils.object_to_key_value_iterable(s));
		} else {
			return Simple;
		}
	}
}
