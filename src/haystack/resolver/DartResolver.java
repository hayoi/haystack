package haystack.resolver;

import haystack.core.LanguageResolver;
import org.apache.commons.lang.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class DartResolver extends LanguageResolver {

    private static final String INT = "int";
    private static final String STRING = "String";
    private static final String DOUBLE = "double";
    private static final String BOOLEAN = "bool";
    private static final String DATETIME = "DateTime";

    private HashMap<String, String> types;
    private HashMap<String, Object> defaultvalues;

    public DartResolver() {
        types = new HashMap<>();
        types.put(TYPE_INTEGER, INT);
        types.put(TYPE_STRING, STRING);
        types.put(TYPE_DOUBLE, DOUBLE);
        types.put(TYPE_BOOLEAN, BOOLEAN);
        types.put(TYPE_DATETIME, DATETIME);

        defaultvalues = new HashMap<>();

        defaultvalues.put(INT, 0);
        defaultvalues.put(STRING, "\"\"");
        defaultvalues.put(DOUBLE, 0.0);
        defaultvalues.put(BOOLEAN, false);
        defaultvalues.put(DATETIME, null);
    }

    @Override
    public String resolve(String javaType) {
        String type = types.get(javaType);
        if (type == null) {
            return StringUtils.capitalize(javaType);
        }
        return type;
    }

    @Override
    public String getClassName(String jsonKey) {
        String result = toCamelCase(jsonKey);
        return StringUtils.capitalize(result);
    }

    @Override
    public String getFieldName(String jsonName) {
        String name;
        if (jsonName.toUpperCase().equals(jsonName)) {
            name = jsonName.toLowerCase();
        } else {
            name = jsonName.substring(0, 1).toLowerCase() + jsonName.substring(1);
        }
        return toCamelCase(name);
    }

    @Override
    public String getDefaultValue(String type) {
        if (type.endsWith("?")) {
            return "null";
        }
        return String.valueOf(defaultvalues.get(type));
    }

    @Override
    public String getArrayType(String type) {
        String result = toCamelCase(type);
        if (result.equals("Integer")) {
            result = "int";
        } else if (result.equals("Boolean")) {
            result = "bool";
        }
        return "List<" + result + ">";
    }

    @Override
    public List<String> getSupportTypeList() {
        return new ArrayList<>(types.values());
    }

    @Override
    public String getArrayOriginalValue() {
        return "List";
    }

    @Override
    public String getObjectOriginalValue() {
        return "Object";
    }

    @Override
    public String getArrayItemOriginalValue(String type) {
        return type + "Item";
    }

    @Override
    public String getModifier(boolean mutable) {
        return mutable ? "final" : "";
    }

    @Override
    public boolean isModifierMutable(String modifier) {
        return modifier.equals("var");
    }

    private String toCamelCase(String name) {
        String result;
        int nonCharPos = getNoCharPosition(name);
        if (nonCharPos != -1) {
            result = name.substring(0, nonCharPos) + StringUtils.capitalize(name.substring(nonCharPos + 1));
            return toCamelCase(result);
        } else {
            result = name;
        }
        return result;
    }
}
