package haystack;

import com.intellij.ide.plugins.PluginManager;
import com.intellij.openapi.actionSystem.AnAction;
import com.intellij.openapi.actionSystem.AnActionEvent;
import com.intellij.openapi.actionSystem.DataContext;
import com.intellij.openapi.actionSystem.DataKeys;
import com.intellij.openapi.extensions.PluginId;
import com.intellij.openapi.module.Module;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.roots.FileIndexFacade;
import com.intellij.openapi.roots.ModuleRootManager;
import com.intellij.openapi.ui.Messages;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.pom.Navigatable;
import com.intellij.psi.PsiDirectory;
import com.intellij.psi.PsiFileFactory;
import com.intellij.psi.PsiManager;
import com.intellij.psi.impl.file.PsiDirectoryFactory;
import com.intellij.util.ui.UIUtil;
import freemarker.template.*;
import gherkin.lexer.Fi;
import haystack.core.FileSaver;
import haystack.core.LanguageResolver;
import haystack.core.models.ClassModel;
import haystack.core.models.PageModel;
import haystack.resolver.DartFileType;
import haystack.resolver.DartResolver;
import haystack.ui.JSONEditDialog;
import haystack.ui.ModelTableDialog;
import haystack.ui.TextResources;
import haystack.util.FileUtil;

import java.awt.*;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.io.*;
import java.net.URL;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import static haystack.core.models.PageType.CUSTOMSCROLLVIEW;

