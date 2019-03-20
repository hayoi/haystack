package haystack.core;

import java.util.List;

public abstract class LanguageResolver {

    public static final String TYPE_INTEGER = "Integer";
    public static final String TYPE_LONG = "Long";
    public static final String TYPE_STRING = "String";
    public static final String TYPE_DOUBLE = "Double";
    public static final String TYPE_BOOLEAN = "Boolean";
    public static final String TYPE_DATETIME = "DateTime";

    public abstract String resolve(String javaType);

    public abstract String getClassName(String jsonKey);

    public abstract String getFieldName(String jsonKey);

    public abstract String getDefaultValue(String type);

    public abstract String getArrayType(String type);

    public abstract List<String> getSupportTypeList();

    public abstract String getArrayOriginalValue();

    public abstract String getObjectOriginalValue();

    public abstract String getArrayItemOriginalValue(String type);

    public abstract String getModifier(boolean mutable);

    public abstract boolean isModifierMutable(String modifier);

    public int getNoCharPosition(String name) {
        char[] chars = name.toCharArray();
        int pos = 0;
        for (char c : chars) {
            if (!Character.isLetter(c)) {
                return pos;
            }
            pos++;
        }
        return -1;
    }
}
