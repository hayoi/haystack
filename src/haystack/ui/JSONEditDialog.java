package haystack.ui;

import com.intellij.openapi.ui.Messages;
import haystack.core.models.ClassModel;
import haystack.core.models.PageModel;
import haystack.core.models.PageType;
import haystack.core.parser.SimpleParser;
import haystack.resolver.DartResolver;
import org.json.JSONException;
import org.json.JSONObject;

import javax.swing.*;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.ArrayList;
import java.util.List;

public class JSONEditDialog extends JDialog {
    private JPanel contentPane;
    private JButton buttonOK;
    private JButton buttonCancel;
    private JTextField classNameTextField;
    private JTextPane jsonTextPanel;
    private JLabel jsonErrorLabel;
    private JPanel modelSetting;
    private JPanel pageSetting;
    private JTextField TFpageName;
    private JPanel pageType;
    private JRadioButton loginRadioButton;
    private JRadioButton mannulRadioButton;
    private JRadioButton sliverRadioButton;
    //    private JRadioButton profileRadioButton;
    private JCheckBox appBarCheckBox;
    private JCheckBox bottomTabBarCheckBox;
    private JCheckBox listViewCheckBox;
    private JCheckBox topTabBarCheckBox;
    private JCheckBox actionButtonCheckBox;
    private JCheckBox webViewCheckBox;
    private JCheckBox drawerCheckBox;
    private JButton btnInit;
    private JPanel appBarInfo;
    private JPanel detailPanel;
    private JPanel CustomScrollView;
    private JRadioButton sliverFixedList;
    private JRadioButton sliverGrid;
    private JRadioButton sliverToBoxAdapter;
    private JCheckBox sliverActionButton;
    private JCheckBox sliverBottomBar;
    private JCheckBox sliverDrawer;
    private JCheckBox sliverFab;
    private JCheckBox barSearchIcon;
    private JCheckBox barSaveIcon;
    private JCheckBox barEditIcon;
    private JCheckBox barAddIcon;
    private JPanel bottomPanel;
    private JPanel North;
    private JCheckBox widgetCheckBox;
    private JCheckBox uiOnlyCheckBox;
    private JPanel viewmodel;
    private JCheckBox queryCheckBox;
    private JCheckBox getCheckBox;
    private JCheckBox createCheckBox;
    private JCheckBox updateCheckBox;
    private JCheckBox deleteCheckBox;
    private JCheckBox sliverTabBar;
    private JSONColorizer jsonColorizer;
    private JSONEditCallbacks callbacks;
    private ErrorMessageParser errorMessageParser;
    private boolean isFormatting = false;

    private TextResources textResources;

