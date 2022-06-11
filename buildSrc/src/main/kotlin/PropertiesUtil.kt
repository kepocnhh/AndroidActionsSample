import java.io.File
import java.util.Properties

fun File.toProperties(): Properties {
    val result = Properties()
    inputStream().use(result::load)
    return result
}

fun Properties.requireString(key: String): String {
    check(containsKey(key)) {
        "Properties does not contain the key \"$key\"."
    }
    val result = get(key)
    checkNotNull(result) {
        "Value by key \"$key\" is null!"
    }
    check(result is String) {
        "Value by key \"$key\" is not String!"
    }
    return result
}
