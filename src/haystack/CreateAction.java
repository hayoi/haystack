package haystack;

import com.intellij.openapi.actionSystem.AnAction;
import com.intellij.openapi.actionSystem.AnActionEvent;
import com.intellij.openapi.actionSystem.DataContext;
import com.intellij.openapi.actionSystem.DataKeys;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.ui.Messages;
import com.intellij.openapi.vfs.VirtualFile;
import haystack.core.models.ActionForm;
import haystack.core.models.FieldModel;
import haystack.ui.CreateActionDialog;
import haystack.ui.JSONEditDialog;
import haystack.util.FileUtil;

import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.util.Map;

public class CreateAction extends AnAction implements CreateActionDialog.ActionFormCallbacks {
    private VirtualFile selectGroup;
    private String sourcePath;
    private Project project;
    private String entry;

    @Override
    public void actionPerformed(AnActionEvent event) {
        DataContext dataContext = event.getDataContext();
        project = event.getProject();
        if (project == null) return;
        sourcePath = project.getBasePath() + "/lib";
        selectGroup = DataKeys.VIRTUAL_FILE.getData(dataContext);
        if (selectGroup == null || !selectGroup.getParent().getPath().endsWith("redux")) {
            Messages.showMessageDialog("You must select a subfolder of redux folder, the action would be created in it.", "Error", Messages.getErrorIcon());
            return;
        }
        entry = selectGroup.getPath().substring(selectGroup.getPath().lastIndexOf("/") + 1);
        CreateActionDialog dialog = new CreateActionDialog(this);
        dialog.pack();
        dialog.setLocationRelativeTo(null);
        dialog.setVisible(true);


    }

    @Override
    public void onActionReady(ActionForm actionForm) {
        writeAction(actionForm);
    }

    private void writeAction(ActionForm actionForm) {
        String path = sourcePath + "/redux/" + entry + "/" + entry + "_actions.dart";
        StringBuilder sb = new StringBuilder();
        sb.append("\n");
        sb.append("\n");
        sb.append("class ");
        sb.append(actionForm.getActionName());
        sb.append("Action extends Action {\n");
        for (FieldModel fieldModel : actionForm.getParameters()) {
            sb.append("  final ");
            sb.append(fieldModel.getType());
            sb.append(" ");
            sb.append(fieldModel.getName());
            sb.append(";\n");
        }
        sb.append("\n");
        sb.append("  ");
        sb.append(actionForm.getActionName());
        sb.append("Action({");
        if (actionForm.getParameters().size() > 0) {
            for (FieldModel fieldModel : actionForm.getParameters()) {
                sb.append("this.");
                sb.append(fieldModel.getName());
                sb.append(", ");
            }
        }
        sb.append("completer})\n");

        sb.append("        : super(completer, \"");
        sb.append(actionForm.getActionName());
        sb.append("Action\");\n");
        sb.append("}");
        FileUtil.writeToFile(path, sb.toString(), true);
    }
}
