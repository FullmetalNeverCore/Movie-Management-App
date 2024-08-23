public class StringParser {
    @InvocableMethod(label='Split Text by Semicolon' description='Splits a string by semicolon into a list of strings')
    public static List<OutputWrapper> splitTextBySemicolon(List<InputWrapper> input) {
        List<OutputWrapper> result = new List<OutputWrapper>();

        for (InputWrapper item : input) {
            OutputWrapper output = new OutputWrapper();

            if (item != null && String.isNotEmpty(item.text)) {
                output.textCollection = item.text.split(';');
            } else {
                output.textCollection = new List<String>();
            }

            result.add(output);
        }

        return result;
    }

    public class InputWrapper {
        @InvocableVariable(label='Input Text' description='The text to be split by semicolons')
        public String text;
    }

    public class OutputWrapper {
        @InvocableVariable(label='Text Collection' description='List of strings split by semicolons')
        public List<String> textCollection;
    }
}