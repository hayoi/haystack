package haystack.core.models;

import java.util.List;

public class ActionForm {
    private String actionName;
    private List<FieldModel> parameters;
    private FieldModel stateVariable;
    private String reducerActionName;
    private List<FieldModel> reducerParameters;
    private boolean methodInRepository;
    private boolean reducer;

    public String getActionName() {
        return actionName;
    }

    public void setActionName(String actionName) {
        this.actionName = actionName;
    }

    public List<FieldModel> getParameters() {
        return parameters;
    }

    public void setParameters(List<FieldModel> parameters) {
        this.parameters = parameters;
    }

    public FieldModel getStateVariable() {
        return stateVariable;
    }

    public void setStateVariable(FieldModel stateVariable) {
        this.stateVariable = stateVariable;
    }

    public String getReducerActionName() {
        return reducerActionName;
    }

    public void setReducerActionName(String reducerActionName) {
        this.reducerActionName = reducerActionName;
    }

    public List<FieldModel> getReducerParameters() {
        return reducerParameters;
    }

    public void setReducerParameters(List<FieldModel> reducerParameters) {
        this.reducerParameters = reducerParameters;
    }

    public boolean isMethodInRepository() {
        return methodInRepository;
    }

    public void setMethodInRepository(boolean methodInRepository) {
        this.methodInRepository = methodInRepository;
    }

    public boolean isReducer() {
        return reducer;
    }

    public void setReducer(boolean reducer) {
        this.reducer = reducer;
    }
}
