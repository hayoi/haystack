package haystack.core;

import haystack.core.models.ClassModel;

import java.util.List;

public abstract class SourceFilesGenerator {

    protected LanguageResolver resolver;
    protected AnnotationGenerator annotations;
    protected FileSaver fileSaver;
    protected Listener listener;

    public SourceFilesGenerator(LanguageResolver resolver, AnnotationGenerator annotations, FileSaver fileSaver) {
        this.resolver = resolver;
        this.annotations = annotations;
        this.fileSaver = fileSaver;
    }

    public void setListener(Listener listener) {
        this.listener = listener;
    }

    public abstract void generateFiles(String packageName, List<ClassModel> classDataList);

    public interface Listener {
        void onFilesGenerated(int filesCount);
    }
}