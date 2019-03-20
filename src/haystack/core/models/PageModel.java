package haystack.core.models;

import java.util.List;

public class PageModel {
    public String pageName;
    public String pageType;
    public String modelName;
    public boolean genAppBar;
    public boolean genBottomTabBar;
    public boolean genTopTabBar;
    public boolean genListView;
    public boolean genWebView;
    public boolean genDrawer;
    public boolean genActionButton;
    public List<String> actionList;
    public boolean hasActionSearch;

    public boolean genSliverFixedList;
    public boolean genSliverGrid;
    public boolean genSliverToBoxAdapter;
    public boolean genSliverFab;
    public List<ClassModel> classModels;
}
