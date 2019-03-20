package haystack.ui;

import com.intellij.openapi.ui.ComboBox;
import haystack.core.LanguageResolver;
import haystack.core.models.ClassModel;
import haystack.core.models.FieldModel;

import javax.swing.*;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.TableColumn;
import java.util.List;

public class FieldsTableDelegate {

    private JTable fieldsTable;
    private String columns[];
    private List<FieldModel> fieldsData;
    private LanguageResolver languageResolver;


    public FieldsTableDelegate(JTable fieldsTable, LanguageResolver resolver, TextResources textResources) {
        this.fieldsTable = fieldsTable;
        this.languageResolver = resolver;
        columns = textResources.getFieldsTableColumns();
    }

    public void setClass(ClassModel classModel) {
        fieldsData = classModel.getFields();
        fieldsTable.setModel(new FieldsTableModel(fieldsData));

        TableColumn column = fieldsTable.getColumnModel().getColumn(0);
        column.setPreferredWidth(30);

        TableColumn modifierColumn = fieldsTable.getColumnModel().getColumn(2);
        ComboBox<String> modifierCombobox = new ComboBox<>();
        List<String> typeList = languageResolver.getSupportTypeList();
        for (int i = 0; i < typeList.size(); i++) {
            modifierCombobox.addItem(typeList.get(i));
        }

        modifierColumn.setCellEditor(new DefaultCellEditor(modifierCombobox));

        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        for (int i = 1; i < columns.length; i++) {
            fieldsTable.getColumnModel().getColumn(i).setCellRenderer(centerRenderer);
        }
    }

    public List<FieldModel> getFieldsData() {
        return fieldsData;
    }


    class FieldsTableModel extends AbstractTableModel {

        private List<FieldModel> items;

        public FieldsTableModel(List<FieldModel> items) {
            this.items = items;
        }

        @Override
        public int getRowCount() {
            return items.size();
        }

        @Override
        public int getColumnCount() {
            return columns.length;
        }

        @Override
        public Class<?> getColumnClass(int columnIndex) {
            switch (columnIndex) {
                case 0:
                    return Boolean.class;
                case 1:
                    return String.class;
                case 2:
                    return String.class;
                case 3:
                    return String.class;
            }
            return super.getColumnClass(columnIndex);
        }

        @Override
        public Object getValueAt(int rowIndex, int columnIndex) {
            FieldModel fieldData = items.get(rowIndex);
            switch (columnIndex) {
                case 0:
                    return fieldData.isEnabled();
                case 1:
                    return fieldData.getName();
                case 2:
                    return fieldData.getType();
                case 3:
                    return fieldData.getDefaultValue();
            }
            return null;
        }

        @Override
        public void setValueAt(Object aValue, int rowIndex, int columnIndex) {
            FieldModel fieldData = items.get(rowIndex);
            switch (columnIndex) {
                case 0:
                    fieldData.setEnabled((Boolean) aValue);
                    break;
                case 1:
                    fieldData.setName((String) aValue);
                    break;
                case 2:
                    fieldData.setType((String) aValue);
                    break;
                case 3:
                    fieldData.setDefaultValue((String) aValue);
                    break;
            }
        }

        @Override
        public boolean isCellEditable(int row, int col) {
            return col != 5;
        }

        @Override
        public String getColumnName(int col) {
            return columns[col];
        }
    }
}
