module PagesHelper
  # 利用規約のクラス設定
  # 利用規約・条文用のメソッド（追加）
  def terms_article(title, &block)
    content_tag(:div, class: "terms-article mb-6") do
      concat(content_tag(:h2, title, class: "text-xl font-semibold mb-2"))
      concat(content_tag(:div, capture(&block), class: "terms-article-body bg-[#C7E5FF]"))
    end
  end

  def terms_ol
    "list-decimal pl-6"
  end
end
