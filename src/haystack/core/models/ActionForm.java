package haystack.core.models;

import java.util.List;

public class ActionForm {
    private String actionName;
    private List<FieldModel> parameters;
    private FieldModel stateVariable;

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
}
