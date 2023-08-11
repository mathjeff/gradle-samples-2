package sample;

import org.gradle.api.DefaultTask;
import org.gradle.api.tasks.TaskAction;
import org.gradle.workers.WorkAction;
import org.gradle.workers.WorkParameters;
import org.gradle.workers.WorkQueue;

public abstract class CountWorker implements WorkAction<WorkParameters.None> {

  @Override
  public void execute() {
    System.out.println("Counting");
    int i = 0;
    long start = System.currentTimeMillis();
    while (true) {
      long now = System.currentTimeMillis();
      if (now - start >= 40000) {
        System.out.println("done: i = " + i);
        break;
      }
      i++;
    }
  }
}
