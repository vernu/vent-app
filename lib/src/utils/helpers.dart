bool isTagValidString(String tag) {
  return RegExp(r"^[A-Za-z0-9][A-Za-z0-9-_]*").hasMatch(tag);
}
