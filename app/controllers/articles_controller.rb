require 'nokogiri'

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy article_descriptors article_related_dates article_other_details article_contributions article_relations send_to refund_to workflow_transitions article_detail article_logs compare article_states article_comments print change_workflow make_a_copy article_publishable change_access_group
                                       sectioned_form raw_print content_form set_note_template add_access_group remove_access_group raw_single_print
                                       archive unarchive generate_pdf]

  def archive
    @article.archived = true
    @article.save
  end

  def unarchive
    @article.archived = false
    @article.save
  end

  def generate_pdf
    @article.publish_details = params[:publish_details]
    @article.pdf_generated = false
    @access_groupings = AccessGrouping.where(article_id: @article.id)
    @article.publish_uuid = SecureRandom.hex(10)
    PdfsWorker.perform_async(@article.id, @article.publish_uuid, 'raw_print')
    @article.published_on = DateTime.now
    @article.save
  end

  def add_access_group
    return if params[:access_group_id].blank?

    @access_grouping = AccessGrouping.where(article_id: @article.id, access_group_id: params[:access_group_id]).first
    if @access_grouping.blank?
      @access_grouping = AccessGrouping.create(article_id: @article.id, access_group_id: params[:access_group_id],
                                               notify: params[:notify], notify_automation: params[:notify_automation] , user_id: current_user.id)
    elsif @access_grouping.user_id.blank?
      @access_grouping.update(user_id: current_user.id)
    end
    @access_groupings = AccessGrouping.where(article_id: @article.id)
  end

  def remove_access_group
    return if params[:access_grouping_id].blank?

    @access_grouping = AccessGrouping.find_by_id(params[:access_grouping_id])
    @access_grouping.destroy unless @access_grouping.blank?
    @access_groupings = AccessGrouping.where(article_id: @article.id)
  end

  def set_note_template
    Noting.create(article_id: @article.id, note_template_id: params[:note_template_id])
  end

  def content_form; end

  def fixer
    for article in Article.all
      article.abstract = UnicodeFixer.fix(article.abstract)
      article.title = UnicodeFixer.fix(article.title)
      article.content = UnicodeFixer.fix(article.content)
      article.content_wo_tags = UnicodeFixer.fix(article.content_wo_tags)
      article.save
    end
  end

  def upload_indexer
    # article = Article.find(params[:id])
    for article in Article.all
      article.document_contents = ''
      for upload in article.uploads
        text = `java -jar #{Rails.root}/lib/tika-app-1.20.jar -h #{upload.attachment.path}`
        article.document_contents = article.document_contents + ' ' + text unless text.blank?
      end
      article.save
    end
  end

  def csv_to_db
    require 'csv'
    xlsx = Roo::Spreadsheet.open("#{Rails.root}/data.xlsx")

    xlsx.each_row_streaming(offset: 1, max_rows: 1071) do |row|
      article = Article.new
      article.title = row[0].to_s.truncate(200) unless row[0].blank?
      article.abstract = row[3].to_s.truncate(200) unless row[3].blank?
      if !row[4].blank? && !row[5].blank?
        article.description = row[4].to_s.truncate(200) + ' | ' + row[5].to_s.truncate(200)
      end
      article.content = row[6].to_s.truncate(200) unless row[6].blank?

      article.url = row[7].to_s.truncate(200) unless row[7].blank?
      article.slug = SecureRandom.hex(4)
      article.workflow_state_id = 1
      article.save
      areas = row[17].to_s.split('،')
      for area in areas
        a = ArticleArea.where(title: area.squish).first
        a = ArticleArea.create(title: area.squish) if a.blank?
        Areaing.create(article_area_id:  a.id, article_id: article.id) unless a.blank?
      end

      types = row[12].to_s.split('،')
      for type in types
        t = ArticleType.where(title: type.squish).first
        t = ArticleType.create(title: type.squish) if t.blank?
        Typing.create(article_type_id: t.id, article_id: article.id) unless t.blank?
      end

      keyword_1 = Keyword.where(title: row[8].to_s.squish).first
      keyword_1 = Keyword.create(title: row[8]) if !row[8].blank? && keyword_1.blank?
      unless keyword_1.blank?
        Tagging.create(taggable_type: 'Article', taggable_id: article.id, target_type: 'Keyword',
                       target_id: keyword_1.id)
      end

      keyword_2 = Keyword.where(title: row[9].to_s.squish).first
      keyword_2 = Keyword.create(title: row[9]) if !row[8].blank? && keyword_2.blank?
      unless keyword_2.blank?
        Tagging.create(taggable_type: 'Article', taggable_id: article.id, target_type: 'Keyword',
                       target_id: keyword_2.id)
      end

      Speaking.create(language_id: 1, article_id: article.id)
      Formating.create(article_format_id: 1, article_id: article.id)
      Contribution.create(article_id: article.id, profile_id: 492, role_id: 62, duty_id: 70)
      Titling.create(article_id: article.id, title_type_id: 1, content: row[1].to_s.squish) unless row[1].blank?
      Titling.create(article_id: article.id, title_type_id: 3, content: row[2].to_s.squish) unless row[2].blank?
      next if row[10].blank?

      date = row[10].to_s.split('/')
      dating = Dating.new
      jdate = begin
        JalaliDate.to_gregorian(date[0], date[1], date[2])
      rescue StandardError
        nil
      end
      next unless jdate

      dating.article_id = article.id
      dating.article_event_id = ArticleEvent.last.id
      dating.event_date = jdate
      begin
        dating.save
      rescue StandardError
        nil
      end
    end
  end

  def csv_to_db_2
    require 'csv'
    xlsx = Roo::Spreadsheet.open("#{Rails.root}/data#{params[:id]}.xlsx")

    xlsx.each_row_streaming(offset: 1, max_rows: 500, pad_cells: true) do |row|
      article = Article.new
      article.title = row[1].to_s.truncate(200) unless row[1].blank?
      article.abstract = row[3].to_s.truncate(200) unless row[2].blank?
      notes = ' '
      notes += row[3].to_s.truncate(200) + ' | ' unless row[3].blank?

      notes += row[4].to_s.truncate(200) + ' | ' unless row[4].blank?

      notes += row[5].to_s.truncate(200) + ' | ' unless row[5].blank?

      notes += row[6].to_s.truncate(200) + ' | ' unless row[6].blank?

      article.notes = notes
      article.content = row[7].to_s.truncate(200) unless row[7].blank?

      article.url = row[8].to_s.truncate(200) unless row[8].blank?
      article.slug = SecureRandom.hex(4)
      article.workflow_state_id = 1
      article.save

      areas = row[18].to_s.split('،')
      for area in areas
        a = ArticleArea.where(title: area.squish).first
        a = ArticleArea.create(title: area.squish) if a.blank?
        Areaing.create(article_area_id:  a.id, article_id: article.id) unless a.blank?
      end

      types = row[11].to_s.split('،')
      for type in types
        t = ArticleType.where(title: type.squish).first
        t = ArticleType.create(title: type.squish) if t.blank?
        Typing.create(article_type_id: t.id, article_id: article.id) unless t.blank?
      end

      keywords = row[9].to_s.split('؛')
      for keyword in keywords
        k = Keyword.where(title: keyword.squish).first
        k = Keyword.create(title: keyword.squish) if k.blank?
        Tagging.create(taggable_type: 'Article', taggable_id: article.id, target_type: 'Keyword', target_id: k.id)
      end

      Speaking.create(language_id: 1, article_id: article.id)
      Formating.create(article_format_id: 1, article_id: article.id)
      Contribution.create(article_id: article.id, profile_id: 492, role_id: 62, duty_id: 70)
      next if row[10].blank?

      dating = Dating.new
      jdate = begin
        JalaliDate.to_gregorian(row[10].to_s, 1, 1)
      rescue StandardError
        nil
      end
      next unless jdate

      dating.article_id = article.id
      dating.article_event_id = ArticleEvent.last.id
      dating.event_date = jdate
      begin
        dating.save
      rescue StandardError
        nil
      end
    end
  end

  def sectioned_form
    @section = Section.find(params[:section_id])
  end

  def title_search
    @articles = Article.search conditions: { title: UnicodeFixer.fix(params[:q]) }, star: true unless params[:q].blank?
    resp = []
    for r in @articles
      resp << { 'title' => r.title, 'id' => r.id }
    end
    render json: resp.to_json, callback: params['callback']
  end

  def raw_print
    render layout: false
  end

  def raw_single_print
    render layout: false
  end

  def pdf_generate
    PdfWorker.perform_async(params[:id])
  end

  def print
    @word_template = WordTemplate.find(params[:word_template])
    @articles = []
    @articles << Article.find(params[:id])
    @result = article_inspect(@articles)
    # render layout: 'layouts/devise'
    respond_to do |format|
      format.docx do
        if @word_template.document.attached?
          # Download the file to a temporary location
          temp_file = Tempfile.new(["temp_document", ".docx"])
          temp_file.binmode
          temp_file.write(@word_template.document.download)
          temp_file.rewind
      
          # Process with DocxReplace
          doc = DocxReplace::Doc.new(temp_file.path, "#{Rails.root}/tmp")

          # Replace some variables. $var$ convention is used here, but not required.
          doc.replace('1000101', @result[0][:title])
          doc.replace('۱۰۰۰۱۰۱', @result[0][:title])
          
          doc.replace('1000102', @result[0][:abstract])
          doc.replace('۱۰۰۰۱۰۲', @result[0][:abstract])

          doc.replace('1000103', @result[0][:url])
          doc.replace('۱۰۰۰۱۰۳', @result[0][:url])

          doc.replace('1000104', @result[0][:datings])
          doc.replace('۱۰۰۰۱۰۴', @result[0][:datings])

          doc.replace('1000105', @result[0][:typings])
          doc.replace('۱۰۰۰۱۰۵', @result[0][:typings])

          doc.replace('1000106', @result[0][:speakings])
          doc.replace('۱۰۰۰۱۰۶', @result[0][:speakings])

          doc.replace('1000107', @result[0][:formatings])
          doc.replace('۱۰۰۰۱۰۷', @result[0][:formatings])

          doc.replace('1000108', @result[0][:contributors].map(&:inspect).join(', '))
          doc.replace('۱۰۰۰۱۰۸', @result[0][:contributors].map(&:inspect).join(', '))

          doc.replace('1000109', @result[0][:kinships].map(&:inspect).join(', '))
          doc.replace('۱۰۰۰۱۰۹', @result[0][:kinships].map(&:inspect).join(', '))

          @articles.first.kinships.each_with_index do |kinship, index|
            kin = kinship.kin
            doc.replace("200010#{index}", kin.title)
            doc.replace("۲۰۰۰۱۰#{index}", kin.title)

            doc.replace("300010#{index}", kin.abstract)
            doc.replace("۳۰۰۰۱۰#{index}", kin.abstract)
            d = Nokogiri::HTML.fragment(kin.content)
            doc.replace("400010#{index}", d.text.strip.to_s)
            doc.replace("۴۰۰۰۱۰#{index}", d.text.strip.to_s)
          end

          doc.replace('1000111', @result[0][:originatings].map(&:inspect).join(', '))
          doc.replace('۱۰۰۰۱۱۱', @result[0][:originatings].map(&:inspect).join(', '))

          doc.replace('1000112', @result[0][:areaings].map(&:inspect).join(', '))
          doc.replace('۱۰۰۰۱۱۲', @result[0][:areaings].map(&:inspect).join(', '))

          doc.replace('1000113', @result[0][:content])
          doc.replace('۱۰۰۰۱۱۳', @result[0][:content])

          doc.commit(temp_file.path)

          # Send the file for download
          send_file temp_file.path, filename: "document.docx",
                                    type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                                    disposition: "attachment"
        else
          render plain: "No document attached", status: :not_found
        end
      end
    end
  end

  def search
    @articles = Article.search UnicodeFixer.fix(params[:q]), star: true unless params[:q].blank?
    if params[:domain] == 'workflow'
      article = Article.find(params[:article_id])
      @workflow_state_ids = article.workflow_state.workflow.workflow_states.pluck(:id)
      @articles = Article.search UnicodeFixer.fix(params[:q]), star: true,
                                                               with: { workflow_state_id: @workflow_state_ids }
    end
    resp = []
    for k in @articles
      resp << { 'title' => k.title, 'id' => k.id }
    end
    render json: resp.to_json, callback: params['callback']
  end

  def change_access_group
    @article.access_for_others = params[:access_for_others]
    @article.save
  end

  def article_publishable
    @access_groupings = AccessGrouping.where(article_id: @article.id)
  end

  def article_descriptors; end

  def article_related_dates; end

  def article_other_details; end

  def article_contributions; end

  def article_relations; end

  def workflow_transitions
    return if grant_access('view_workflow_transactions', current_user)

    head(403)
  end

  def article_detail; end

  def article_logs
    return if grant_access('view_article_logs', current_user)

    head(403)
  end

  def article_comments; end

  def article_states
    extract_nxt_prv(@article)
    @workflow_states = WorkflowState.where(role_id: current_user.current_role_id,
                                           start_point: 2).group_by(&:workflow_id).keys
    @workflows = Workflow.where('id in (?)', @workflow_states)
  end

  def change_workflow
    #    if @article.workflow_state.workflow.id ==
    @article.workflow_state_id = params[:workflow_state_id]
    @article.save
    extract_nxt_prv(@article)
  end

  def make_a_copy
    @workflow = Workflow.find(params[:workflow_id])
    if @article.workflow_state.workflow.id != @workflow.id
      @flag = true
      @new_article = Article.create(title: @article.title, abstract: @article.abstract, content: @article.content,
                                    url: @article.url, document_contents: @article.document_contents, content_wo_tags: @article.content_wo_tags, workflow_state_id: @workflow.start_state.id, slug: SecureRandom.hex(4))
      @taggings = Tagging.where(taggable_type: 'Article', taggable_id: @article.id, target_type: 'Keyword')
      for t in @taggings
        Tagging.where(taggable_type: 'Article', taggable_id: @new_article.id, target_id: t.target_id,
                      target_type: 'Keyword')
      end
      @article_relation_type = ArticleRelationType.find(params[:article_relation_type_id])
      Kinship.create(kin_id: @article.id, article_id: @new_article.id, user_id: current_user.id,
                     article_relation_type_id: @article_relation_type.id)
      @uploads = Upload.where(uploadable_type: 'Article', uploadable_id: @article.id)
      for upload in @uploads
        Upload.create(uploadable_type: 'Article', uploadable_id: @new_article.id,
                      attachment_file_name: upload.attachment_file_name, attachment_content_type: upload.attachment_content_type, attachment_file_size: upload.attachment_file_size, attachment_type: upload.attachment_type, title: upload.title, detail: upload.detail)
      end
    else
      @flag = false
    end
  end

  def compare
    @result = {
      sah: ArticleHistory.where(revision_number: params[:source]).first,
      tah: ArticleHistory.where(revision_number: params[:target]).first,
      th: history(model: 'Keyword', params: params, alias: 'Tagging', model_key: 'target_id'),
      dh: history(model: 'Dating', params: params),
      tyh: history(model: 'Typing', params: params),
      fh: history(model: 'Formating', params: params),
      # ch: history(model: 'Contribution', params: params),
      kh: history(model: 'Kinship', params: params),
      oh: history(model: 'Originating', params: params),
      ah: history(model: 'Areaing', params: params),
      sh: history(model: 'Speaking', params: params),
      uh: history(model: 'Upload', params: params)
    }
  end
  

  def group_send_to
    selected_articles = params[:selected_articles].split(',').compact.reject(&:empty?)
    Rails.logger.info selected_articles
    for article_id in selected_articles
      article = Article.find_by_id(article_id)
      this_workflow_state = article.workflow_state
      next_workflow_state = WorkflowState.find(params[:workflow_state])
      this_role = this_workflow_state.role
      next_role = next_workflow_state.role
      revision_number = SecureRandom.hex(4)
      if article.workflow_state.workflow.is_next_node(article.workflow_state.node_id, next_workflow_state.node_id) && User.user_has_role(current_user, article.workflow_state.role_id) # @article.workflow_state.role_id == current_user.current_role_id
        workflow_transition = WorkflowTransition.create(workflow_id: article.workflow_state.workflow.id,
                                                         from_state_id: article.workflow_state.id, to_state_id: next_workflow_state.id, article_id: article.id, message: params[:message], user_id: current_user.id, role_id: current_user.current_role_id, transition_type: 1, revision_number: revision_number)
        populate_dependencies(article, workflow_transition, revision_number)
        article.workflow_state_id = params[:workflow_state]
        article.save
      end
    end
    redirect_to '/home'
  end

  def send_to
    @this_workflow_state = @article.workflow_state
    @next_workflow_state = WorkflowState.find(params[:workflow_state])
    @this_role = @this_workflow_state.role
    @next_role = @next_workflow_state.role
    @revision_number = SecureRandom.hex(4)
    if @article.workflow_state.workflow.is_next_node(@article.workflow_state.node_id, @next_workflow_state.node_id) && User.user_has_role(current_user, @article.workflow_state.role_id) # @article.workflow_state.role_id == current_user.current_role_id
      @workflow_transition = WorkflowTransition.create(workflow_id: @article.workflow_state.workflow.id,
                                                       from_state_id: @article.workflow_state.id, to_state_id: @next_workflow_state.id, article_id: @article.id, message: params[:message], user_id: current_user.id, role_id: current_user.current_role_id, transition_type: 1, revision_number: @revision_number)
      populate_dependencies(@article, @workflow_transition, @revision_number)
      @article.workflow_state_id = params[:workflow_state]
      @article.save
    end
    extract_nxt_prv(@article)
    unless @this_role.blank?
      for user in @this_role.users
        if !user.blank? && !@workflow_transition.blank?
          generate_notfication user_id: user.id, notifiable_type: 'WorkflowTransition',
                               notifiable_id: @workflow_transition.id, notification_type: 'article_sent', emmiter_id: current_user.id
        end
      end
    end
    return if @next_role.blank?

    for user in @next_role.users
      if !user.blank? && !@workflow_transition.blank?
        generate_notfication user_id: user.id, notifiable_type: 'WorkflowTransition',
                             notifiable_id: @workflow_transition.id, notification_type: 'article_received', emmiter_id: current_user.id
      end
    end

    # send_mail user_id: @role.users.pluck(:id).join(','), article_ids: @article.id, mail_type: 'article_sent'
  end

  def refund_to
    @this_workflow_state = @article.workflow_state
    @previous_workflow_state = WorkflowState.find(params[:workflow_state])
    @this_role = @this_workflow_state.role
    @prv_role = @previous_workflow_state.role
    @revision_number = SecureRandom.hex(4)
    if @article.workflow_state.workflow.is_previous_node(@article.workflow_state.node_id, @previous_workflow_state.node_id) && User.user_has_role(current_user, @article.workflow_state.role_id) # @article.workflow_state.role_id == current_user.current_role_id
      @workflow_transition = WorkflowTransition.create(workflow_id: @article.workflow_state.workflow.id,
                                                       from_state_id: @article.workflow_state.id, to_state_id: @previous_workflow_state.id, article_id: @article.id, message: params[:message], user_id: current_user.id, role_id: current_user.current_role_id, transition_type: 2, revision_number: @revision_number)
      populate_dependencies(@article, @workflow_transition, @revision_number)
      @article.workflow_state_id = params[:workflow_state]
      @article.save
    end
    extract_nxt_prv(@article)
    unless @prv_role.blank?
      for user in @prv_role.users
        generate_notfication user_id: user.id, notifiable_type: 'WorkflowTransition',
                             notifiable_id: @workflow_transition.id, notification_type: 'article_refunded_received', emmiter_id: current_user.id
      end
    end
    return if @this_role.blank?

    for user in @this_role.users
      generate_notfication user_id: user.id, notifiable_type: 'WorkflowTransition',
                           notifiable_id: @workflow_transition.id, notification_type: 'article_refunded', emmiter_id: current_user.id
    end
  end

  # GET /articles
  # GET /articles.json
  def index
    
    case params[:scope]
    when 'my'
      role_ids = current_user.roles.pluck(:id)
      @workflow_ids = WorkflowState.where("role_id in (?)", role_ids).pluck(:workflow_id)
      @workflow_state_ids = Workflow.where(id: @workflow_ids).map(&:workflow_states).flatten.map(&:id)
      @articles = Article.where(user_id: current_user.id).where('workflow_state_id IN (?)', @workflow_state_ids.flatten.uniq).paginate(
        page: params[:page], per_page: 10
      )
    when 'all'
      if !grant_access('view_unrelated_articles', current_user)
        role_ids = current_user.roles.pluck(:id)
        @workflow_state_ids = WorkflowState.where("role_id in (?)", role_ids).pluck(:id)
        @articles = Article.where('workflow_state_id IN (?)', @workflow_state_ids.flatten.uniq).paginate(
          page: params[:page], per_page: 5
        )
      else
        @articles = Article.paginate(page: params[:page], per_page: 5)
      end
    when nil, 'related'
      role_ids = current_user.roles.pluck(:id)
      ids = WorkflowState.joins(:workflow).where("role_id in (?) or workflows.user_id = ? or workflows.moderator_id = ? or workflows.admin_id = ?", role_ids, current_user.id, current_user.id, current_user.id).pluck(:id)
      @articles = Article.where('workflow_state_id IN (?)', ids.flatten.uniq).paginate(
        page: params[:page], per_page: 10
      )
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    extract_nxt_prv(@article)
  end

  # GET /articles/new
  def new
    @article = Article.new
    @selected_ws = WorkflowState.where(id: params[:workflow_state_id]).first
    # @workflow_states = WorkflowState.where(role_id: current_user.current_role_id, start_point: 2).group_by(&:workflow_id).keys
    @workflows = Workflow.user_available_start_workflows(current_user)
    return unless @workflows.blank?

    redirect_to '/articles', notice: :you_have_not_the_right_permission_to_create_article
  end

  # GET /articles/1/edit
  def edit
    if !article_owner(@article, current_user)
      head(403)
    else
      @workflow_states = WorkflowState.where(role_id: current_user.current_role_id).group_by(&:workflow_id).keys
      @workflows = Workflow.where('id in (?)', @workflow_states) unless @workflow_states.blank?
    end
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    @article.slug = SecureRandom.hex(4) if @article.slug.blank?
    # if !params[:workflow].blank?
    #  @workflow_state = WorkflowState.where(workflow_id: params[:workflow].to_i, start_point: 2, role_id: current_user.current_role_id).first
    #  if !@workflow_state.blank?
    #    @article.workflow_state_id = @workflow_state.id
    #  end
    # end
    @article.workflow_state_id = params[:workflow_state_id] unless params[:workflow_state_id].blank?
    @article.user_id = current_user.id
    @article.save!
    extract_other_titles
    respond_to do |format|
      if params[:form_type] == 'custom'
        format.html do
          redirect_to '/articles/sectioned_form/' + @article.id.to_s + '?section_id=' + @article.start_section,
                      notice: :article_is_created
        end
      else
        format.html { redirect_to '/articles/article_descriptors/' + @article.id.to_s, notice: :article_is_created }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    @article.slug = SecureRandom.hex(4) if @article.slug.blank?
    #  @article.document_contents = ''
    #  for upload in @article.uploads
    #    @text =  %x[java -jar #{Rails.root}/lib/tika-app-1.20.jar -h #{upload.attachment.path}]
    #    if !@text.blank?
    #      @article.document_contents =  @article.document_contents + ' ' + @text
    #    end
    #  end
    if !params[:article].blank? && !params[:article][:content].blank?
      @article.content_wo_tags = ActionView::Base.full_sanitizer.sanitize(params[:article][:content])
    end
    @article.workflow_state_id = params[:workflow_state_id] unless params[:workflow_state_id].blank?
    respond_to do |format|
      if @article.update(article_params)
        extract_keywords(@article, params[:keyword]) if !params[:keyword].blank? || params[:keyword] == ''
        extract_other_titles if !params[:other_title].blank? && params[:other_title] == 'true'
        if params[:caller] == 'descriptors'
          format.html { redirect_to :back }
          #format.html { redirect_to '/articles/article_related_dates/' + @article.id.to_s, notice: :article_is_updated }
        else
          format.html { redirect_to '/articles/article_descriptors/' + @article.id.to_s, notice: :article_is_updated }
        end
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.js
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    if !article_owner(@article, current_user, 'destroy')
      head(403)
    else
      @article.destroy
      redirect_to :back
    end
  end

  def extract_other_titles
    params.each do |param|
      next unless param[0].include?('_title_type')

      for titling in @article.titlings
        titling.destroy
      end
    end
    params.each do |param|
      next unless param[0].include?('_title_type')

      @h = param[0].split('_')[0]
      unless params["#{@h}_other_title"].blank?
        @title_type = TitleType.find_by_id(param[1].to_i)
        Titling.create(title_type_id: @title_type.id, article_id: @article.id, content: params["#{@h}_other_title"])
      end
    end
  end

  def history(**args)
    if args[:alias].blank?
      in_model_compare("#{args[:model]}History", args[:model], args[:params][:source], args[:params][:target],
                       "#{args[:model].downcase}_id")
    else
      in_model_compare("#{args[:alias]}History", args[:model], args[:params][:source], args[:params][:target],
                       args[:model_key])
    end
  end

  def in_model_compare(history_model, model, source, target, index)
    @source = []
    for t in history_model.classify.constantize.where(revision_number: source)
      @source << t[index]
    end
    @target = []
    for t in  history_model.classify.constantize.where(revision_number: target)
      @target << t[index]
    end
    @remainder = model.classify.constantize.where('id IN (?)', @source & @target)
    @new = model.classify.constantize.where('id IN (?)', @target - @source)
    @deleted = model.classify.constantize.where('id IN (?)', @source - @target)
    { remainder: @remainder, new: @new, deleted: @deleted }
  end

  def populate_dependencies(article, workflow_transition, revision_number)
    ArticleHistory.create(article_id: article.id, title: article.title, abstract: article.abstract,
                          content: article.content, url: article.url, user_id: current_user.id, revision_number: revision_number, workflow_transition_id: workflow_transition.id)
    for tagging in Tagging.where(taggable_type: 'Article', taggable_id: article.id)
      TaggingHistory.create(tagging_id: tagging.id, taggable_type: 'Article', taggable_id: article.id,
                            target_id: tagging.target_id, target_type: tagging.target_type, article_id: article.id, user_id: current_user.id, revision_number: revision_number, workflow_transition_id: workflow_transition.id)
    end
    for dating in article.datings
      DatingHistory.create(dating_id: dating.id, article_event_id: dating.article_event_id,
                           event_date: dating.event_date, article_id: article.id, user_id: current_user.id, revision_number: revision_number, workflow_transition_id: workflow_transition.id)
    end
    for typing in article.typings
      TypingHistory.create(typing_id: typing.id, article_type_id: typing.article_type_id, article_id: article.id,
                           user_id: current_user.id, revision_number: revision_number, workflow_transition_id: workflow_transition.id)
    end
    for formating in article.formatings
      FormatingHistory.create(formating_id: formating.id, article_format_id: formating.article_format_id,
                              article_id: article.id, user_id: current_user.id, revision_number: revision_number, workflow_transition_id: workflow_transition.id)
    end
    for contribution in article.contributions
      ContributionHistory.create(contribution_id: contribution.id, role_id: contribution.role_id,
                                 duty_id: contribution.duty_id, profile_id: contribution.profile_id, article_id: article.id, user_id: current_user.id, revision_number: revision_number, workflow_transition_id: workflow_transition.id)
    end
    for kinship in article.kinships
      KinshipHistory.create(kinship_id: kinship.id, kin_id: kinship.kin_id, article_id: kinship.article_id,
                            article_relation_type_id: kinship.article_relation_type_id, user_id: current_user.id, revision_number: revision_number, workflow_transition_id: workflow_transition.id)
    end
    for originating in article.originatings
      OriginatingHistory.create(originating_id: originating.id, article_id: originating.article_id,
                                article_source_id: originating.article_source_id, user_id: current_user.id, revision_number: revision_number, workflow_transition_id: workflow_transition.id)
    end
    for areaing in article.areaings
      AreaingHistory.create(areaing_id: areaing.id, article_id: areaing.article_id,
                            article_area_id: areaing.article_area_id, user_id: current_user.id, revision_number: revision_number, workflow_transition_id: workflow_transition.id)
    end
    for speaking in article.speakings
      SpeakingHistory.create(speaking_id: speaking.id, article_id: speaking.article_id,
                             language_id: speaking.language_id, user_id: current_user.id, revision_number: revision_number, workflow_transition_id: workflow_transition.id)
    end
    for upload in Upload.where(uploadable_type: 'Article', uploadable_id: article.id,
                               attachment_type: 'article_attachment')
      UploadHistory.create(upload_id: upload.id, uploadable_type: upload.uploadable_type,
                           uploadable_id: upload.uploadable_id, token: upload.token, attachment_file_name: upload.attachment_file_name, attachment_content_type: upload.attachment_content_type, attachment_file_size: upload.attachment_file_size, attachment_updated_at: upload.attachment_updated_at, attachment_type: upload.attachment_type, user_id: current_user.id, revision_number: revision_number, workflow_transition_id: workflow_transition.id)
    end
  end

  def extract_keywords(article, keywords)
    @taggings = Tagging.where(taggable_type: 'Article', taggable_id: article.id, target_type: 'Keyword')
    for t in @taggings
      t.destroy
    end
    @ar = keywords.split(',')
    for a in @ar.uniq
      next if a.empty?

      @keyword = Keyword.find_by_id(a.to_i)
      next if @keyword.blank?

      @taggings = Tagging.where(taggable_type: 'Article', taggable_id: article.id, target_type: 'Keyword')
      if @tagging.blank?
        Tagging.create(taggable_type: 'Article', taggable_id: article.id, target_type: 'Keyword',
                       target_id: @keyword.id)
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:article).permit(:title, :abstract, :content, :url, :slug, :workflow_state_id, :retrieval_number,
                                    :dimensions, :notes, :description, :position)
  end
end
