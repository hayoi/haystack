package haystack;

import com.intellij.openapi.actionSystem.ActionGroup;
import com.intellij.openapi.actionSystem.AnAction;
import com.intellij.openapi.actionSystem.AnActionEvent;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

public class DynamicActionGroup extends ActionGroup {
    public final static String BUTTON = "Button";
    public final static String TEXT_FIELD = "TextField";
    public final static String BOTTOM_SHEET = "Bottom sheet";
    public final static String IMAGE_VIEW = "ImageView";
    @NotNull
    @Override
    public AnAction[] getChildren(@Nullable AnActionEvent anActionEvent) {
        return new AnAction[]{new SimplePopDialogAction(BUTTON,"Insert a Button"),
                new SimplePopDialogAction(TEXT_FIELD, "Insert an TextField"),
                new SimplePopDialogAction(IMAGE_VIEW, "Insert an ImageView"),
                new SimplePopDialogAction(BOTTOM_SHEET, "insert a Bottom Sheet"),

        };
    }
}
