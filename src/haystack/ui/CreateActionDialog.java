package haystack.ui;

import com.intellij.openapi.ui.Messages;
import haystack.core.models.ActionForm;
import haystack.core.models.PageModel;

import javax.swing.*;
import java.awt.event.*;

public class CreateActionDialog extends JDialog {
    private JPanel contentPane;
    private JButton buttonOK;
    private JButton buttonCancel;
    private JTextField textActionName;
    private JTextField textParameters;
    private JTextField textVariable;
    private ActionFormCallbacks mListener;

    public CreateActionDialog(ActionFormCallbacks listener) {
        setContentPane(contentPane);
        setModal(true);
        getRootPane().setDefaultButton(buttonOK);

        mListener = listener;

        buttonOK.addActionListener(e -> onOK());

        buttonCancel.addActionListener(e -> onCancel());

        // call onCancel() when cross is clicked
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                onCancel();
            }
        });

        // call onCancel() on ESCAPE
        contentPane.registerKeyboardAction(e -> onCancel(), KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0), JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);
    }

    private void onOK() {
        // add your code here
        ActionForm actionForm = new ActionForm();
        if (textActionName.getText().trim().length() == 0){
            Messages.showMessageDialog( "Please input Action Name", "Error", Messages.getErrorIcon());
        } else {
            actionForm.setActionName(textActionName.getText().trim());
        }

        if (textParameters.getText().trim().length() != 0){
            String[] ps = textParameters.getText().trim().split(",");
            for (String s : ps){
                
            }
        }

        if (textActionName.getText().trim().length() == 0){
            Messages.showMessageDialog( "Please input Action Name", "Error", Messages.getErrorIcon());
        } else {

        }



        dispose();
    }

    private void onCancel() {
        // add your code here if necessary
        dispose();
    }

    public static void main(String[] args) {
        CreateActionDialog dialog = new CreateActionDialog(new ActionFormCallbacks() {
            @Override
            public void onActionReady(ActionForm actionForm) {

            }
        });
        dialog.pack();
        dialog.setVisible(true);
        System.exit(0);

    }

    public interface ActionFormCallbacks {
        void onActionReady(ActionForm actionForm);
    }
}


