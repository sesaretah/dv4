$("#state_page-form").replaceWith("<%= escape_javascript(render(:partial => 'state_pages/list', locals: {workflow: @workflow, state_pages: @state_pages})) %>");
