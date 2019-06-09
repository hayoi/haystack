package haystack.core.models;

import java.util.List;

public class PageModel {
    public String pageName;
    public String pageType;
    public String modelName;
    public boolean isUIOnly;
    public boolean isCustomWidget;
    public boolean genAppBar;
    public boolean genBottomTabBar;
    public boolean genTopTabBar;
    public boolean genListView;
    public boolean genWebView;
    public boolean genDrawer;
    public boolean genActionButton;
    public List<String> actionList;
    public boolean hasActionSearch;

    public boolean viewModelQuery;
    public boolean viewModelGet;
    public boolean viewModelCreate;
    public boolean viewModelUpdate;
    public boolean viewModelDelete;

    public boolean genSliverFixedList;
    public boolean genSliverGrid;
    public boolean genSliverToBoxAdapter;
    public boolean genSliverFab;
    public boolean genSliverTabBar;
    public boolean genSliverTabView;
    public List<ClassModel> classModels;
}
