fun String.filled(): String {
    check(isNotEmpty()) {
        "String is empty!"
    }
    return this
}
