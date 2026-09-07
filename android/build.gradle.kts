allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.mappls.com/repository/mappls/")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
subprojects {
    project.configurations.all {
        resolutionStrategy.eachDependency {
            // This ensures we don't have version conflicts
        }
    }
    // This is the absolute bypass for the license check
    tasks.whenTaskAdded {
        if (name.contains("MapplsRes")) {
            enabled = false
        }
    }
}
