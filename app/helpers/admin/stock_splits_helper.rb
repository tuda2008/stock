module Admin::StockSplitsHelper
	# Returns the textual representation of a single journal detail
  def show_detail(detail, stock_model, no_html=false)
    multiple = false
    show_diff = false
    no_details = false


      field = detail.prop_key.to_s
      label = I18n.t(("activerecord.attributes." + stock_model + "." + field).to_sym)

      case detail.prop_key
      when 'published_at'
        value = detail.value.to_s unless detail.value.blank?
        old_value = detail.old_value.to_s  unless detail.old_value.blank?

      when 'user_id'
        unless detail.value.blank?
          user = User.where(id: detail.value).first 
          value = user.name if user
        end
        unless detail.old_value.blank?
          old_user = User.where(id: detail.old_value).first 
          value = old_user.name if old_user
        end

      when 'company_id'
        unless detail.value.blank?
          company = StockCompany.where(id: detail.value).first 
          value = company.name if company
        end
        unless detail.old_value.blank?
          old_company = StockCompany.where(id: detail.old_value).first 
          value = old_company.name if old_company
        end

      when 'stock_transfer', 'stock_send', 'stock_sum', 'stock_num', 'level', 'info'
        value = "#{detail.value}" unless detail.value.blank?
        old_value = "#{detail.old_value}" unless detail.old_value.blank?

      when 'stock_bonus', 'stock_price'
        value = "#{detail.value} ¥" unless detail.value.blank?
        old_value = "#{detail.old_value} ¥" unless detail.old_value.blank?

      when 'enabled', 'visible'
        value = I18n.t(detail.value == "0" ? :general_text_No : :general_text_Yes) unless detail.value.blank?
        old_value = I18n.t(detail.old_value == "0" ? :general_text_No : :general_text_Yes) unless detail.old_value.blank?
      
      end
    

    label ||= detail.prop_key
    value ||= detail.value
    old_value ||= detail.old_value

    unless no_html
      value = h(value) if value
      if detail.old_value 
        if detail.value.blank?
          old_value = h(old_value)
        else
          old_value = h(old_value) if detail.old_value
        end
      end
    end

    if no_details
      s = I18n.t(:text_journal_changed_no_detail, :label => label).html_safe
    elsif detail.value.present?
        if detail.old_value.present?
           I18n.t(:text_journal_changed, :label => label, :old => old_value, :new => value).html_safe
        elsif multiple
           I18n.t(:text_journal_added, :label => label, :value => value).html_safe
        else
           I18n.t(:text_journal_set_to, :label => label, :value => value).html_safe
        end
    else
       I18n.t(:text_journal_deleted, :label => label, :old => old_value).html_safe
    end
  end
end
