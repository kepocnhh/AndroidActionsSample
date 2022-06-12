object MarkdownUtil {
    fun url(
        text: String,
        value: String
    ): String {
        return "[$text]($value)"
    }

    fun image(
        text: String,
        url: String
    ): String {
        return "!" + url(text = text, value = url)
    }
}
