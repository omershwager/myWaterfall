module ApplicationHelper

	def bootstrap_paperclip_picture(form, paperclip_object)
		if form.object.send("#{paperclip_object}?")
			content_tag(:div, class: 'control-group') do
				content_tag(:label, "Current #{paperclip_object.to_s.titleize}", class: 'control-label') +
				content_tag(:div, class: 'controls') do
					image_tag form.object.send(paperclip_object).send(:url, :small)
				end
			end
		end
	end

	def page_header(&block)
		content_tag(:div, capture(&block), class: 'page-header')
	end

	def flash_class(type)
		case type
		when :alert
			"alert-error"
		when :notice
			"alert-success"
		else
			""
		end
	end
end
