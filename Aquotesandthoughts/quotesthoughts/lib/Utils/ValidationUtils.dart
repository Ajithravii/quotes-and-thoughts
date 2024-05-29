

class ValidationUtil{
  const ValidationUtil();

  String checkStringForEmpty(String value) {
    try {
      if (value == "null" || value == null) {
        return "(none)";
      }
      return value;
    } catch (exception, stackTrace) {
      print("Unsupported operation" + exception.toString());
      print("stackTrace operation" + stackTrace.toString());
      return "null";
    }
  }


}