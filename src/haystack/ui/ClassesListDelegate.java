package haystack.ui;


import haystack.core.models.ClassModel;

import javax.swing.*;
import javax.swing.table.AbstractTableModel;
import java.util.HashMap;
import java.util.List;

public class ClassesListDelegate {


    public ClassesListDelegate(JTable list, List<ClassModel> classDataList, HashMap<String, String> classNames,
                               OnClassSelectedListener listener) {
//        if (classDataList.size() == 1) {
//            list.setVisible(false);
//        } else {
//            list.setVisible(true);
//        }

        list.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);

        list.setModel(new ClassesListModel(classDataList, classNames));

        ListSelectionModel selectionModel = list.getSelectionModel();

        selectionModel.addListSelectionListener(e -> {
            int[] selectedRow = list.getSelectedRows();
            if (selectedRow == null) return;
            if (selectedRow.length == 0) return;
            int selectedIndex = selectedRow[0];
            if (listener != null) {
                listener.onClassSelected(classDataList.get(selectedIndex), selectedIndex);
            }
        });
    }

    public interface OnClassSelectedListener {
        void onClassSelected(ClassModel classData, int index);
    }

    class ClassesListModel extends AbstractTableModel {

        private HashMap<String, String> classNames;
        private List<ClassModel> classData;

        public ClassesListModel(List<ClassModel> classDataList, HashMap<String, String> classNames) {
            this.classData = classDataList;
            this.classNames = classNames;
        }

        @Override
        public int getRowCount() {
            return classData.size();
        }

        @Override
        public int getColumnCount() {
            return 2;
        }

        @Override
        public Class<?> getColumnClass(int columnIndex) {
            switch (columnIndex) {
                case 0:
                    return Boolean.class;
                case 1:
                    return String.class;
            }
            return super.getColumnClass(columnIndex);
        }

        @Override
        public Object getValueAt(int rowIndex, int columnIndex) {
            switch (columnIndex) {
                case 0:
                    return classData.get(rowIndex).isGenApi();
                case 1:
                    return classNames.get(classData.get(rowIndex).getName());
            }
            return classNames.get(classData.get(rowIndex).getName());
        }

        @Override
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return true;
        }

        @Override
        public void setValueAt(Object aValue, int rowIndex, int columnIndex) {
            switch (columnIndex) {
                case 0:
                    if (aValue instanceof Boolean) {
                        classData.get(rowIndex).setGenApi((Boolean) aValue);
                    }
                case 1:
                    if (aValue instanceof String) {
                        String newValue = (String) aValue;
                        classNames.put(classData.get(rowIndex).getName(), newValue);
                    }
            }
        }

        @Override
        public String getColumnName(int column) {
            switch (column) {
                case 0:
                    return "gen Api";
                case 1:
                    return "class name";
            }
            return "";
        }
    }

}
