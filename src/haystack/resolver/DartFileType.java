package haystack.resolver;


import com.intellij.openapi.fileTypes.FileType;
import com.intellij.openapi.vfs.VirtualFile;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;

public class DartFileType implements FileType {

    public static final DartFileType INSTANCE = new DartFileType();

    @NotNull
    @Override
    public String getName() {
        return "Dart file";
    }

    @NotNull
    @Override
    public String getDescription() {
        return "Dart source file";
    }

    @NotNull
    @Override
    public String getDefaultExtension() {
        return ".dart";
    }

    @Nullable
    @Override
    public Icon getIcon() {
        return null;
    }

    @Override
    public boolean isBinary() {
        return false;
    }

    @Override
    public boolean isReadOnly() {
        return false;
    }

    @Nullable
    @Override
    public String getCharset(@NotNull VirtualFile virtualFile, @NotNull byte[] bytes) {
        return null;
    }

}
