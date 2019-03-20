package haystack.core.parser;


import haystack.core.LanguageResolver;
import haystack.core.models.ClassModel;
import org.json.JSONObject;

import java.util.List;

public abstract class JsonParser {

    protected LanguageResolver languageResolver;

    public JsonParser(LanguageResolver resolver) {
        this.languageResolver = resolver;
    }

    public abstract void parse(JSONObject json, String rootClassName);

    public abstract List<ClassModel> getClasses();

}
