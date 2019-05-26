package haystack;

import com.intellij.openapi.actionSystem.AnAction;
import com.intellij.openapi.actionSystem.AnActionEvent;
import com.intellij.openapi.actionSystem.CommonDataKeys;
import com.intellij.openapi.actionSystem.PlatformDataKeys;
import com.intellij.openapi.command.WriteCommandAction;
import com.intellij.openapi.editor.Document;
import com.intellij.openapi.editor.Editor;
import com.intellij.openapi.fileEditor.FileDocumentManager;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.ui.Messages;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.psi.*;
import com.intellij.psi.util.PsiTreeUtil;
import com.jetbrains.lang.dart.psi.*;
import com.jetbrains.lang.dart.util.DartElementGenerator;
import haystack.core.models.MyAction;
import haystack.core.models.MyCode;
import haystack.core.models.Widget;
import haystack.resolver.DartFileType;
import haystack.util.DartHelper;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.List;

public class SimplePopDialogAction extends AnAction {
    private Document document;
    private Editor editor;
    private Project project;
    private MyAction mAction;
    private PsiFile psiFile;

    public SimplePopDialogAction(String text, String description, MyAction action) {
        super(text, description, null);
        mAction = action;
    }

    @Override
    public void actionPerformed(@NotNull AnActionEvent event) {
        editor = event.getData(CommonDataKeys.EDITOR);
        if (editor == null) return;
        project = event.getProject();
        document = editor.getDocument();

        psiFile = event.getData(CommonDataKeys.PSI_FILE);
        assert psiFile != null;

        VirtualFile vFile = event.getData(PlatformDataKeys.VIRTUAL_FILE);

        if (mAction.getWidgets().size() > 1) {
            String[] ws = new String[mAction.getWidgets().size()];
            for (int i = 0; i < mAction.getWidgets().size(); i++) {
                ws[i] = mAction.getWidgets().get(i).getName();
            }
            final int index = Messages.showDialog(mAction.getDescription(), mAction.getTitle(), ws,
                    0, Messages.getQuestionIcon());

            Widget widget = mAction.getWidgets().get(index);
            for (MyCode code : widget.getTexts()) {
                int cursor = editor.getCaretModel().getOffset();
                PsiElement cursorElement = psiFile.findElementAt(cursor);

                if (code.getType().equals("block")) {
                    if (code.getFunctionName() == null) {
//                        insertString(mCursor, code.getText());
                        PsiElement blockElement =
                                DartHelper.createBlockFromText(project,
                                        code.getText());
                        WriteCommandAction.runWriteCommandAction(project, () -> {
                            cursorElement.getParent().addBefore(blockElement, cursorElement);
                        });

                    } else {

                    }
                } else if (code.getType().equals("field")) {
                    DartClassMembers field =
                            DartHelper.createFieldFromText(project, code.getText());
                    DartClassDefinition cursorClass = PsiTreeUtil.getParentOfType(cursorElement,
                            DartClassDefinition.class);
                    PsiElement element = PsiTreeUtil.findChildOfType(cursorClass,
                            DartClassMembers.class);

                    PsiElement varDeclaration = PsiTreeUtil.findChildOfType(cursorClass,
                            DartVarDeclarationList.class);

                    if ((varDeclaration) != null) {
                        PsiElement lastVarDec = DartHelper.getLastVar(element);
                        WriteCommandAction.runWriteCommandAction(project, () -> {
                            element.addAfter(field, lastVarDec);
                        });
                    } else {
                        WriteCommandAction.runWriteCommandAction(project, () -> {
                            element.addBefore(field, element.getFirstChild());
                        });
                    }
                } else if (code.getType().equals("function")) {
                    DartMethodDeclaration containingMethod =
                            PsiTreeUtil.getParentOfType(cursorElement, DartMethodDeclaration.class);
//                    PsiElement func = DartHelper.createMethodFromText(project, code.getText());
                    WriteCommandAction.runWriteCommandAction(project, () -> {
                        //TODO
//                        containingMethod.getParent().addAfter(func, containingMethod);
                    });

                } else if (code.getType().equals("class")) {
                    PsiMethod containingMethod =
                            PsiTreeUtil.getParentOfType(cursorElement, PsiMethod.class);
                    assert containingMethod != null;
                    PsiClass containingClass = containingMethod.getContainingClass();
                    assert containingClass != null;

                    PsiElement func = DartHelper.createClassFromText(project, code.getText());
                    WriteCommandAction.runWriteCommandAction(project, () -> {
                        containingClass.getParent().addAfter(func, containingClass);
                    });
                }

            }
        } else if (mAction.getWidgets().size() == 1) {

        }
    }

    @Override
    public void update(@NotNull AnActionEvent event) {
        super.update(event);
        editor = event.getData(CommonDataKeys.EDITOR);
        if (editor == null) return;
        project = event.getProject();
        document = editor.getDocument();
        psiFile = event.getData(CommonDataKeys.PSI_FILE);
    }

    private void insertString(int cursor, String text) {
        WriteCommandAction.runWriteCommandAction(project, () -> document.insertString(cursor,
                text));
    }

    private String getLineString(Document document, int line) {
        return document.getText().substring(document.getLineStartOffset(line),
                document.getLineEndOffset(line));
    }
}
