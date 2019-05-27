package haystack.util;

import com.intellij.openapi.project.Project;
import com.intellij.psi.PsiElement;
import com.intellij.psi.PsiFile;
import com.intellij.psi.util.PsiTreeUtil;
import com.jetbrains.lang.dart.psi.*;

import static com.jetbrains.lang.dart.util.DartElementGenerator.createDummyFile;

public class DartHelper {
    public static PsiElement createBlockFromText(Project myProject, String text) {
        PsiFile file = createDummyFile(myProject, "dummy(){" + text + "}");
        PsiElement child = file.getFirstChild();
        if (child instanceof DartFunctionDeclarationWithBodyOrNative) {
            DartFunctionBody functionBody =
                    ((DartFunctionDeclarationWithBodyOrNative) child).getFunctionBody();
            IDartBlock block = PsiTreeUtil.getChildOfType(functionBody, IDartBlock.class);
            DartStatements statements = block == null ? null : block.getStatements();
            return statements;
        } else {
            return null;
        }
    }

    public static PsiElement createMethodFromText(Project myProject, String text) {
        PsiFile file = createDummyFile(myProject, "class dummy{\n" + text + "}");
        PsiElement child = file.getFirstChild();
        if (child instanceof DartClassDefinition) {
            DartClassBody body = PsiTreeUtil.getChildOfType(child, DartClassBody.class);
            DartClassMembers members = PsiTreeUtil.getChildOfType(body, DartClassMembers.class);
            return members.getFirstChild();
        } else {
            return null;
        }
    }

    public static PsiElement createClassFromText(Project myProject, String text) {
        PsiFile file = createDummyFile(myProject, text);
        PsiElement child = file.getFirstChild();
        if (child instanceof DartClassDefinition) {
            return child;
        } else {
            return null;
        }
    }

    public static DartClassMembers createFieldFromText(Project myProject, String text) {
        PsiFile file = createDummyFile(myProject, "class dummy{" + text + "}");
        PsiElement child = file.getFirstChild();
        if (child instanceof DartClassDefinition) {

            DartClassMembers members =
                    ((DartClassDefinition) child).getClassBody().getClassMembers();
            return members;
        } else {
            return null;
        }
    }


    public static PsiElement getLastVar(PsiElement element) {
        PsiElement sibling = element.getFirstChild();
        while (sibling.getNextSibling() != null && !(sibling.getNextSibling() instanceof DartMethodDeclaration)) {
            sibling = sibling.getNextSibling();
        }
        return sibling;
    }
}
