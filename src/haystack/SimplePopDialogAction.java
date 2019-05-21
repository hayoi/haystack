package haystack;

import com.intellij.openapi.actionSystem.AnAction;
import com.intellij.openapi.actionSystem.AnActionEvent;
import com.intellij.openapi.actionSystem.CommonDataKeys;
import com.intellij.openapi.command.WriteCommandAction;
import com.intellij.openapi.editor.Document;
import com.intellij.openapi.editor.Editor;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.ui.Messages;
import haystack.core.models.MyAction;
import haystack.core.models.MyCode;
import haystack.core.models.Widget;
import org.jetbrains.annotations.NotNull;

public class SimplePopDialogAction extends AnAction {
    private Document document;
    private int mCursor;
    private Project project;
    private MyAction mAction;
    public SimplePopDialogAction(String text, String description, MyAction action) {
        super(text, description, null);
        mAction = action;
    }

    @Override
    public void actionPerformed(@NotNull AnActionEvent event) {
        Editor editor = event.getData(CommonDataKeys.EDITOR);
        if (editor == null) return;
        project = event.getProject();
        document = editor.getDocument();
        mCursor = editor.getCaretModel().getOffset();

        if (mAction.getWidgets().size()>1){
            String[] ws = new String[mAction.getWidgets().size()];
            for (int i = 0; i < mAction.getWidgets().size(); i++) {
                ws[i] = mAction.getWidgets().get(i).getName();
            }
            final int index = Messages.showDialog(mAction.getDescription(), mAction.getTitle(), ws,
                    0, Messages.getQuestionIcon());

            Widget widget = mAction.getWidgets().get(index);
            for (MyCode code : widget.getTexts()){
                if (code.getInsertAfter() == null){
                    // insert the code to the position of cursor
                    insertString(mCursor, code.getText());
                } else {

                }
            }
        }
    }

    private void insertButton() {
        final int result = Messages.showDialog("Select a button style", "Button",
                new String[]{"RAISED", "RAISED ICON", "FLAT", "FLAT ICON", "OUTLINE", "OUTLINE ICON", "Cupertino", "Cupertino BG"},
                0, Messages.getQuestionIcon());

        switch (result) {
            case 0:
                insertString(mCursor,"RaisedButton(\n" +
                        "  child: const Text('RAISED BUTTON', semanticsLabel: 'RAISED BUTTON 1'),\n" +
                        "  onPressed: () {\n" +
                        "   // Perform some action\n" +
                        "  },\n" +
                        ")");
                break;
            case 1:
                insertString(mCursor,"RaisedButton.icon(\n" +
                        " icon: const Icon(Icons.add, size: 18.0),\n" +
                        "  label: const Text('RAISED BUTTON', semanticsLabel: 'RAISED BUTTON 2'),\n" +
                        "  onPressed: () {\n" +
                        "    // Perform some action\n" +
                        "  },\n" +
                        ")");
                break;
            case 2:
                insertString(mCursor, "");
                break;
            case 3:
                insertString(mCursor, "FlatButton.icon(\n" +
                        "  icon: const Icon(Icons.add_circle_outline, size: 18.0),\n" +
                        "  label: const Text('FLAT BUTTON', semanticsLabel: 'FLAT BUTTON 2'),\n" +
                        "  onPressed: () {\n" +
                        "    // Perform some action\n" +
                        " },\n" +
                        ")");
                break;
            case 4:
                insertString(mCursor,"OutlineButton(\n" +
                        "  child: const Text('OUTLINE BUTTON', semanticsLabel: 'OUTLINE BUTTON 1'),\n" +
                        "  onPressed: () {\n" +
                        "    // Perform some action\n" +
                        "  },\n" +
                        ")");
                break;
            case 5:
                insertString(mCursor,"OutlineButton.icon(\n" +
                        "  icon: const Icon(Icons.add, size: 18.0),\n" +
                        "  label: const Text('OUTLINE BUTTON', semanticsLabel: 'OUTLINE BUTTON 2'),\n" +
                        "  onPressed: () {\n" +
                        "    // Perform some action\n" +
                        "  },\n" +
                        ")");
                break;
            case 6:
                insertString(mCursor,"CupertinoButton(\n" +
                        "  child: const Text('Cupertino Button'),\n" +
                        "  onPressed: () {\n" +
                        "    // Perform some action\n" +
                        "  },\n" +
                        ")");
                break;
            case 7:
                insertString(mCursor,"CupertinoButton.filled(\n" +
                        "  child: const Text('With Background'),\n" +
                        "  onPressed: () {\n" +
                        "    // Perform some action\n" +
                        "  },\n" +
                        ")");
                break;
        }
    }

    private void insertString(int cursor, String text){
        WriteCommandAction.runWriteCommandAction(project, () -> document.insertString(cursor, text));
    }
}
