package app;

public class TextReverser {
    public static String reverse(String input) {
        return new StringBuilder(input).reverse().toString();
    }
}
