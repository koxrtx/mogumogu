module ApplicationHelper
  # 各ページの最初の設定
  def page_classes
    "min-h-screen bg-sky-200 flex flex-col items-center justify-start"
  end
  # タイトル
  def page_title
    "text-3xl font-bold text-gray-700 text-center mt-8 mb-8"
  end

  def input_classes
    "w-full h-12 px-3 py-2 border border-blue-400 rounded bg-sky-50 focus:outline-none focus:ring focus:border-blue-300 mb-4"
  end

  def button_classes
    "w-full bg-sky-500 text-white py-2 rounded hover:bg-sky-600 transition"
  end
end
