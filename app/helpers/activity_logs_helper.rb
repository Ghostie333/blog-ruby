module ActivityLogsHelper
  def render_activity_details(details)
    return nil if details.blank?

    # Jeśli to String (np. JSON), spróbujmy go sparsować
    if details.is_a?(String)
      begin
        details = JSON.parse(details)
      rescue JSON::ParserError
        # Jeśli to zwykły string, czyścimy go z tagów HTML
        cleaned_string = strip_tags(details).strip
        return content_tag(:span, cleaned_string, class: "text-gray-600")
      end
    end

    unless details.is_a?(Hash) || details.is_a?(Array)
      cleaned_string = strip_tags(details.to_s).strip
      return content_tag(:span, cleaned_string, class: "text-gray-600")
    end

    html = ""

    if details.is_a?(Hash)
      details.each do |key, value|
        next if value.blank? || value == [ "" ] || key == "commit"

        html += content_tag(:div, class: "mb-1 text-xs") do
          k = content_tag(:strong, "#{key.humanize}: ", class: "font-semibold text-gray-700")

          v = if value.is_a?(Hash) || value.is_a?(Array)
                content_tag(:div, render_activity_details(value), class: "pl-4 border-l-2 border-gray-400 mt-1")
          else
                # Tutaj też czyścimy stringi z tagów HTML
                cleaned_val = strip_tags(value.to_s).strip
                content_tag(:span, cleaned_val, class: "text-gray-600")
          end
          k + v
        end
      end
    elsif details.is_a?(Array)
      cleaned_array = details.reject(&:blank?)
      return nil if cleaned_array.empty?

      html += content_tag(:ul, class: "list-disc pl-4 text-gray-600") do
        cleaned_array.map do |el|
          if el.is_a?(Hash) || el.is_a?(Array)
            content_tag(:li, render_activity_details(el))
          else
            cleaned_el = strip_tags(el.to_s).strip
            content_tag(:li, cleaned_el)
          end
        end.join.html_safe
      end
    end

    html.html_safe
  end
end
