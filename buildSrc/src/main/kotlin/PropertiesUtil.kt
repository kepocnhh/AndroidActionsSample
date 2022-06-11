import java.io.File
import java.util.Properties

fun File.toProperties(): Properties {
    val result = Properties()
    inputStream().use(result::load)
    return result
}

fun Properties.requireString(key: String): String {
    check(containsKey(key)) {
        "Property by key \"$key\" does not exist!"
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
