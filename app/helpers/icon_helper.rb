module IconHelper
  def eye_icon
    <<~SVG.html_safe
      <svg xmlns="http://www.w3.org/2000/svg"
           class="h-5 w-5 text-pink-500"
           fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7
                 -1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
      </svg>
    SVG
  end

  def eye_off_icon
    <<~SVG.html_safe
      <svg xmlns="http://www.w3.org/2000/svg"
           class="h-5 w-5 text-pink-500"
           fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.542-7
                 .41-1.3 1.108-2.471 2.01-3.44M6.223 6.223A9.957 9.957 0 0112 5
                 c4.478 0 8.268 2.943 9.542 7-.244.78-.61 1.51-1.08 2.17M3 3l18 18" />
      </svg>
    SVG
  end

  def eye_toggle_icons
    content_tag(:span, eye_icon,     class: "eye-on") +
    content_tag(:span, eye_off_icon, class: "eye-off hidden")
  end
end