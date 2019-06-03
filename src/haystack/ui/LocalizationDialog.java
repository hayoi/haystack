package haystack.ui;

import com.intellij.openapi.ui.Messages;
import haystack.core.models.ActionForm;
import haystack.core.models.Localization;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;

public class LocalizationDialog extends JDialog {
    private LocalizationFormCallbacks mListener;
    private String[] subFile;
    private JPanel contentPane = new JPanel();
    private BoxLayout yLayout = new BoxLayout(contentPane, BoxLayout.Y_AXIS);

    public LocalizationDialog(String[] subFile, LocalizationFormCallbacks callbacks) {
        setContentPane(contentPane);
        setModal(true);
        setTitle("Localization");

        mListener = callbacks;
        this.subFile = subFile;
        contentPane.setLayout(yLayout);
//        setPreferredSize(new Dimension(300, 250));
        contentPane.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        JPanel name = new JPanel();
        BoxLayout x = new BoxLayout(name, BoxLayout.X_AXIS);
        name.setLayout(x);
        name.add(new JLabel("String Name Key"));
        JTextField nameField = new JTextField();
        nameField.setMargin(new Insets(0, 5, 0, 0));
        nameField.setPreferredSize(new Dimension(200, 30));
        nameField.setSize(200, 30);
        name.add(nameField);
        contentPane.add(name);

        JPanel valuePanel = new JPanel();
        BoxLayout v = new BoxLayout(valuePanel, BoxLayout.Y_AXIS);
        valuePanel.setLayout(v);
        valuePanel.setBorder(BorderFactory.createTitledBorder("String value in each file"));
        List<JTextField> fields = new ArrayList<>();
        for (String file : subFile) {
            JPanel p = new JPanel();
            BoxLayout x1 = new BoxLayout(p, BoxLayout.X_AXIS);
            p.setLayout(x1);
            p.add(new JLabel(file));

            JTextField textField = new JTextField();
            textField.setMargin(new Insets(0, 5, 0, 0));
            textField.setPreferredSize(new Dimension(200, 30));
            fields.add(textField);
            p.add(textField);
            valuePanel.add(p);
        }
        contentPane.add(valuePanel);

        JPanel btnPanel = new JPanel();
        BoxLayout btnLayout = new BoxLayout(btnPanel, BoxLayout.X_AXIS);
        btnPanel.setLayout(btnLayout);
        JButton cancel = new JButton("Cancel");
        cancel.addActionListener(e -> dispose());
        btnPanel.add(cancel);
        JButton ok = new JButton("OK");
        ok.addActionListener(e -> {
            if (nameField.getText().trim().length() == 0) {
                Messages.showMessageDialog("the name key cannot be null", "Error",
                        Messages.getErrorIcon());
                return;
            }

            Localization localization = new Localization();
            localization.setKey(nameField.getText().trim());
            List<String> vs = new ArrayList<>();
            for (JTextField tf : fields) {
                vs.add(tf.getText().trim());
            }
            localization.setValues(vs);
            if (mListener != null) {
                mListener.onLocalizationReady(localization);
            }

            dispose();
        });
        btnPanel.add(ok);
        contentPane.add(btnPanel);
    }

    public static void main(String[] args) {
        String[] files = {"i18n_en.json", "i18n_zh.json"};
        LocalizationDialog dialog = new LocalizationDialog(files,
                actionForm -> {
                });
        dialog.pack();
        dialog.setVisible(true);
        System.exit(0);

    }

    public interface LocalizationFormCallbacks {
        void onLocalizationReady(Localization localization);
    }
}
