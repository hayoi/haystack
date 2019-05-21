package haystack;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.intellij.openapi.actionSystem.ActionGroup;
import com.intellij.openapi.actionSystem.AnAction;
import com.intellij.openapi.actionSystem.AnActionEvent;
import haystack.core.models.MyAction;
import haystack.core.models.MyCode;
import haystack.core.models.Widget;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class DynamicActionGroup extends ActionGroup {
    public final static String BUTTON = "Button";
    public final static String TEXT_FIELD = "TextField";
    public final static String BOTTOM_SHEET = "Bottom sheet";
    public final static String IMAGE_VIEW = "ImageView";

    @NotNull
    @Override
    public AnAction[] getChildren(@Nullable AnActionEvent anActionEvent) {
        String menuPath = System.getProperty("user.home") + "/.haystack_template_cache/popmenu";

        ObjectMapper mapper = new ObjectMapper();

        if (new File(menuPath).exists()) {
            try {
                List<MyAction> actions = mapper.readValue(new File(menuPath), new TypeReference<List<MyAction>>() {
                });
//                for (MyAction action : actions) {
//                    action.setWidgets(mapper.readValue(action.getWidgets().toString(), new TypeReference<List<Widget>>() {
//                    }));
//                    for (Widget code : action.getWidgets()) {
//                        code.setTexts(mapper.readValue(action.getWidgets().toString(), new TypeReference<List<MyCode>>() {
//                        }));
//                    }
//                }
                AnAction[] list = new AnAction[actions.size()];
                for (int i = 0; i < actions.size(); i++) {
                    MyAction action = actions.get(i);
                    list[i] = new SimplePopDialogAction(action.getTitle(), action.getDescription(), action);
                }
                return list;
//                return new AnAction[]{new SimplePopDialogAction(BUTTON, "Insert a Button"),
//                        new SimplePopDialogAction(TEXT_FIELD, "Insert an TextField"),
//                        new SimplePopDialogAction(IMAGE_VIEW, "Insert an ImageView"),
//                        new SimplePopDialogAction(BOTTOM_SHEET, "insert a Bottom Sheet"),
//
//                };
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return new AnAction[]{};
    }
}
