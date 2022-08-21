module ApplicationHelper
	def page_title
		content_for(:title).presence || [content_for(:page_title).presence, t(".site_title")].compact.join(" - ")
	end
end
