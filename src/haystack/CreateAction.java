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
import haystack.util.StringUtils;

import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.io.File;
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
        writeMiddleware(actionForm);
        writeReducer(actionForm);
        writeState(actionForm);
        writeRepository(actionForm);
        writeRepositoryDB(actionForm);
    }


    private void writeRepositoryDB(ActionForm actionForm) {
        String path = sourcePath + "/data/db/" + entry + "_repository_db.dart";

        if (!new File(path).exists()) {
            return;
        }
        String entryCamel = StringUtils.upercaseFirst(entry);
        String lowercaseName = StringUtils.lowercaseFirst(actionForm.getActionName());

        String content = FileUtil.usingBufferedReader(path);
        StringBuilder sb = new StringBuilder();
        if (!content.contains(lowercaseName)) {
            String indexString = "const " + entryCamel + "RepositoryDB();";
            int poi1 = content.indexOf(indexString) + indexString.length();
            sb.append(content, 0, poi1);
            sb.append("\n\n");

            sb.append("  Future<");
            if (actionForm.getStateVariable() != null) {
                sb.append(actionForm.getStateVariable().getType());
            } else {
                sb.append("int");
            }
            sb.append("> ");
            sb.append(lowercaseName);
            sb.append("(");
            if(actionForm.getParameters() != null) {
                for (int i = 0; i < actionForm.getParameters().size(); i++) {
                    FieldModel field = actionForm.getParameters().get(i);
                    sb.append(field.getType());
                    sb.append(" ");
                    sb.append(field.getName());
                    if (i != actionForm.getParameters().size() - 1) {
                        sb.append(", ");
                    }
                }
            }
            sb.append(") {\n");
            sb.append("    // TODO invoke your api here\n");
            sb.append("  }");
            sb.append(content.substring(poi1));

            FileUtil.writeToFile(path, sb.toString(), false);
        }
    }

    private void writeRepository(ActionForm actionForm) {
        String path = sourcePath + "/data/remote/" + entry + "_repository.dart";

        String entryCamel = StringUtils.upercaseFirst(entry);
        String lowercaseName = StringUtils.lowercaseFirst(actionForm.getActionName());

        String content = FileUtil.usingBufferedReader(path);
        StringBuilder sb = new StringBuilder();
        if (!content.contains(lowercaseName)) {
            String indexString = "const " + entryCamel + "Repository();";
            int poi1 = content.indexOf(indexString) + indexString.length();
            sb.append(content, 0, poi1);
            sb.append("\n\n");

            sb.append("  Future<");
            if (actionForm.getStateVariable() != null) {
                sb.append(actionForm.getStateVariable().getType());
            } else {
                sb.append("int");
            }
            sb.append("> ");
            sb.append(lowercaseName);
            sb.append("(");
            if (actionForm.getParameters() != null) {
                for (int i = 0; i < actionForm.getParameters().size(); i++) {
                    FieldModel field = actionForm.getParameters().get(i);
                    sb.append(field.getType());
                    sb.append(" ");
                    sb.append(field.getName());
                    if (i != actionForm.getParameters().size() - 1) {
                        sb.append(", ");
                    }
                }
            }
            sb.append(") {\n");
            sb.append("    // TODO invoke your api here\n");
            sb.append("  }");
            sb.append(content.substring(poi1));

            FileUtil.writeToFile(path, sb.toString(), false);
        }
    }

    private void writeMiddleware(ActionForm actionForm) {
        String path = sourcePath + "/redux/" + entry + "/" + entry + "_middleware.dart";
        String entryCamel = StringUtils.upercaseFirst(entry);
        String lowercaseName = StringUtils.lowercaseFirst(actionForm.getActionName());

        String content = FileUtil.usingBufferedReader(path);
        StringBuilder sb = new StringBuilder();

        String param = "  final " + lowercaseName + " = _create" + actionForm.getActionName() + "(_repository" + (content.contains("_repositoryDB") ? ", _repositoryDB" : "") + ");";
        if (!content.contains(param)) {
            String indexString = "]) {";
            int poi1 = content.indexOf(indexString) + indexString.length();
            sb.append(content, 0, poi1);
            sb.append("\n");
            sb.append(param);

            indexString = "  return [";
            int poi2 = content.indexOf(indexString) + indexString.length();
            param = "    TypedMiddleware<AppState, " + actionForm.getActionName() + "Action>(" + lowercaseName + "),";
            if (!content.contains(param)) {
                sb.append(content, poi1, poi2);
                sb.append("\n");
                sb.append(param);
            }

            sb.append(content.substring(poi2));

            sb.append("\n");
            sb.append("Middleware<AppState> _create");
            sb.append(actionForm.getActionName());
            sb.append("(\n");
            sb.append("    ");
            sb.append(entryCamel);
            sb.append("Repository repository");
            if (content.contains("_repositoryDB")) {
                sb.append(", ");
                sb.append(entryCamel);
                sb.append("RepositoryDB repositoryDB");
            }
            sb.append(") {\n");
            sb.append("  return (Store<AppState> store, dynamic action, NextDispatcher next) {\n");
            sb.append("    running(action);\n");
            sb.append("    repository.");
            sb.append(lowercaseName);
            sb.append("(");
            if (actionForm.getParameters() != null) {
                for (int i = 0; i < actionForm.getParameters().size(); i++) {
                    FieldModel field = actionForm.getParameters().get(i);
                    sb.append("action.");
                    sb.append(field.getName());
                    if (i != actionForm.getParameters().size() - 1) {
                        sb.append(", ");
                    }
                }
            }
            sb.append(")");
            sb.append(".then((");
            if (actionForm.getStateVariable() != null) {
                sb.append(actionForm.getStateVariable().getName());
            } else {
                sb.append("_");
            }
            sb.append(") {\n");
            if (actionForm.getStateVariable() != null) {
                sb.append("      next(");
                sb.append("RD");
                sb.append(actionForm.getActionName());
                sb.append("Action(");
                sb.append(actionForm.getStateVariable().getName());
                sb.append(": ");
                sb.append(actionForm.getStateVariable().getName());
                sb.append("));\n");
            }
            sb.append("      completed(action);\n");
            sb.append("    }).catchError((error) {\n");
            sb.append("      catchError(action, error);\n");
            sb.append("    });\n");
            sb.append("  };\n");
            sb.append("}");

            FileUtil.writeToFile(path, sb.toString(), false);
        }
    }

    private void writeState(ActionForm actionForm) {
        if (actionForm.getStateVariable() == null)
            return;
        String path = sourcePath + "/redux/" + entry + "/" + entry + "_state.dart";
        String entryCamel = StringUtils.upercaseFirst(entry);
        String lowercaseName = StringUtils.lowercaseFirst(actionForm.getActionName());

        String content = FileUtil.usingBufferedReader(path);
        StringBuilder sb = new StringBuilder();

        String param = "  final " + actionForm.getStateVariable().getType() + " " + actionForm.getStateVariable().getName() + ";";
        if (!content.contains(param)) {
            String indexString = "class " + entryCamel + "State {";
            int poi1 = content.indexOf(indexString) + indexString.length();
            sb.append(content, 0, poi1);
            sb.append("\n");
            sb.append(param);

            indexString = "  " + entryCamel + "State({";
            int poi2 = content.indexOf(indexString) + indexString.length();
            param = "    @required this." + actionForm.getStateVariable().getName() + ",";
            if (!content.contains(param)) {
                sb.append(content, poi1, poi2);
                sb.append("\n");
                sb.append(param);
            }

            indexString = "  " + entryCamel + "State copyWith({";
            int poi3 = content.indexOf(indexString) + indexString.length();
            param = "    " + actionForm.getStateVariable().getType() + " " + actionForm.getStateVariable().getName() + ",";
            if (!content.contains(param)) {
                sb.append(content, poi2, poi3);
                sb.append("\n");
                sb.append(param);
            }

            indexString = "    return " + entryCamel + "State(";
            int poi4 = content.indexOf(indexString) + indexString.length();
            param = "      " + actionForm.getStateVariable().getName() + ": " + actionForm.getStateVariable().getName() + " ?? this." + actionForm.getStateVariable().getName() + ",";
            if (!content.contains(param)) {
                sb.append(content, poi3, poi4);
                sb.append("\n");
                sb.append(param);
            }

            sb.append(content.substring(poi4));
            FileUtil.writeToFile(path, sb.toString(), false);
        }
    }

    private void writeReducer(ActionForm actionForm) {
        if (actionForm.getStateVariable() == null)
            return;
        String path = sourcePath + "/redux/" + entry + "/" + entry + "_reducer.dart";

        String entryCamel = StringUtils.upercaseFirst(entry);
        String lowercaseName = StringUtils.lowercaseFirst(actionForm.getActionName());

        String content = FileUtil.usingBufferedReader(path);
        StringBuilder sb = new StringBuilder();
        String param = "  TypedReducer<" + entryCamel + "State, " + actionForm.getActionName() + "Action>(_" + lowercaseName + "),";
        if (!content.contains(param)) {
            String indexString = "combineReducers<" + entryCamel + "State>([";
            int poi1 = content.indexOf(indexString) + indexString.length();
            sb.append(content, 0, poi1);
            sb.append("\n");
            sb.append(param);

            sb.append(content.substring(poi1));
            sb.append("\n");

            sb.append(entryCamel);
            sb.append("State _");
            sb.append(lowercaseName);
            sb.append("(");
            sb.append(entryCamel);
            sb.append("State state, ");
            sb.append(actionForm.getActionName());
            sb.append("Action action) {\n");
            sb.append("  // TODO  handle your state here\n");
            sb.append("  return state;\n");
            sb.append("}");

            FileUtil.writeToFile(path, sb.toString(), false);
        }
    }

    private void writeAction(ActionForm actionForm) {
        String path = sourcePath + "/redux/" + entry + "/" + entry + "_actions.dart";
        StringBuilder sb = new StringBuilder();
        sb.append("\n");
        sb.append("\n");
        sb.append("class ");
        sb.append(actionForm.getActionName());
        sb.append("Action extends Action {\n");
        if (actionForm.getParameters() != null)
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
        if (actionForm.getParameters() != null && actionForm.getParameters().size() > 0) {
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

        if (actionForm.getStateVariable() != null) {
            sb.append("\n");
            sb.append("\n");
            sb.append("class RD");
            sb.append(actionForm.getActionName());
            sb.append("Action extends Action {\n");
            sb.append("  final ");
            sb.append(actionForm.getStateVariable().getType());
            sb.append(" ");
            sb.append(actionForm.getStateVariable().getName());
            sb.append(";\n");
            sb.append("\n");
            sb.append("  RD");
            sb.append(actionForm.getActionName());
            sb.append("Action({");
            sb.append("this.");
            sb.append(actionForm.getStateVariable().getName());
            sb.append(", ");
            sb.append("completer})\n");
            sb.append("        : super(completer, \"RD");
            sb.append(actionForm.getActionName());
            sb.append("Action\");\n");
            sb.append("}");
        }
        FileUtil.writeToFile(path, sb.toString(), true);
    }
}
