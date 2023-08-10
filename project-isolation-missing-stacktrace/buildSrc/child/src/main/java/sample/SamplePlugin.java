package sample;

import org.gradle.api.Plugin;
import org.gradle.api.Project;

public class SamplePlugin implements Plugin<Project> {
    @Override
    public void apply(Project project) {
        System.out.println("Applying " + this + " to " + project);
        for (Project subproject : project.getSubprojects()) {
            System.out.println("" + this + " visiting " + subproject + " with build dir " + subproject.getBuildDir());
        }
    }
}
