package haystack.util;

import com.intellij.openapi.ui.Messages;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

import java.io.*;
import java.nio.channels.FileChannel;
import java.util.LinkedList;
import java.util.Map;

public class FileUtil {
    public static String traverseFolder(String path) {
        File file = new File(path);
        if (file.exists()) {
            LinkedList<File> list = new LinkedList<File>();
            File[] files = file.listFiles();
            for (File file2 : files) {
                if (file2.isDirectory()) {
                    System.out.println("文件夹:" + file2.getAbsolutePath());
                    if (file2.getName().endsWith("base")) {
                        return file2.getAbsolutePath();
                    }
                    list.add(file2);
                }
            }
            File temp_file;
            while (!list.isEmpty()) {
                temp_file = list.removeFirst();
                files = temp_file.listFiles();
                for (File file2 : files) {
                    if (file2.isDirectory()) {
                        System.out.println("文件夹:" + file2.getAbsolutePath());
                        if (file2.getName().endsWith("base")) {
                            return file2.getAbsolutePath();
                        }
                        list.add(file2);

                    }
                }
            }
        } else {
            System.out.println("文件不存在!");
        }
        System.out.println("没有发现文件");
        return "";
    }

    public static boolean createFile(String destFileName) {
        File file = new File(destFileName);
        if (file.exists()) {
            System.out.println("创建单个文件" + destFileName + "失败，目标文件已存在！");
            return false;
        }
        if (destFileName.endsWith(File.separator)) {
            System.out.println("创建单个文件" + destFileName + "失败，目标文件不能为目录！");
            return false;
        }
        //判断目标文件所在的目录是否存在
        if (!file.getParentFile().exists()) {
            //如果目标文件所在的目录不存在，则创建父目录
            System.out.println("目标文件所在目录不存在，准备创建它！");
            if (!file.getParentFile().mkdirs()) {
                System.out.println("创建目标文件所在目录失败！");
                return false;
            }
        }
        //创建目标文件
        try {
            if (file.createNewFile()) {
                System.out.println("创建单个文件" + destFileName + "成功！");
                return true;
            } else {
                System.out.println("创建单个文件" + destFileName + "失败！");
                return false;
            }
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("创建单个文件" + destFileName + "失败！" + e.getMessage());
            return false;
        }
    }

    public static boolean createDir(String destDirName) {
        File dir = new File(destDirName);
        if (dir.exists()) {
            System.out.println("创建目录" + destDirName + "失败，目标目录已经存在");
            return false;
        }
        if (!destDirName.endsWith(File.separator)) {
            destDirName = destDirName + File.separator;
        }
        //创建目录
        if (dir.mkdirs()) {
            System.out.println("创建目录" + destDirName + "成功！");
            return true;
        } else {
            System.out.println("创建目录" + destDirName + "失败！");
            return false;
        }
    }

    public static String createTempFile(String prefix, String suffix, String dirName) {
        File tempFile = null;
        if (dirName == null) {
            try {
                //在默认文件夹下创建临时文件
                tempFile = File.createTempFile(prefix, suffix);
                //返回临时文件的路径
                return tempFile.getCanonicalPath();
            } catch (IOException e) {
                e.printStackTrace();
                System.out.println("创建临时文件失败！" + e.getMessage());
                return null;
            }
        } else {
            File dir = new File(dirName);
            //如果临时文件所在目录不存在，首先创建
            if (!dir.exists()) {
                if (!createDir(dirName)) {
                    System.out.println("创建临时文件失败，不能创建临时文件所在的目录！");
                    return null;
                }
            }
            try {
                //在指定目录下创建临时文件
                tempFile = File.createTempFile(prefix, suffix, dir);
                return tempFile.getCanonicalPath();
            } catch (IOException e) {
                e.printStackTrace();
                System.out.println("创建临时文件失败！" + e.getMessage());
                return null;
            }
        }
    }

    public static void writeToFile(String path, String content, boolean append) {
        try {
            File file = new File(path);
            FileWriter fileWriter = new FileWriter(file, append);
            fileWriter.write(content);
            fileWriter.flush();
            fileWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void generateFile(File file, String template, Map entryModel, Configuration cfg) {
        if (file.exists()) {
            String path = file.getPath();
            String fileName = path.substring(path.lastIndexOf("\\") + 1);
            int result = Messages.showOkCancelDialog(fileName + " already exist. Do you want to recover it?"
                    , "Recover File", "OK", "NO", Messages.getWarningIcon());
            if (result == Messages.OK) {
                mkFile(file, template, entryModel, cfg);
            }
        } else {
            mkFile(file, template, entryModel, cfg);
        }
    }

    public static void mkFile(File file, String content) {
        String folder = file.getParentFile().getPath();
        createDir(folder);
        /* Get the template (uses cache internally) */
        try {
            Writer out = new OutputStreamWriter(new FileOutputStream(file), "utf-8");
            out.write(content);
            out.flush();
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void mkFile(File file, String template, Map entryModel, Configuration cfg) {
        String folder = file.getParentFile().getPath();
        createDir(folder);
        /* Get the template (uses cache internally) */
        Template temp = null;
        try {
            temp = cfg.getTemplate(template);
            /* Merge data-model with template */

            Writer out = new OutputStreamWriter(new FileOutputStream(file), "utf-8");
            temp.process(entryModel, out);
            out.flush();
            out.close();
        } catch (IOException | TemplateException e) {
            e.printStackTrace();
        }
    }


    public static String usingBufferedReader(String filePath) {
        StringBuilder contentBuilder = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {

            String sCurrentLine;
            while ((sCurrentLine = br.readLine()) != null) {
                contentBuilder.append(sCurrentLine).append("\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return contentBuilder.toString();
    }

    public void insert(String filename, long offset, String content) {
        try {
            RandomAccessFile r = new RandomAccessFile(new File(filename), "rw");
            RandomAccessFile rtemp = new RandomAccessFile(new File(filename + "~"), "rw");
            long fileSize = r.length();
            FileChannel sourceChannel = r.getChannel();
            FileChannel targetChannel = rtemp.getChannel();
            sourceChannel.transferTo(offset, (fileSize - offset), targetChannel);
            sourceChannel.truncate(offset);
            r.seek(offset);
            r.writeUTF(content);
            long newOffset = r.getFilePointer();
            targetChannel.position(0L);
            sourceChannel.transferFrom(targetChannel, newOffset, (fileSize - offset));
            sourceChannel.close();
            targetChannel.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}