public class FlutterReduxGen extends AnAction implements JSONEditDialog.JSONEditCallbacks,
        ModelTableDialog.ModelTableCallbacks {
    private PsiDirectory directory;
    private Point lastDialogLocation;
    private LanguageResolver languageResolver;
    private VirtualFile selectGroup;
    private String sourcePath;
    private TextResources textResources;
    private Configuration cfg;
    private Project project;

    public FlutterReduxGen() {
        super();
    }

    private void configFreemarker(String basePath) {
        /* Create and adjust the configuration singleton */
        cfg = new Configuration(Configuration.VERSION_2_3_27);
        try {
            cfg.setDirectoryForTemplateLoading(new File(basePath));
        } catch (IOException e) {
            e.printStackTrace();
        }
        cfg.setObjectWrapper(new DefaultObjectWrapper(Configuration.VERSION_2_3_27));
        cfg.setDefaultEncoding("UTF-8");
    }

    @Override
    public void actionPerformed(AnActionEvent event) {
        languageResolver = new DartResolver();
        textResources = new TextResources();

        project = event.getProject();
        if (project == null) return;
        sourcePath = project.getBasePath() + "/lib";
        DataContext dataContext = event.getDataContext();
        selectGroup = DataKeys.VIRTUAL_FILE.getData(dataContext);
        final Module module = DataKeys.MODULE.getData(dataContext);
        if (module == null) return;
        final Navigatable navigatable = DataKeys.NAVIGATABLE.getData(dataContext);

        if (navigatable != null) {
            if (navigatable instanceof PsiDirectory) {
                directory = (PsiDirectory) navigatable;
            }
        }

        if (directory == null) {
            ModuleRootManager root = ModuleRootManager.getInstance(module);
            for (VirtualFile file : root.getSourceRoots()) {
                directory = PsiManager.getInstance(project).findDirectory(file);
            }
        }

        String resources = System.getProperty("user.home") + "/.haystack_template_cache/";
        FileUtil.createDir(resources);
        String[] fileNames = {"/popmenu", "/actions.dart.ftl", "/app_reducer.dart.ftl",
                "/app_state.dart.ftl",
                "/database_client.dart.ftl", "/date_picker_widget.dart.ftl", "/i18n_en.json.ftl",
                "/i18n_zh.json.ftl", "/action_report.dart.ftl", "/main.dart.ftl", "/middleware" +
                ".dart.ftl",
                "/model_entry_data.dart.ftl", "/network_common.dart.ftl", "/page_data.dart.ftl",
                "/pubspec.yaml.ftl",
                "/reducer.dart.ftl", "/remote_wrap.dart.ftl", "/repository.dart.ftl",
                "/repository_db.dart.ftl",
                "/settings_option.dart.ftl", "/settings_option_page.dart.ftl", "/spannable_grid" +
                ".dart.ftl", "/state.dart.ftl",
                "/store.dart.ftl", "/swipe_list_item.dart.ftl", "/test_view.dart.ftl",
                "/text_scale.dart.ftl",
                "/theme.dart.ftl", "/toast_utils.dart.ftl", "/translations.dart.ftl", "/view.dart" +
                ".ftl",
                "/view_model.dart.ftl", "/progress_dialog.dart.ftl", "/choice_data.dart.ftl",
                "/action_callback.dart.ftl"
        };
        String version =
                PluginManager.getPlugin(PluginId.getId("com.github.hayoi.haystack")).getVersion();

        if (new File(resources + "version").exists()) {
            String cacheVersion = FileUtil.usingBufferedReader(resources + "version").replace("\n"
                    , "");
            if (!version.equals(cacheVersion)) {
                FileUtil.mkFile(new File(resources + "version"), version);
                for (String name : fileNames) {
                    cacheResources(resources, name);
                }
            }
        } else {
            FileUtil.mkFile(new File(resources + "version"), version);
            for (String name : fileNames) {
                cacheResources(resources, name);
            }
        }

        configFreemarker(resources);

        JSONEditDialog dialog = new JSONEditDialog(this, textResources);
        dialog.addComponentListener(new ComponentAdapter() {
            public void componentMoved(ComponentEvent e) {
                lastDialogLocation = dialog.getLocation();
            }
        });
        dialog.pack();
        dialog.setLocationRelativeTo(null);
        dialog.setVisible(true);
    }

    private void cacheResources(String resources, String fileName) {
        InputStream in = null;
        OutputStream out = null;
        try {
            byte[] tempbytes = new byte[100];
            int byteread = 0;
            in = this.getClass().getResourceAsStream(fileName);
            URL p = this.getClass().getResource(fileName);
            System.out.println("url: " + p.getPath());
            out = new FileOutputStream(resources + fileName);
            while ((byteread = in.read(tempbytes)) != -1) {
                out.write(tempbytes, 0, byteread);
            }
        } catch (Exception e1) {
            e1.printStackTrace();
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e1) {
                }
            }
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e1) {
                }
            }
        }
    }

    @Override
    public void onJsonParsed(PageModel pageModel) {
        if (pageModel.isUIOnly) {
            checkProjectStructure(pageModel);
        } else {
            ModelTableDialog tableDialog = new ModelTableDialog(pageModel, languageResolver,
                    textResources, this);
            if (lastDialogLocation != null) {
                tableDialog.setLocation(lastDialogLocation);
            }
            tableDialog.addComponentListener(new ComponentAdapter() {
                public void componentMoved(ComponentEvent e) {
                    lastDialogLocation = tableDialog.getLocation();
                }
            });

            tableDialog.pack();
            tableDialog.setVisible(true);
        }
    }

    private void checkProjectStructure(PageModel pageModel) {
        if (!new File(sourcePath + "/redux/").exists() ||
                !new File(sourcePath + "/features/").exists() ||
                !new File(sourcePath + "/trans/").exists() ||
                !new File(sourcePath + "/data/").exists()) {
            int result = Messages.showOkCancelDialog(project, "You must init the project first!"
                    , "Init Project", "OK", "NO", Messages.getQuestionIcon());
            if (result == Messages.OK) {
                initTemplate();
                genStructure(pageModel);
            }
        } else {
            genStructure(pageModel);
        }
    }

    @Override
    public void onInitTemplate() {
        initTemplate();
    }

    @Override
    public void onModelsReady(PageModel pageModel) {
        checkProjectStructure(pageModel);
    }

    private void genStructure(PageModel pageModel) {
        Project project = directory.getProject();
        PsiFileFactory factory = PsiFileFactory.getInstance(project);
        PsiDirectoryFactory directoryFactory =
                PsiDirectoryFactory.getInstance(directory.getProject());
        String packageName = directoryFactory.getQualifiedName(directory, true);

        FileSaver fileSaver = new IDEFileSaver(factory, directory, DartFileType.INSTANCE);

        fileSaver.setListener(fileName -> {
            int ok = Messages.showOkCancelDialog(
                    textResources.getReplaceDialogMessage(fileName),
                    textResources.getReplaceDialogTitle(), "OK", "NO",
                    UIUtil.getQuestionIcon());
            return ok == 0;
        });

        final String moduleName =
                FileIndexFacade.getInstance(project).getModuleForFile(directory.getVirtualFile()).getName();

        Map<String, Object> rootMap = new HashMap<String, Object>();
        rootMap.put("ProjectName", moduleName);
        rootMap.put("PageType", pageModel.pageType);
        if (pageModel.pageType.equals(CUSTOMSCROLLVIEW)) {
            rootMap.put("GenerateCustomScrollView", true);
        } else {
            rootMap.put("GenerateCustomScrollView", false);
        }
        rootMap.put("PageName", pageModel.pageName);
        rootMap.put("ModelEntryName", pageModel.modelName);
        rootMap.put("GenerateListView", pageModel.genListView);
        rootMap.put("GenerateBottomTabBar", pageModel.genBottomTabBar);
        rootMap.put("GenerateAppBar", pageModel.genAppBar);
        rootMap.put("GenerateDrawer", pageModel.genDrawer);
        rootMap.put("GenerateTopTabBar", pageModel.genTopTabBar);
        rootMap.put("GenerateWebView", pageModel.genWebView);
        rootMap.put("GenerateActionButton", pageModel.genActionButton);

        rootMap.put("viewModelQuery", pageModel.viewModelQuery);
        rootMap.put("viewModelGet", pageModel.viewModelGet);
        rootMap.put("viewModelCreate", pageModel.viewModelCreate);
        rootMap.put("viewModelUpdate", pageModel.viewModelUpdate);
        rootMap.put("viewModelDelete", pageModel.viewModelDelete);

        rootMap.put("GenSliverFixedExtentList", pageModel.genSliverFixedList);
        rootMap.put("GenSliverGrid", pageModel.genSliverGrid);
        rootMap.put("GenSliverToBoxAdapter", pageModel.genSliverToBoxAdapter);
        rootMap.put("FabInAppBar", pageModel.genSliverFab);
        rootMap.put("GenSliverTabBar", pageModel.genSliverTabBar);
        rootMap.put("GenSliverTabView", pageModel.genSliverTabView);
        rootMap.put("IsCustomWidget", pageModel.isCustomWidget);

        if (pageModel.genActionButton) {
            rootMap.put("HasActionSearch", pageModel.hasActionSearch);
            rootMap.put("ActionList", pageModel.actionList);
            rootMap.put("ActionBtnCount", pageModel.actionList.size());
        } else {
            rootMap.put("HasActionSearch", false);
            rootMap.put("ActionList", new ArrayList<String>());
            rootMap.put("ActionBtnCount", 0);
        }
        if (!pageModel.isUIOnly) {
            for (ClassModel classModel : pageModel.classModels) {
                if (classModel.getName().equals(pageModel.modelName)) {
                    rootMap.put("genDatabase", classModel.isGenDBModule());

                    if (classModel.getUniqueField() != null) {
                        rootMap.put("clsUNName", classModel.getUniqueField());
                        rootMap.put("clsUNNameType", classModel.getUniqueFieldType());
                    }
                }
                generateModelEntry(classModel, rootMap);
            }

            generateRepository(rootMap);
            generateRedux(rootMap);
        }
        generateFeature(rootMap, pageModel.isCustomWidget, pageModel.genSliverTabView);
    }

    private void generateRedux(Map<String, Object> rootMap) {
        String path = sourcePath + "/redux";
        FileUtil.generateFile(new File(path + "/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "_actions.dart"), "actions.dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(path + "/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "_middleware.dart"), "middleware.dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(path + "/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "_reducer.dart"), "reducer.dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(path + "/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "_state.dart"), "state.dart.ftl", rootMap, cfg);

        writeAppState(rootMap);
        writeAppReducer(rootMap);
        writeStore(rootMap);
    }

    private void writeStore(Map<String, Object> rootMap) {
        String path = sourcePath + "/redux/store.dart";
        String content = FileUtil.usingBufferedReader(path);
        StringBuilder sb = new StringBuilder();
        String param =
                "import 'package:" + rootMap.get("ProjectName").toString().toLowerCase() +
                        "/redux/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "_middleware.dart';\n";
        if (!content.contains(param)) {
            sb.append(param);
        }

        param = "\n      ..addAll(create" + rootMap.get("ModelEntryName").toString() +
                "Middleware())";
        if (!content.contains(param)) {
            int poi1 = content.indexOf("middleware: []") + "middleware: []".length();
            sb.append(content.substring(0, poi1));
            sb.append(param);

            sb.append(content.substring(poi1));

            FileUtil.writeToFile(path, sb.toString(), false);
        }
    }

    private void writeAppReducer(Map<String, Object> rootMap) {
        String path = sourcePath + "/redux/app/app_reducer.dart";
        String content = FileUtil.usingBufferedReader(path);
        StringBuilder sb = new StringBuilder();
        String param =
                "import 'package:" + rootMap.get("ProjectName").toString().toLowerCase() +
                        "/redux/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "_reducer.dart';\n";
        if (!content.contains(param)) {
            sb.append(param);
        }
        param = "\n    " + rootMap.get("ModelEntryName").toString().toLowerCase() + "State: " + rootMap.get("ModelEntryName").toString().toLowerCase() + "Reducer(state." + rootMap.get("ModelEntryName").toString().toLowerCase() + "State, action),";
        if (!content.contains(param)) {
            int poi1 = content.indexOf("return new AppState(") + "return new AppState(".length();
            sb.append(content.substring(0, poi1));
            sb.append(param);

            sb.append(content.substring(poi1));

            FileUtil.writeToFile(path, sb.toString(), false);
        }
    }

    private void writeAppState(Map<String, Object> rootMap) {
        String path = sourcePath + "/redux/app/app_state.dart";
        String content = FileUtil.usingBufferedReader(path);
        String param =
                "import 'package:" + rootMap.get("ProjectName").toString().toLowerCase() +
                        "/redux/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "_state.dart';\n";
        StringBuilder sb = new StringBuilder();
        if (!content.contains(param)) {
            sb.append(param);
        }
        param = "\n  final " + rootMap.get("ModelEntryName").toString() + "State " + rootMap.get(
                "ModelEntryName").toString().toLowerCase() + "State;";
        int poi1 = content.indexOf("class AppState {") + "class AppState {".length();
        if (!content.contains(param)) {
            sb.append(content.substring(0, poi1));
            sb.append(param);
        }
        int poi2 = content.indexOf("AppState({") + "AppState({".length();
        param = "\n    @required this." + rootMap.get("ModelEntryName").toString().toLowerCase() + "State,";
        if (!content.contains(param)) {
            sb.append(content.substring(poi1, poi2));
            sb.append(param);

        }
        int poi3 = content.indexOf("return AppState(") + "return AppState(".length();
        param = "\n        " + rootMap.get("ModelEntryName").toString().toLowerCase() + "State: " + rootMap.get("ModelEntryName").toString() + "State(\n" +
                "            " + rootMap.get("ModelEntryName").toString().toLowerCase() + ": " +
                "null,\n" +
                "            " + rootMap.get("ModelEntryName").toString().toLowerCase() + "s: Map" +
                "(),\n" +
                "            page: Page(),),";
        if (!content.contains(param)) {
            sb.append(content.substring(poi2, poi3));
            sb.append(param);
            sb.append(content.substring(poi3));

            FileUtil.writeToFile(path, sb.toString(), false);
        }
    }


    private void initTemplate() {
        final String moduleName =
                FileIndexFacade.getInstance(project).getModuleForFile(directory.getVirtualFile()).getName();

        Map<String, Object> rootMap = new HashMap<String, Object>();
        rootMap.put("ProjectName", moduleName);
        FileUtil.generateFile(new File(project.getBasePath() + "/pubspec.yaml"), "pubspec.yaml" +
                ".ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/main.dart"), "main.dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/data/network_common.dart"), "network_common" +
                ".dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/utils/progress_dialog.dart"),
                "progress_dialog.dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/utils/toast_utils.dart"), "toast_utils.dart" +
                ".ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/data/model/remote_wrap.dart"), "remote_wrap" +
                ".dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/data/model/choice_data.dart"), "choice_data" +
                ".dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/data/model/page_data.dart"), "page_data" +
                ".dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/trans/translations.dart"), "translations" +
                ".dart.ftl", rootMap, cfg);

        FileUtil.generateFile(new File(sourcePath + "/redux/store.dart"), "store.dart.ftl",
                rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/redux/action_report.dart"), "action_report" +
                ".dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/redux/app/app_reducer.dart"), "app_reducer" +
                ".dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/redux/app/app_state.dart"), "app_state.dart" +
                ".ftl", rootMap, cfg);

        FileUtil.generateFile(new File(project.getBasePath() + "/locale/i18n_en.json"), "i18n_en" +
                ".json.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(project.getBasePath() + "/locale/i18n_zh.json"), "i18n_zh" +
                ".json.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/data/db/database_client.dart"),
                "database_client.dart.ftl", rootMap, cfg);

        FileUtil.generateFile(new File(sourcePath + "/features/action_callback.dart"),
                "action_callback.dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/features/settings/settings_option.dart"),
                "settings_option.dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/features/settings/settings_option_page" +
                ".dart"), "settings_option_page.dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/features/settings/theme.dart"), "theme.dart" +
                ".ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/features/settings/text_scale.dart"),
                "text_scale.dart.ftl", rootMap, cfg);

        FileUtil.generateFile(new File(sourcePath + "/features/widget/date_picker_widget.dart"),
                "date_picker_widget.dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/features/widget/spannable_grid.dart"),
                "spannable_grid.dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(sourcePath + "/features/widget/swipe_list_item.dart"),
                "swipe_list_item.dart.ftl", rootMap, cfg);

        Messages.showMessageDialog(project, "Project init completed！", "Initialize",
                Messages.getInformationIcon());
    }

    private void generateFeature(Map<String, Object> rootMap, boolean isCustomWidget,
                                 boolean tabView) {
        String path =
                sourcePath + "/features/" + (isCustomWidget ? "customize/" : "") + rootMap.get(
                        "PageName").toString().toLowerCase() + "/"
                + rootMap.get("PageName").toString().toLowerCase();
        FileUtil.generateFile(new File(path + (tabView ? "_tab" : "") + "_view_model.dart"),
                "view_model.dart.ftl", rootMap, cfg);
        FileUtil.generateFile(new File(path + (tabView ? "_tab" : "") + "_view.dart"), "view.dart.ftl", rootMap, cfg);
    }

    private void generateRepository(Map<String, Object> rootMap) {
        String path = sourcePath + "/data";

        boolean db = (boolean) rootMap.get("genDatabase");
        if ((db)) {
            FileUtil.generateFile(new File(path + "/db/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "_repository_db.dart"), "repository_db.dart.ftl", rootMap, cfg);
        }
        FileUtil.generateFile(new File(path + "/remote/" + rootMap.get("ModelEntryName").toString().toLowerCase() + "_repository.dart"), "repository.dart.ftl", rootMap, cfg);
    }


    private void generateModelEntry(ClassModel classModel, Map map) {

        Map<String, Object> subMap = new HashMap<String, Object>(map);
        subMap.remove("ModelEntryName");
        subMap.put("ModelEntryName", classModel.getName());
        subMap.put("genDatabase", classModel.isGenDBModule());
        subMap.put("Fields", classModel.getFields());

        File f = new File(sourcePath + "/data/model/" + classModel.getName().toLowerCase() +
                "_data.dart");
        FileUtil.generateFile(f, "model_entry_data.dart.ftl", subMap, cfg);
        if (classModel.isGenDBModule()) {
            writeDatabaseClient(subMap);
        }
    }

    private void writeDatabaseClient(Map<String, Object> rootMap) {
        String path = sourcePath + "/data/db/database_client.dart";
        String content = FileUtil.usingBufferedReader(path);
        String param =
                "import 'package:" + rootMap.get("ProjectName").toString().toLowerCase() + "/data" +
                        "/model/" + rootMap.get("ModelEntryName").toString().toLowerCase() +
                        "_data.dart';\n";
        StringBuilder sb = new StringBuilder();
        if (!content.contains(param)) {
            sb.append(param);
        }
        param = "\n      d..delete(\"" + rootMap.get("ModelEntryName").toString().toLowerCase() + "\");\n" +
                "      " + rootMap.get("ModelEntryName").toString() + ".createTable(d);";
        int poi1 = content.indexOf("onUpgrade: (d, o, n) {") + "onUpgrade: (d, o, n) {".length();
        if (!content.contains(param)) {
            sb.append(content.substring(0, poi1));
            sb.append(param);
        }
        int poi2 = content.indexOf("onOpen: (d) {") + "onOpen: (d) {".length();
        param = "\n      " + rootMap.get("ModelEntryName").toString() + ".createTable(d);";
        if (!content.contains(param)) {
            sb.append(content.substring(poi1, poi2));
            sb.append(param);
            sb.append(content.substring(poi2));

            FileUtil.writeToFile(path, sb.toString(), false);
        }
    }

}
