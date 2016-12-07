module ServerspecReportsHelper
  def serverspec_reported_at_column(record)
    link_to(_("%s ago") % time_ago_in_words(record.reported_at), serverspec_report_path(record))
  end

  def examples_show
    return unless @serverspec_report.examples.size > 0
    form_tag serverspec_report_path(@serverspec_report), :id => 'level_filter', :method => :get, :class => "form form-horizontal" do
      content_tag(:span, _("Show examples:") + ' ') +
        select(nil, 'level', [[_('All examples'), 'info'],[_('Passed'), 'passed'],[_('Pending'), 'pending'],[_('Failures'), 'failed']],
               {}, {:class=>"col-md-1 form-control", :onchange =>"filter_by_speclevel(this);"})
    end
  end

  def status_tag(level)
    tag = case level
          when 'passed'
            "info"
          when 'failed'
            "danger"
          else
            "default"
          end
    "class='label label-#{tag}'".html_safe
  end

end
