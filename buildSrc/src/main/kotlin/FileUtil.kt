import java.io.File

fun File.existing(): File {
    check(exists()) {
        "File by path \"$absolutePath\" does not exist!"
    }
    return this
}
