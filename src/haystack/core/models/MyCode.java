package haystack.core.models;

public class MyCode {
    private String insertAfter;
    private String replace;
    private boolean insertAtCursor;
    private String insertBefore;
    private String text;

    public String getInsertAfter() {
        return insertAfter;
    }

    public void setInsertAfter(String insertAfter) {
        this.insertAfter = insertAfter;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getReplace() {
        return replace;
    }

    public void setReplace(String replace) {
        this.replace = replace;
    }

    public String getInsertBefore() {
        return insertBefore;
    }

    public void setInsertBefore(String insertBefore) {
        this.insertBefore = insertBefore;
    }

    public boolean isInsertAtCursor() {
        return insertAtCursor;
    }

    public void setInsertAtCursor(boolean insertAtCursor) {
        this.insertAtCursor = insertAtCursor;
    }
}
