package ru.kpfu.itis.sorokin.sdevpoint.markdown;

import com.vladsch.flexmark.ast.BlockQuote;
import com.vladsch.flexmark.ast.Code;
import com.vladsch.flexmark.ast.FencedCodeBlock;
import com.vladsch.flexmark.ast.HardLineBreak;
import com.vladsch.flexmark.ast.Heading;
import com.vladsch.flexmark.ast.HtmlBlock;
import com.vladsch.flexmark.ast.HtmlInline;
import com.vladsch.flexmark.ast.Image;
import com.vladsch.flexmark.ast.IndentedCodeBlock;
import com.vladsch.flexmark.ast.Link;
import com.vladsch.flexmark.ast.ListItem;
import com.vladsch.flexmark.ast.Paragraph;
import com.vladsch.flexmark.ast.SoftLineBreak;
import com.vladsch.flexmark.ast.Text;
import com.vladsch.flexmark.ast.ThematicBreak;
import com.vladsch.flexmark.ext.autolink.AutolinkExtension;
import com.vladsch.flexmark.ext.gfm.strikethrough.StrikethroughExtension;
import com.vladsch.flexmark.ext.gfm.tasklist.TaskListExtension;
import com.vladsch.flexmark.ext.tables.TablesExtension;
import com.vladsch.flexmark.parser.Parser;
import com.vladsch.flexmark.util.ast.Node;
import com.vladsch.flexmark.util.data.MutableDataSet;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.regex.Pattern;

@Component
public class MarkdownTextParser {

    private static final Pattern FRONT_MATTER =
            Pattern.compile("(?s)^---\\s*\\R.*?\\R---\\s*\\R?");

    private static final Pattern MULTIPLE_SPACES =
            Pattern.compile("\\s+");

    private static final Pattern MARK_SYNTAX =
            Pattern.compile("==([^=\\n]+)==");

    private final MutableDataSet options = new MutableDataSet()
            .set(Parser.EXTENSIONS, List.of(
                    TablesExtension.create(),
                    StrikethroughExtension.create(),
                    TaskListExtension.create(),
                    AutolinkExtension.create()
            ));

    private final Parser parser = Parser.builder(options).build();

    public String parse(String markdown, int maxLength) {
        if (markdown == null || markdown.isBlank()) {
            return "";
        }

        if (maxLength < 0) {
            throw new IllegalArgumentException("maxLength must be >= 0");
        }

        String withoutFrontMatter = FRONT_MATTER.matcher(markdown)
                .replaceFirst("");

        Node document = parser.parse(withoutFrontMatter);

        String text = new PlainTextVisitor().extract(document);

        text = MARK_SYNTAX.matcher(text)
                .replaceAll("$1");

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

    private static final class PlainTextVisitor {

        private final StringBuilder result = new StringBuilder();

        public String extract(Node node) {
            visit(node);
            return result.toString();
        }

        private void visit(Node node) {
            if (node == null) {
                return;
            }

            if (node instanceof Text text) {
                append(text.getChars().toString());
                return;
            }

            if (node instanceof Code code) {
                append(code.getText().toString());
                return;
            }

            if (node instanceof FencedCodeBlock codeBlock) {
                appendWithSpace(codeBlock.getContentChars().toString());
                return;
            }

            if (node instanceof IndentedCodeBlock codeBlock) {
                appendWithSpace(codeBlock.getContentChars().toString());
                return;
            }

            if (node instanceof SoftLineBreak || node instanceof HardLineBreak) {
                appendSpace();
                return;
            }

            if (node instanceof Image) {
                return;
            }

            if (node instanceof HtmlInline || node instanceof HtmlBlock) {
                return;
            }

            if (node instanceof ThematicBreak) {
                appendSpace();
                return;
            }

            if (node instanceof Link) {
                visitChildren(node);
                return;
            }

            if (node instanceof Paragraph
                    || node instanceof Heading
                    || node instanceof BlockQuote
                    || node instanceof ListItem) {
                visitChildren(node);
                appendSpace();
                return;
            }

            visitChildren(node);
        }

        private void visitChildren(Node parent) {
            Node child = parent.getFirstChild();

            while (child != null) {
                Node next = child.getNext();
                visit(child);
                child = next;
            }
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