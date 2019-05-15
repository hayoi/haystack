package haystack;

import com.intellij.openapi.actionSystem.AnAction;
import com.intellij.openapi.actionSystem.AnActionEvent;
import com.intellij.openapi.actionSystem.DataContext;
import com.intellij.openapi.actionSystem.DataKeys;
import com.intellij.openapi.ui.Messages;
import com.intellij.openapi.vfs.VirtualFile;
import haystack.core.models.ActionForm;
import haystack.ui.CreateActionDialog;
import haystack.ui.JSONEditDialog;

import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

public class CreateAction extends AnAction implements CreateActionDialog.ActionFormCallbacks {
    private VirtualFile selectGroup;

    @Override
    public void actionPerformed(AnActionEvent event) {
        DataContext dataContext = event.getDataContext();
        selectGroup = DataKeys.VIRTUAL_FILE.getData(dataContext);
        if (selectGroup == null || !selectGroup.getParent().getPath().endsWith("redux")) {
            Messages.showMessageDialog( "You must select a subfolder of redux folder, the action would be created in it.", "Error", Messages.getErrorIcon());
            return;
        }
        CreateActionDialog dialog = new CreateActionDialog(this);
        dialog.pack();
        dialog.setLocationRelativeTo(null);
        dialog.setVisible(true);
    }

    @Override
    public void onActionReady(ActionForm actionForm) {

    }
}
