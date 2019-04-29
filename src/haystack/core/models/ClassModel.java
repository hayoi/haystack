package haystack.core.models;

import java.util.ArrayList;
import java.util.List;

public class ClassModel {

    private String packageName;
    private String name;

    private String uniqueField;

    private String uniqueFieldType;
    private boolean genApi;
    private List<FieldModel> fields;
    public ClassModel(String name) {
        this.name = name;
        fields = new ArrayList<>();
        genApi = false;
    }

    public String getUniqueField() {
        return uniqueField;
    }

    public void setUniqueField(String uniqueField) {
        this.uniqueField = uniqueField;
    }

    public String getUniqueFieldType() {
        return uniqueFieldType;
    }

    public void setUniqueFieldType(String uniqueFieldType) {
        this.uniqueFieldType = uniqueFieldType;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isGenDBModule() {
        return genApi;
    }

    public void setGenApi(boolean genApi) {
        this.genApi = genApi;
    }

    public List<FieldModel> getFields() {
        return fields;
    }

    public void setFields(List<FieldModel> fields) {
        this.fields = fields;
    }

    public void addField(FieldModel field) {
        fields.add(field);
    }

    @Override
    public String toString() {
        return name;
    }

}
