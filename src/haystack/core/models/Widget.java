package haystack.core.models;

import java.util.List;

public class Widget {
    private String name;
    private List<MyCode> texts;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<MyCode> getTexts() {
        return texts;
    }

    public void setTexts(List<MyCode> texts) {
        this.texts = texts;
    }
}
