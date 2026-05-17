package ru.kpfu.itis.sorokin.sdevpoint.markdown;

import com.vladsch.flexmark.ext.autolink.AutolinkExtension;
import com.vladsch.flexmark.ext.gfm.strikethrough.StrikethroughExtension;
import com.vladsch.flexmark.ext.gfm.tasklist.TaskListExtension;
import com.vladsch.flexmark.ext.tables.TablesExtension;
import com.vladsch.flexmark.html.HtmlRenderer;
import com.vladsch.flexmark.parser.Parser;
import com.vladsch.flexmark.util.ast.Node;
import com.vladsch.flexmark.util.data.MutableDataSet;
import lombok.extern.slf4j.Slf4j;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.TextNode;
import org.jsoup.parser.Tag;
import org.jsoup.safety.Safelist;
import org.springframework.stereotype.Service;
import ru.kpfu.itis.sorokin.sdevpoint.web.routes.ImageRoutes;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Slf4j
@Service
public class MarkdownRenderService {
    private static final Pattern MARK_PATTERN = Pattern.compile("==([^=\\n]+)==");
    private static final String IMAGE_SRC_PREFIX = ImageRoutes.IMAGE_PREFIX;

    private final MutableDataSet options = new MutableDataSet()
            .set(Parser.EXTENSIONS, List.of(
                    TablesExtension.create(),
                    StrikethroughExtension.create(),
                    TaskListExtension.create(),
                    AutolinkExtension.create()
            ))
            .set(HtmlRenderer.ESCAPE_HTML, true)
            .set(HtmlRenderer.SOFT_BREAK, "<br />");

    private final Parser parser = Parser.builder(options).build();

    private final HtmlRenderer renderer = HtmlRenderer.builder(options).build();

    private final Safelist safelist = Safelist.relaxed()
            .addTags("input", "mark")
            .addAttributes("input", "type", "checked", "disabled", "class")
            .addAttributes("li", "class")
            .addAttributes("ul", "class")
            .addAttributes("ol", "class")
            .addAttributes("code", "class")
            .addAttributes("pre", "class")
            .addAttributes("img", "src", "alt", "title", "width", "height")
            .addAttributes("table", "class")
            .addAttributes("thead", "class")
            .addAttributes("tbody", "class")
            .addAttributes("tr", "class")
            .addAttributes("th", "class", "align")
            .addAttributes("td", "class", "align")
            .addProtocols("a", "href", "http", "https", "mailto")
            .addEnforcedAttribute("a", "rel", "nofollow noopener noreferrer")
            .preserveRelativeLinks(true);

    public String renderToSafeHtml(String markdown) {
        if (markdown == null || markdown.isBlank()) {
            return "";
        }

        Node document = parser.parse(markdown);
        String unsafeHtml = renderer.render(document);

        String safeHtml = Jsoup.clean(unsafeHtml, safelist);

        String htmlWithMarks = applyMarkSyntax(safeHtml);

        return removeExternalImages(htmlWithMarks);
    }

    private String removeExternalImages(String html) {
        Document document = Jsoup.parseBodyFragment(html);

        for (Element img : document.select("img[src]")) {
            String src = img.attr("src");

            if (!src.startsWith(IMAGE_SRC_PREFIX)) {
                img.remove();
            }
        }

        return document.body().html();
    }

    private String applyMarkSyntax(String html) {
        Document document = Jsoup.parseBodyFragment(html);

        replaceMarkSyntax(document.body());

        return document.body().html();
    }

    private void replaceMarkSyntax(Element root) {
        List<TextNode> textNodes = new ArrayList<>(root.textNodes());

        for (TextNode textNode : textNodes) {
            replaceMarkSyntaxInTextNode(textNode);
        }

        for (Element child : root.children()) {
            String tagName = child.normalName();

            if ("code".equals(tagName) || "pre".equals(tagName)) {
                continue;
            }

            replaceMarkSyntax(child);
        }
    }

    private void replaceMarkSyntaxInTextNode(TextNode textNode) {
        String text = textNode.getWholeText();

        Matcher matcher = MARK_PATTERN.matcher(text);

        if (!matcher.find()) {
            return;
        }

        matcher.reset();

        List<org.jsoup.nodes.Node> replacementNodes = new ArrayList<>();

        int lastIndex = 0;

        while (matcher.find()) {
            if (matcher.start() > lastIndex) {
                replacementNodes.add(new TextNode(text.substring(lastIndex, matcher.start())));
            }

            Element mark = new Element(Tag.valueOf("mark"), "");
            mark.text(matcher.group(1));

            replacementNodes.add(mark);

            lastIndex = matcher.end();
        }

        if (lastIndex < text.length()) {
            replacementNodes.add(new TextNode(text.substring(lastIndex)));
        }

        for (org.jsoup.nodes.Node replacementNode : replacementNodes) {
            textNode.before(replacementNode);
        }

        textNode.remove();
    }
}
