package example

import javax.inject.Inject
import org.gradle.api.component.SoftwareComponentFactory
import org.gradle.api.services.BuildService
import org.gradle.api.services.BuildServiceParameters

abstract class SampleService
@Inject
constructor(val softwareComponentFactory: SoftwareComponentFactory) : BuildService<BuildServiceParameters.None> {

  init {
    System.out.println("Created SampleService with a reference to a SoftwareComponentFactory. Nice!")
  }

}
