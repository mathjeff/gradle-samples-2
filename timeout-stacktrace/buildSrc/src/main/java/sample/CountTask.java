package sample;

import org.gradle.api.DefaultTask;
import org.gradle.api.tasks.TaskAction;
import org.gradle.workers.WorkerExecutor;
import org.gradle.workers.WorkQueue;

import javax.inject.Inject;

public abstract class CountTask extends DefaultTask {
  @Inject
  abstract public WorkerExecutor getWorkerExecutor();

  @TaskAction
  public void run() throws InterruptedException {
    WorkQueue workQueue = getWorkerExecutor().noIsolation();
    workQueue.submit(CountWorker.class, parameters -> {});
  }
}
