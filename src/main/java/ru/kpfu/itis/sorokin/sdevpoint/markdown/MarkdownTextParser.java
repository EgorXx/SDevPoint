package ru.kpfu.itis.sorokin.sdevpoint.markdown;

import org.commonmark.node.*;
import org.commonmark.parser.Parser;
import org.springframework.stereotype.Component;

import java.util.regex.Pattern;

@Component
public class MarkdownTextParser {

    private static final Pattern FRONT_MATTER =
            Pattern.compile("(?s)^---\\s*\\R.*?\\R---\\s*\\R?");

    private static final Pattern MULTIPLE_SPACES =
            Pattern.compile("\\s+");

    private final Parser parser = Parser.builder().build();

    public String parse(String markdown, int maxLength) {
        if (markdown == null || markdown.isBlank()) {
            return "";
        }

        if (maxLength < 0) {
            throw new IllegalArgumentException("maxLength must be >= 0");
        }

        String withoutFrontMatter = FRONT_MATTER.matcher(markdown).replaceFirst("");

        Node document = parser.parse(withoutFrontMatter);

        String text = new PlainTextVisitor().extract(document);

        text = MULTIPLE_SPACES.matcher(text)
                .replaceAll(" ")
                .trim();

        return truncate(text, maxLength);
    }

    private String truncate(String text, int maxLength) {
        if (maxLength == 0) {
            return "";
        }

        int length = text.codePointCount(0, text.length());

        if (length <= maxLength) {
            return text;
        }

        if (maxLength == 1) {
            return "…";
        }

        int endIndex = text.offsetByCodePoints(0, maxLength - 1);

        return text.substring(0, endIndex).stripTrailing() + "…";
    }

    private static final class PlainTextVisitor extends AbstractVisitor {

        private final StringBuilder result = new StringBuilder();

        public String extract(Node node) {
            node.accept(this);
            return result.toString();
        }

        @Override
        public void visit(Text text) {
            append(text.getLiteral());
        }

        @Override
        public void visit(Code code) {
            append(code.getLiteral());
        }

        @Override
        public void visit(FencedCodeBlock codeBlock) {
            appendWithSpace(codeBlock.getLiteral());
        }

        @Override
        public void visit(IndentedCodeBlock codeBlock) {
            appendWithSpace(codeBlock.getLiteral());
        }

        @Override
        public void visit(SoftLineBreak softLineBreak) {
            appendSpace();
        }

        @Override
        public void visit(HardLineBreak hardLineBreak) {
            appendSpace();
        }

        @Override
        public void visit(Paragraph paragraph) {
            visitChildren(paragraph);
            appendSpace();
        }

        @Override
        public void visit(Heading heading) {
            visitChildren(heading);
            appendSpace();
        }

        @Override
        public void visit(BlockQuote blockQuote) {
            visitChildren(blockQuote);
            appendSpace();
        }

        @Override
        public void visit(ListItem listItem) {
            visitChildren(listItem);
            appendSpace();
        }

        @Override
        public void visit(Link link) {
            visitChildren(link);
        }

        @Override
        public void visit(Image image) {
            // image alt text не добавляем
        }

        @Override
        public void visit(HtmlInline htmlInline) {
            // HTML-теги в plain text не добавляем
        }

        @Override
        public void visit(HtmlBlock htmlBlock) {
            // HTML-блоки в plain text не добавляем
        }

        @Override
        public void visit(ThematicBreak thematicBreak) {
            appendSpace();
        }

        private void append(String value) {
            if (value != null && !value.isBlank()) {
                result.append(value);
            }
        }

        private void appendWithSpace(String value) {
            append(value);
            appendSpace();
        }

        private void appendSpace() {
            if (!result.isEmpty()) {
                result.append(' ');
            }
        }
    }
}