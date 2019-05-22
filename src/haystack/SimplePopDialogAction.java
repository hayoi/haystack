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

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

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

        if (mAction.getWidgets().size() > 1) {
            String[] ws = new String[mAction.getWidgets().size()];
            for (int i = 0; i < mAction.getWidgets().size(); i++) {
                ws[i] = mAction.getWidgets().get(i).getName();
            }
            final int index = Messages.showDialog(mAction.getDescription(), mAction.getTitle(), ws,
                    0, Messages.getQuestionIcon());

            Widget widget = mAction.getWidgets().get(index);
            for (MyCode code : widget.getTexts()) {
                if (code.isInsertAtCursor()) {
                    // insert the code to the position of cursor
                    insertString(mCursor, code.getText());
                } else if (code.getInsertAfter() != null && code.getInsertAfter().trim().length() > 0) {
                    int offset = indexesOf(document.getText(), code.getInsertAfter());
                    int lineNumber = document.getLineNumber(offset);


                    System.out.println(offset + "  " + lineNumber);
                }
            }
        } else if (mAction.getWidgets().size() == 1) {

        }
    }

    private void insertString(int cursor, String text) {
        WriteCommandAction.runWriteCommandAction(project, () -> document.insertString(cursor, text));
    }

    private int indexesOf(String text, String flag) {
        ArrayList<Integer> list = new ArrayList<Integer>();
        int index = text.indexOf(flag);
        while (index >= 0 && index <= mCursor) {
            int line = document.getLineNumber(index);
            String lineStr = getLineString(document,line);
            if (lineStr.trim().startsWith(flag)) {
                list.add(index);
            }
            index = text.indexOf(flag, index + 1);
        }
        if (list.size() > 0) {
            return list.get(list.size() - 1);
        } else {
            return -1;
        }
    }

    private String getLineString(Document document, int line) {
        return document.getText().substring(document.getLineStartOffset(line), document.getLineEndOffset(line));
    }
}
