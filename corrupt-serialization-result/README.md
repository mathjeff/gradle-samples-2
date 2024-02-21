This project demonstrates reporting a Corrupt serialized resolution result.

Run test.sh to reproduce the error

Potentially interesting, it appears that converting lifecycle/lifecycle-livedata-core to multiplatform makes the error stop happening:

    $ git diff
    diff --git a/corrupt-serialization-result/lifecycle/lifecycle-livedata-core/build.gradle b/corrupt-serialization-result/lifecycle/lifecycle-livedata-core/build.gradle
    index 416541b..e99d0ae 100755
    --- a/corrupt-serialization-result/lifecycle/lifecycle-livedata-core/build.gradle
    +++ b/corrupt-serialization-result/lifecycle/lifecycle-livedata-core/build.gradle
    @@ -1,5 +1,9 @@
     plugins {
       id("com.android.library")
    +  id "org.jetbrains.kotlin.multiplatform"
    +}
    +kotlin {
    +  android()
     }
     android {
       namespace "androidx.lifecycle.livedata.core"
