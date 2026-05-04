package ru.kpfu.itis.sorokin.sdevpoint.markdown;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.commonmark.node.Node;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.safety.Safelist;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class MarkdownRenderService {
    private final String IMAGE_SRC_PREFIX = "/api/image/";

    private final Parser parser = Parser.builder().build();

    private final HtmlRenderer renderer = HtmlRenderer.builder()
            .escapeHtml(true)
            .sanitizeUrls(true)
            .build();

    private final Safelist safelist = Safelist.relaxed()
            .addAttributes("img", "src", "alt", "title")
            .addProtocols("a", "href", "http", "https", "mailto")
            .addEnforcedAttribute("a", "rel", "nofollow noopener noreferrer")
            .preserveRelativeLinks(true);

    public String renderToSafeHtml(String markdown) {
        if (markdown == null || markdown.isBlank()) {
            return "";
        }

        Node document = parser.parse(markdown);
        String unsafeHtml = renderer.render(document);

        log.info("unsafe: {}", unsafeHtml);

        String safeHtml = Jsoup.clean(unsafeHtml, safelist);

        log.info("safe: {}", safeHtml);

        String removedExternalImage = removeExternalImages(safeHtml);

        log.info("removedExternalImage: {}", removedExternalImage);

        return removedExternalImage;
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
}
