package sample;

import org.gradle.api.DefaultTask;
import org.gradle.api.file.FileCollection;
import org.gradle.api.tasks.CacheableTask;
import org.gradle.api.tasks.TaskAction;
import org.gradle.api.tasks.InputFiles;
import org.gradle.api.tasks.OutputFile;
import org.gradle.api.tasks.OutputDirectory;
import org.gradle.api.tasks.PathSensitive;
import org.gradle.api.tasks.PathSensitivity;
import org.gradle.api.tasks.SkipWhenEmpty;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import javax.inject.Inject;

@CacheableTask
public abstract class ExampleTask extends DefaultTask {
  @SkipWhenEmpty
  @InputFiles
  @PathSensitive(PathSensitivity.RELATIVE)
  public FileCollection getInput1() {
    return input1;
  }
  public void setInput1(FileCollection f) {
    this.input1 = f;
  }
  private FileCollection input1;

  @SkipWhenEmpty
  @InputFiles
  @PathSensitive(PathSensitivity.RELATIVE)
  public FileCollection getInput2() {
    return input2;
  }
  public void setInput2(FileCollection f) {
    this.input2 = f;
  }
  private FileCollection input2;

  @OutputDirectory
  public FileCollection getOutputFiles() {
    return outputFiles;
  }
  public void setOutputFiles(FileCollection f) {
    this.outputFiles = f;
  }
  private FileCollection outputFiles;

  @TaskAction
  public void run() throws IOException {
    System.out.println("ExampleTask running");
  }
}
