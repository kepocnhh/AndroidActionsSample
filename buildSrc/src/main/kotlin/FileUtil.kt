import java.io.File

fun File.existing(): File {
    check(exists()) {
        "File by path \"$absolutePath\" does not exist!"
    }
    return this
}

fun File.forEachRecurse(action: (File) -> Unit) {
    action(this)
    if (isDirectory) {
        listFiles()?.forEach {
            it.forEachRecurse(action)
        }
    }
}

object FileUtil {
    private fun File.findIssues(expected: Set<String>): Set<String> {
        if (!exists()) return setOf("the file does not exist")
        if (isDirectory) return setOf("the file is a directory")
        val result = mutableSetOf<String>()
        val lines = readLines(Charsets.UTF_8)
        if (lines.isEmpty()) return setOf("the file does not contain text")
        expected.forEach {
            if (!lines.contains(it)) result.add("the file does not contain \"$it\" line")
        }
        return result
    }

    fun check(file: File, expected: Set<String>, report: File) {
        val issues = file.findIssues(expected)
        report.delete()
        report.parentFile!!.mkdirs()
        if (issues.isEmpty()) {
            val message = "All checks of the file along the \"${file.name}\" were successful."
            report.writeText(message)
            println(message)
        } else {
            val text = """
<html>
<h3>The following problems were found while checking the <code>${file.name}</code>:</h3>
${issues.joinToString(prefix = "<ul>", postfix = "</ul>", separator = "\n") { "<li>$it</li>" }}
</html>
            """.trimIndent()
            report.writeText(text)
            error("Problems were found while checking the \"${file.name}\". See the report ${report.absolutePath}")
        }
    }
}
