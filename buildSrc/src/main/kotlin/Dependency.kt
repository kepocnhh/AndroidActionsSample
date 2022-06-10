sealed class Dependency(
	val group: String,
	val name: String,
	val version: String
) {

	fun notation(): String {
		return "$group:$name:$version"
	}

    object Android {
        object ToolsBuildGradle : Dependency(
            group = "com.android.tools.build",
            name = "gradle",
            version = Version.Android.toolsBuildGradle
        )
    }
}
