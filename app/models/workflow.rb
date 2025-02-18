class Workflow < ActiveRecord::Base
  has_many :workflow_states

  has_many :workflow_states, dependent: :destroy
  has_many :articles, :through => :workflow_states

  belongs_to :user
  has_many :word_templates
  has_many :sections
  has_many :workflow_role_accesses

  after_save :update_defult_pages 


  def update_defult_pages
    workflow_states.each do |workflow_state|
      if !workflow_state.default_state_page.blank?
        StatePage.where(workflow_state_id: workflow_state.id).destroy_all
        result = []
        case workflow_state.default_state_page
        when 0
          result = [:item_title, :item_abstract, :item_content, :item_upload]
        when 1 
          result = [:item_title, :item_titlings, :item_abstract, :item_content, :item_upload, :item_contributions, :item_areaings]
        when 2 
          result = [:item_title, :item_abstract, :item_content, :item_upload]
        when 3
          result= [:item_title, :item_titlings, :item_abstract, :item_url, :item_keywords, :item_datings, :item_typings, :item_speakings, :item_formatings, :item_contributions, :item_kinships, :item_originatings, :item_content, :item_upload, :item_publications, :item_areaings]
        when 4
          result=  [:item_title, :item_titlings, :item_abstract, :item_keywords, :item_datings, :item_typings, :item_speakings, :item_formatings, :item_contributions, :item_kinships, :item_originatings, :item_content, :item_upload, :item_publications, :item_areaings]
        end
        hash = result.reduce({workflow_state_id: workflow_state.id}) { |memo, item| memo.merge({ item => true})}
        StatePage.create(hash)
      end
    end
  end

  def next_nodes(current_node_id)
    @nodes = JSON.parse self.nodes rescue []
    @edges = JSON.parse self.edges rescue []
    @nexts = []
    for edge in @edges
      if edge["source"]["id"] == current_node_id
        @nexts << edge["target"]["id"]
      end
    end
    return WorkflowState.where(workflow_id: self.id, node_id: @nexts)
  end

  def previous_nodes(current_node_id)
    @nodes = JSON.parse self.nodes rescue []
    @edges = JSON.parse self.edges rescue []
    @previouses = []
    for edge in @edges
      if edge["target"]["id"] == current_node_id
        @previouses << edge["source"]["id"]
      end
    end
    return WorkflowState.where(workflow_id: self.id, node_id: @previouses)
  end

  def is_next_node(current_node_id, next_node_id)
    @nodes = JSON.parse self.nodes rescue []
    @edges = JSON.parse self.edges rescue []
    @nexts = []
    for edge in @edges
      if edge["source"]["id"] == current_node_id
        @nexts << edge["target"]["id"]
      end
    end
    if @nexts.include?(next_node_id)
      return true
    else
      return false
    end
  end

  def is_previous_node(current_node_id, previous_node_id)
    @nodes = JSON.parse self.nodes rescue []
    @edges = JSON.parse self.edges rescue []
    @nexts = []
    for edge in @edges
      if edge["target"]["id"] == current_node_id
        @nexts << edge["source"]["id"]
      end
    end
    if @nexts.include?(previous_node_id)
      return true
    else
      return false
    end
  end

  def prepare_edges
    @nodes = JSON.parse self.nodes rescue []
    @edges = JSON.parse self.edges rescue []
    @result = []
    for edge in @edges
      @source = find_node_index(@nodes, edge["source"]["id"])
      @target = find_node_index(@nodes, edge["target"]["id"])
      @result << { "source" => "nodes[#{@source}]", "target" => "nodes[#{@target}]" }
    end
    return @result
  end

  def end_states
    @result = []
    for workflow_state in self.workflow_states
      if workflow_state.end_point == 2
        @result << workflow_state.id
      end
    end
    return @result
  end

  def start_state
    @result = []
    for workflow_state in self.workflow_states
      if workflow_state.start_point == 2
        @result << workflow_state
      end
    end
    return @result.first
  end

  def self.user_available_start_workflows(user)
    role_ids = user.roles.pluck(:id)
    workflow_ids = WorkflowState.where("role_id in (?) and start_point = 2", role_ids).pluck(:workflow_id).uniq
    workflows = Workflow.where("id in (?)", workflow_ids)
    return workflows
  end

  def self.user_available_workflows(user)
    role_ids = user.roles.pluck(:id)
    workflow_ids = WorkflowState.where("role_id in (?)", role_ids).pluck(:workflow_id).uniq
    workflows = Workflow.where("id in (?)", workflow_ids)
    return workflows
  end

  def start_workflow_states
    @result = []
    for workflow_state in self.workflow_states
      if workflow_state.start_point == 2
        @result << workflow_state
      end
    end
    return @result
  end

  def user_start_workflow_states(user)
    role_ids = user.roles.pluck(:id)
    workflow_state_ids = WorkflowState.where("role_id in (?)", role_ids).pluck(:id)
    @result = []
    for workflow_state in self.workflow_states.order(:title)
      if workflow_state.start_point == 2
        if workflow_state_ids.include? workflow_state.id
          @result << workflow_state
        end
      end
    end
    return @result
  end

  def not_end_states
    @result = []
    for workflow_state in self.workflow_states
      if workflow_state.end_point != 2
        @result << workflow_state.id
      end
    end
    return @result
  end

  def find_node_index(nodes, node_id)
    for node in nodes
      if node["id"] == node_id
        return nodes.index(node)
      end
    end
  end

  def roles
    roles = []
    for role_id in self.workflow_states.pluck(:role_id).uniq
      role = Role.find_by_id(role_id)
      if !role.blank?
        roles << role
      end
    end
    return roles
  end

  def users
    @workflow_states = self.workflow_states
    @role_ids = []
    for workflow_state in @workflow_states
      @role_ids << workflow_state.role_id
    end
    @user_ids = Assignment.where("role_id IN (?)", @role_ids).pluck(:user_id)
    @users = User.where("id IN (?)", @user_ids)
    return @users
  end
end
