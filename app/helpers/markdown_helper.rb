require 'rouge/plugins/redcarpet'

class CustomMarkdownRenderer < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end

module MarkdownHelper
  def markdown(md_code)
    options = {
    no_images:     true,
    no_styles:     true,
    with_toc_data: true,
    hard_wrap:     true
    }
    extensions = {
    no_intra_emphasis:   true,
    tables:              true,
    fenced_code_blocks:  true,
    autolink:            true,
    lax_spacing:         true,
    space_after_headers: true
    }
    unless @markdown
        renderer = CustomMarkdownRenderer.new(options)
        @markdown = Redcarpet::Markdown.new(renderer, extensions)
    end
    @markdown.render(md_code).html_safe
  end

  def toc(md_code)
    toc_option = {
      nesting_level: 1
    }

    toc_renderer = Redcarpet::Render::HTML_TOC.new
    toc = Redcarpet::Markdown.new(toc_renderer, toc_option)
    toc.render(md_code).html_safe
  end
end