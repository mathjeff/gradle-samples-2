This project demonstrates Gradle saying:

  > Project#afterEvaluate(Closure) on project ':icing' cannot be executed in the current context.

without explaining what the current context is.

If the current context is the instantiation of a particular task, it can be more difficult to identify which task is the problem (this sample project doesn't have many tasks so it's easier to find the problem in this sample project).

Run test.sh to reproduce the error
