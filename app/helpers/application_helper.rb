module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def button_text(page_title)
    page_title == new ? 'Create My Account' : 'Save Changes'
  end
end
