package sample;

import sample.CountTask;
import org.gradle.api.Plugin;
import org.gradle.api.Project;

public class SamplePlugin implements Plugin<Project> {
    @Override
    public void apply(Project project) {
        project.getTasks().create("slowTask", CountTask.class);
    }
}