    public JSONEditDialog(JSONEditCallbacks callbacks, TextResources resources) {
        this.callbacks = callbacks;
        this.textResources = resources;
        setContentPane(contentPane);
        setModal(true);
        setTitle(textResources.getJSONDialogTitle());
        getRootPane().setDefaultButton(buttonOK);

        btnInit.addActionListener(e -> initTemplate());
        buttonOK.addActionListener(e -> onOK());
        buttonCancel.addActionListener(e -> dispose());

        ButtonGroup group = new ButtonGroup();
        group.add(loginRadioButton);
        group.add(mannulRadioButton);
        group.add(sliverRadioButton);
//        group.add(profileRadioButton);

        ButtonGroup sliver = new ButtonGroup();
        sliver.add(sliverFixedList);
        sliver.add(sliverGrid);
        sliver.add(sliverToBoxAdapter);
        uiOnlyCheckBox.addItemListener(e -> {
            jsonTextPanel.setEnabled(!uiOnlyCheckBox.isSelected());
        });
        actionButtonCheckBox.addItemListener(e -> {
            appBarInfo.setVisible(actionButtonCheckBox.isSelected());
        });
        sliverActionButton.addItemListener(e -> {
            appBarInfo.setVisible(sliverActionButton.isSelected());
        });

        sliverToBoxAdapter.addItemListener(e -> {
//            sliverFab.setVisible(sliverToBoxAdapter.isSelected());
        });

        loginRadioButton.addItemListener(e -> {
            detailPanel.setVisible(mannulRadioButton.isSelected());
            CustomScrollView.setVisible(sliverRadioButton.isSelected());
            webViewCheckBox.setVisible(mannulRadioButton.isSelected());
            if (sliverRadioButton.isSelected()) {
                appBarInfo.setVisible(appBarCheckBox.isSelected());
            } else {
                appBarInfo.setVisible(false);
            }
        });
        mannulRadioButton.addItemListener(e -> {
            detailPanel.setVisible(mannulRadioButton.isSelected());
            CustomScrollView.setVisible(sliverRadioButton.isSelected());
            webViewCheckBox.setVisible(mannulRadioButton.isSelected());
            if (sliverRadioButton.isSelected()) {
                appBarInfo.setVisible(appBarCheckBox.isSelected());
            } else {
                appBarInfo.setVisible(false);
            }
        });
        sliverRadioButton.addItemListener(e -> {
            detailPanel.setVisible(mannulRadioButton.isSelected());
            CustomScrollView.setVisible(sliverRadioButton.isSelected());
            webViewCheckBox.setVisible(mannulRadioButton.isSelected());
            if (sliverRadioButton.isSelected()) {
                appBarInfo.setVisible(appBarCheckBox.isSelected());
            } else {
                appBarInfo.setVisible(false);
            }
        });
//        profileRadioButton.addItemListener(e -> {
//            detailPanel.setVisible(mannulRadioButton.isSelected());
//            CustomScrollView.setVisible(sliverRadioButton.isSelected());
//            webViewCheckBox.setVisible(mannulRadioButton.isSelected());
//            if (sliverRadioButton.isSelected()) {
//                appBarInfo.setVisible(appBarCheckBox.isSelected());
//            } else {
//                appBarInfo.setVisible(false);
//            }
//        });

        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                dispose();
            }
        });

        contentPane.registerKeyboardAction(e -> dispose(),
                KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0),
                JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);

        jsonTextPanel.getDocument().addDocumentListener(new DocumentListener() {

            @Override
            public void insertUpdate(DocumentEvent e) {
                if (!isFormatting) {
                    formatJson(jsonTextPanel.getText());
                }
            }

            @Override
            public void removeUpdate(DocumentEvent e) {
                if (!isFormatting) {
                    formatJson(jsonTextPanel.getText());
                }
            }

            @Override
            public void changedUpdate(DocumentEvent e) {
                if (!isFormatting) {
                    formatJson(jsonTextPanel.getText());
                }
            }
        });
        PopupListener popupListener = new PopupListener(GuiHelper.getJsonContextMenuPopup(jsonTextPanel, textResources));
        jsonTextPanel.addMouseListener(popupListener);

        jsonColorizer = new JSONColorizer(jsonTextPanel);
        errorMessageParser = new ErrorMessageParser();
    }

    private void initTemplate() {
        if (callbacks != null) {
            callbacks.onInitTemplate();
        }
    }

    private void onOK() {
        String text = jsonTextPanel.getText();
        if (!uiOnlyCheckBox.isSelected() && text.isEmpty()) {
            Messages.showErrorDialog(textResources.getEmptyJSONMessage(),
                    textResources.getEmptyJSONTitle());
            return;
        }
        String className = classNameTextField.getText();
        if (className.isEmpty()) {
            Messages.showErrorDialog(textResources.getEmptyClassMessage(),
                    textResources.getEmptyClassNameTitle());
            return;
        }

        String pageName = TFpageName.getText();
        if (pageName.isEmpty()) {
            Messages.showErrorDialog(textResources.getEmptyPageMessage(),
                    textResources.getEmptyPageNameTitle());
            return;
        }

        PageModel pageModel = new PageModel();
        pageModel.pageName = pageName;
        pageModel.modelName = className.trim();
        pageModel.isCustomWidget = widgetCheckBox.isSelected();
        pageModel.isUIOnly = uiOnlyCheckBox.isSelected();

        pageModel.viewModelQuery = queryCheckBox.isSelected();
        pageModel.viewModelGet = getCheckBox.isSelected();
        pageModel.viewModelCreate = createCheckBox.isSelected();
        pageModel.viewModelUpdate = updateCheckBox.isSelected();
        pageModel.viewModelDelete = deleteCheckBox.isSelected();
        if (mannulRadioButton.isSelected()) {
            pageModel.pageType = PageType.MANNUL;
            pageModel.genAppBar = appBarCheckBox.isSelected();
            pageModel.genBottomTabBar = bottomTabBarCheckBox.isSelected();
            pageModel.genDrawer = drawerCheckBox.isSelected();
            pageModel.genListView = listViewCheckBox.isSelected();
            pageModel.genTopTabBar = topTabBarCheckBox.isSelected();
            pageModel.genWebView = webViewCheckBox.isSelected();
            pageModel.genActionButton = actionButtonCheckBox.isSelected();
            configActionButton(pageModel);
        } else if (loginRadioButton.isSelected()) {
            pageModel.pageType = PageType.LOGIN;
        } else if (sliverRadioButton.isSelected()) {
            pageModel.pageType = PageType.CUSTOMSCROLLVIEW;
            pageModel.genAppBar = true;
            pageModel.genDrawer = sliverDrawer.isSelected();
            pageModel.genActionButton = sliverActionButton.isSelected();
            pageModel.genSliverFixedList = sliverFixedList.isSelected();
            pageModel.genSliverGrid = sliverGrid.isSelected();
            pageModel.genSliverToBoxAdapter = sliverToBoxAdapter.isSelected();
            pageModel.genSliverFab = sliverFab.isSelected();
            pageModel.genSliverTabBar = sliverTabBar.isSelected();

            configActionButton(pageModel);
//        } else if (profileRadioButton.isSelected()) {
//            pageModel.pageType = PageType.PROFILE;
        }
        processJSON(pageModel, text, className);
    }

    private void configActionButton(PageModel pageModel) {
        if (pageModel.genActionButton) {
            List<String> actionList = new ArrayList();
            if (barSearchIcon.isSelected()) {
                pageModel.hasActionSearch = true;
                actionList.add("search");
            }
            if (barAddIcon.isSelected()) {
                actionList.add("add");
            }
            if (barEditIcon.isSelected()) {
                actionList.add("edit");
            }
            if (barSaveIcon.isSelected()) {
                actionList.add("save");
            }

            pageModel.actionList = actionList;
        }
    }


    private void formatJson(String text) {
        if (text.length() == 0) {
            jsonErrorLabel.setText("");
            jsonColorizer.clearErrorHighLight();
            return;
        }
        if (isFormatting) {
            isFormatting = false;
            return;
        }
        isFormatting = true;
        Runnable doFormatting = () -> {
            try {
                JSONObject json = new JSONObject(text);
                int currentCaretPosition = jsonTextPanel.getCaretPosition();
                jsonTextPanel.setText(json.toString(4));
                jsonTextPanel.setCaretPosition(currentCaretPosition);
                jsonErrorLabel.setText("");
                jsonColorizer.clearErrorHighLight();
            } catch (JSONException jsonException) {
                String errorMessage = jsonException.getMessage();
                jsonErrorLabel.setText(errorMessage);

                ErrorMessageParser.ErrorLocation errorLocation = errorMessageParser.findErrorLocation(errorMessage);
                if (errorLocation != null) {
                    jsonColorizer.highlightError(errorLocation.line, errorLocation.character);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                jsonColorizer.colorize();
                isFormatting = false;
            }
        };
        SwingUtilities.invokeLater(doFormatting);
    }

    private void processJSON(PageModel pageModel, String jsonText, String rootClassName) {
        try {
            if (!pageModel.isUIOnly) {
                SimpleParser parser = new SimpleParser(new DartResolver());
                JSONObject json = new JSONObject(jsonText);
                parser.parse(json, rootClassName);
                pageModel.classModels = parser.getClasses();
            }
            dispose();
            if (callbacks != null) {
                callbacks.onJsonParsed(pageModel);
            }

        } catch (JSONException e) {
            e.printStackTrace();
            Messages.showErrorDialog(textResources.getJSONErrorMessage(e.getMessage()),
                    textResources.getJSONErrorTitle());
        } catch (Exception e) {
            e.printStackTrace();
            Messages.showErrorDialog(textResources.getErrorMessage(e.getMessage()),
                    textResources.getJSONErrorTitle());
        }
    }

    private void createUIComponents() {
        // TODO: place custom component creation code here
    }

    public interface JSONEditCallbacks {
        void onJsonParsed(PageModel pageModel);

        void onInitTemplate();
    }
}
