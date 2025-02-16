class CreateAllTables < ActiveRecord::Migration[7.0]
  def change

    create_table :access_controls , id: :bigserial, primary_key: :id do |t|
 
      t.integer :user_id   
      t.integer :role_id   
      t.integer :view_unrelated_articles   
      t.integer :view_article_logs   
      t.integer :view_workflow_transactions   
      t.integer :create_workflow   
      t.integer :alter_article_areas   
      t.integer :alter_article_events   
      t.integer :alter_article_formats   
      t.integer :alter_article_relation_types   
      t.integer :alter_article_sources   
      t.integer :alter_article_types   
      t.integer :alter_keywords   
      t.integer :alter_languages   
      t.integer :alter_profiles   
      t.integer :alter_roles   
      t.integer :alter_duties   
      t.integer :alter_title_types   

      t.integer :alter_content_templates   
      t.integer :alter_section_items   
      t.integer :alter_publishers   
      t.integer :alter_locations   
      t.integer :alter_publish_sources   
      t.integer :alter_access_groups   
      t.integer :alter_profile_groups   
      t.integer :edit_workflow   
      t.integer :edit_roles   
      t.integer :alter_assignments   
      t.integer :edit_assignments   
      t.timestamps
    end

    create_table :access_groupings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :access_group_id   
      t.integer :article_id   
      t.integer :user_id   

      t.boolean :nofity   
      t.boolean :notify   
      t.boolean :notify_automation   
      t.timestamps
    end

    create_table :access_groups , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.integer :user_id   

      t.timestamps
    end

    create_table :areaings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_area_id   
      t.integer :article_id   

      t.timestamps
    end

    create_table :areaing_histories , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_id   
      t.integer :article_area_id   
      t.string :revision_number   
      t.integer :user_id   
      t.integer :workflow_transition_id   
      t.integer :areaing_id   

      t.timestamps
    end

    create_table :articles , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :abstract   
      t.text :content   
      t.string :url   
      t.string :slug   

      t.integer :workflow_state_id   
      t.integer :content_template_id   
      t.string :document_contents   
      t.text :content_wo_tags   
      t.date :published_at   
      t.integer :access_group_id   
      t.string :description   
      t.text :notes   
      t.string :dimensions   
      t.string :retrieval_number   
      t.text :publish_details   
      t.string :access_for_others   
      t.integer :position   
      t.integer :user_id   
      t.datetime :published_on   
      t.integer :published_via   
      t.string :publish_uuid   
      t.boolean :pdf_generated   
      t.string :trial_uuid   
      t.boolean :archived   
      t.integer :external_id   
      t.integer :publish_source_id   
      t.timestamps
    end

    create_table :article_areas , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   

      t.integer :user_id   
      t.timestamps
    end

    create_table :article_events , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   

      t.integer :user_id   
      t.timestamps
    end

    create_table :article_formats , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   

      t.integer :user_id   
      t.timestamps
    end

    create_table :article_histories , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :abstract   
      t.text :content   
      t.string :url   
      t.text :document_contents   

      t.string :revision_number   
      t.integer :user_id   
      t.integer :article_id   
      t.integer :workflow_transition_id   
      t.timestamps
    end

    create_table :article_relation_types , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   

      t.integer :user_id   
      t.integer :reverse_relation_id   
      t.timestamps
    end

    create_table :article_sources , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   

      t.integer :user_id   
      t.timestamps
    end

    create_table :article_types , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   

      t.integer :user_id   
      t.timestamps
    end

    create_table :assignments , id: :bigserial, primary_key: :id do |t|
 
      t.integer :user_id   
      t.integer :role_id   
      t.integer :assigner_id   

      t.timestamps
    end

    create_table :carriers , id: :bigserial, primary_key: :id do |t|
 
      t.integer :source_workflow_state_id   
      t.integer :target_workflow_state_id   
      t.string :rules   
      t.integer :user_id   
      t.boolean :done   

      t.integer :timer   
      t.integer :voting_condition   
      t.integer :trials   
      t.timestamps
    end

    create_table :comments , id: :bigserial, primary_key: :id do |t|
 
      t.string :content   
      t.integer :commentable_id   
      t.string :commentable_type   

      t.integer :user_id   
      t.string :comment_type   
      t.timestamps
    end

    create_table :content_templates , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :content   
      t.integer :user_id   

      t.timestamps
    end

    create_table :contributions , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_id   
      t.integer :role_id   
      t.integer :duty_id   

      t.integer :profile_id   
      t.boolean :sign   
      t.timestamps
    end

    create_table :contribution_histories , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_id   
      t.integer :role_id   
      t.integer :duty_id   
      t.integer :profile_id   
      t.integer :revision_number   
      t.integer :user_id   
      t.integer :workflow_transition_id   
      t.integer :contribution_id   

      t.timestamps
    end

    create_table :datings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_event_id   
      t.integer :article_id   
      t.date :event_date   

      t.timestamps
    end

    create_table :dating_histories , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_id   
      t.integer :article_event_id   
      t.date :event_date   
      t.string :revision_number   
      t.integer :user_id   
      t.integer :workflow_transition_id   

      t.integer :dating_id   
      t.timestamps
    end

    create_table :duties , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   

      t.integer :user_id   
      t.timestamps
    end

    create_table :formatings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_format_id   
      t.integer :article_id   

      t.timestamps
    end

    create_table :formating_histories , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_format_id   
      t.integer :article_id   
      t.integer :user_id   
      t.string :revision_number   
      t.integer :workflow_state_id   
      t.integer :formating_id   

      t.integer :workflow_transition_id   
      t.timestamps
    end

    create_table :home_settings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :user_id   
      t.integer :pp   
      t.string :sort   
      t.integer :workflow_state   

      t.integer :workflow   
      t.integer :archived   
      t.timestamps
    end

    create_table :interconnects , id: :bigserial, primary_key: :id do |t|
 
      t.integer :user_id   
      t.string :provider   
      t.string :uuid   
      t.string :token   

      t.timestamps
    end

    create_table :involvements , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_id   
      t.integer :publisher_id   
      t.text :details   

      t.timestamps
    end

    create_table :journals , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.string :vol   
      t.string :no   

      t.timestamps
    end

    create_table :keywords , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   

      t.integer :user_id   
      t.timestamps
    end

    create_table :kinships , id: :bigserial, primary_key: :id do |t|
 
      t.integer :user_id   
      t.integer :kin_id   

      t.integer :article_relation_type_id   
      t.integer :article_id   
      t.integer :rank   
      t.timestamps
    end

    create_table :kinship_histories , id: :bigserial, primary_key: :id do |t|
 
      t.integer :user_id   
      t.integer :kin_id   
      t.integer :article_id   
      t.integer :article_relation_type_id   
      t.string :revision_number   
      t.integer :workflow_transition_id   

      t.integer :kinship_id   
      t.timestamps
    end

    create_table :languages , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   

      t.integer :user_id   
      t.timestamps
    end

    create_table :locations , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.integer :user_id   
      t.float :longitude   
      t.float :latidue   
      t.text :description   

      t.timestamps
    end

    create_table :messages , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :body   
      t.integer :sender_id   
      t.integer :urgency   

      t.integer :status   
      t.integer :parent_id   
      t.timestamps
    end

    create_table :messagings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :recipient_id   
      t.integer :message_id   
      t.integer :status   

      t.timestamps
    end

    create_table :mirorrs , id: :bigserial, primary_key: :id do |t|
 
      t.integer :source_state   
      t.integer :target_state   
      t.integer :user_id   

      t.timestamps
    end

    create_table :note_templates , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.integer :user_id   

      t.timestamps
    end

    create_table :notifications , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :content   
      t.string :notifiable_id   
      t.string :notifiable_type   

      t.integer :user_id   
      t.string :notification_type   
      t.integer :emmiter_id   
      t.text :custom_text   
      t.timestamps
    end

    create_table :notification_settings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :user_id   
      t.boolean :article_sent   
      t.boolean :article_received   
      t.boolean :article_refunded   
      t.boolean :article_refunded_received   
      t.boolean :article_comment   
      t.boolean :article_vote   

      t.boolean :access_grouping   
      t.timestamps
    end

    create_table :notings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :note_template_id   
      t.integer :article_id   
      t.integer :user_id   

      t.timestamps
    end

    create_table :originatings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_id   
      t.integer :article_source_id   

      t.timestamps
    end

    create_table :originating_histories , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_id   
      t.integer :article_source_id   
      t.integer :originating_id   
      t.string :revision_number   
      t.integer :user_id   
      t.integer :workflow_transition_id   

      t.timestamps
    end

    create_table :profiles , id: :bigserial, primary_key: :id do |t|
 
      t.string :name   
      t.string :surename   
      t.integer :user_id   
      t.string :phone_number   
      t.string :cellphone_number   

      t.string :avatar_file_name   
      t.string :avatar_content_type   
      t.bigint :avatar_file_size   
      t.datetime :avatar_updated_at   
      t.string :email   
      t.string :stage_name   
      t.string :signature_file_name   
      t.string :signature_content_type   
      t.bigint :signature_file_size   
      t.datetime :signature_updated_at   
      t.integer :personnel_code   
      t.string :dabir_personnel_id   
      t.string :dabir_department_id   
      t.timestamps
    end

    create_table :profile_groupings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :profile_id   
      t.integer :profile_group_id   
      t.integer :user_id   

      t.timestamps
    end

    create_table :profile_groups , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   

      t.integer :user_id   
      t.integer :workflow_id   
      t.timestamps
    end

    create_table :publications , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_id   
      t.integer :publisher_id   
      t.date :publication_date   
      t.string :pp   
      t.string :vol   

      t.integer :location_id   
      t.integer :publish_source_id   
      t.timestamps
    end

    create_table :publishers , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.string :description   
      t.integer :user_id   

      t.integer :organization_type   
      t.timestamps
    end

    create_table :publish_sources , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   
      t.integer :publisher_id   

      t.integer :user_id   
      t.timestamps
    end

    create_table :roles , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   

      t.string :abr   
      t.integer :user_id   
      t.boolean :start_point   
      t.timestamps
    end

    create_table :role_accesses , id: :bigserial, primary_key: :id do |t|
 
      t.integer :role_id   
      t.integer :access_group_id   

      t.timestamps
    end


    create_table :sectionings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :section_id   
      t.integer :section_item_id   

      t.timestamps
    end

    create_table :sections , id: :bigserial, primary_key: :id do |t|
 
      t.integer :workflow_id   
      t.integer :user_id   

      t.string :title   
      t.timestamps
    end

    create_table :section_items , id: :bigserial, primary_key: :id do |t|
 
      t.integer :section_id   
      t.string :item_name   

      t.string :title   
      t.string :description   
      t.integer :user_id   
      t.string :klass_name   
      t.timestamps
    end

    create_table :speakings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :language_id   
      t.integer :article_id   

      t.timestamps
    end

    create_table :speaking_histories , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_id   
      t.integer :language_id   
      t.string :revision_number   
      t.integer :user_id   
      t.integer :workflow_transition_id   
      t.integer :speaking_id   

      t.timestamps
    end

    create_table :ssos , id: :bigserial, primary_key: :id do |t|
 
      t.string :utid   
      t.string :uuid   

      t.string :status   
      t.timestamps
    end

    create_table :state_pages , id: :bigserial, primary_key: :id do |t|
 
      t.integer :workflow_state_id   
      t.boolean :item_title   
      t.boolean :item_titlings   
      t.boolean :item_abstract   
      t.boolean :item_url   
      t.boolean :item_keywords   
      t.boolean :item_datings   
      t.boolean :item_typings   
      t.boolean :item_speakings   
      t.boolean :item_formatings   
      t.boolean :item_contributions   
      t.boolean :item_kinships   
      t.boolean :item_originatings   
      t.boolean :item_content   
      t.boolean :item_upload   

      t.string :uuid   
      t.boolean :item_areaings   
      t.boolean :item_publications   
      t.boolean :item_notes   
      t.boolean :item_dimensions   
      t.boolean :item_retrieval_number   
      t.boolean :item_position   
      t.timestamps
    end

    create_table :taggings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :taggable_id   
      t.string :taggable_type   
      t.integer :target_id   
      t.string :target_type   

      t.timestamps
    end

    create_table :tagging_histories , id: :bigserial, primary_key: :id do |t|
 
      t.integer :taggable_id   
      t.string :taggable_type   
      t.integer :target_id   
      t.string :target_type   
      t.integer :user_id   
      t.string :revision_number   
      t.integer :article_id   
      t.integer :workflow_transition_id   

      t.integer :tagging_id   
      t.timestamps
    end

    create_table :title_types , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   

      t.integer :user_id   
      t.timestamps
    end

    create_table :titlings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :title_type_id   
      t.integer :article_id   
      t.integer :status   

      t.string :content   
      t.timestamps
    end

    create_table :typings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_type_id   
      t.integer :article_id   

      t.timestamps
    end

    create_table :typing_histories , id: :bigserial, primary_key: :id do |t|
 
      t.integer :article_type_id   
      t.integer :article_id   
      t.integer :typing_id   
      t.string :revision_number   
      t.integer :user_id   
      t.integer :workflow_transition_id   

      t.timestamps
    end

    create_table :uploads , id: :bigserial, primary_key: :id do |t|
 
      t.string :uploadable_type   
      t.integer :uploadable_id   
      t.string :token   

      t.string :attachment_file_name   
      t.string :attachment_content_type   
      t.bigint :attachment_file_size   
      t.datetime :attachment_updated_at   
      t.string :attachment_type   
      t.string :title   
      t.text :detail   
      t.integer :user_id   
      t.boolean :only_index   
      t.boolean :printable   
      t.boolean :summable   
      t.timestamps
    end

    create_table :upload_histories , id: :bigserial, primary_key: :id do |t|
 
      t.string :uploadable_type   
      t.integer :uploadable_id   
      t.string :token   
      t.string :attachment_type   
      t.string :revision_number   
      t.integer :user_id   
      t.integer :workflow_transition_id   
      t.integer :speaking_id   

      t.string :attachment_file_name   
      t.string :attachment_content_type   
      t.bigint :attachment_file_size   
      t.datetime :attachment_updated_at   
      t.integer :upload_id   
      t.timestamps
    end

    create_table :users , id: :bigserial, primary_key: :id do |t|
 
      t.string :email  
      t.string :encrypted_password  
      t.string :reset_password_token   
      t.datetime :reset_password_sent_at   
      t.datetime :remember_created_at   

      t.integer :current_role_id   
      t.string :utid   
      t.string :name   
      t.string :surename   
      t.integer :new_utid   
      t.text :access_token   
      t.timestamps
    end

    create_table :votes , id: :bigserial, primary_key: :id do |t|
 
      t.integer :user_id   
      t.integer :voting_id   
      t.integer :outcome   

      t.integer :article_id   
      t.timestamps
    end

    create_table :votings , id: :bigserial, primary_key: :id do |t|
 
      t.integer :votable_id   
      t.string :votable_type   
      t.integer :deadline   
      t.integer :voting_type   

      t.timestamps
    end

    create_table :word_templates , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.integer :workflow_id   

      t.integer :user_id   
      t.string :document_file_name   
      t.string :document_content_type   
      t.bigint :document_file_size   
      t.datetime :document_updated_at   
      t.timestamps
    end

    create_table :workflows , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.text :description   
      t.integer :user_id   
      t.string :graph_data   
      t.string :nodes   
      t.string :edges   

      t.integer :start_node_id   
      t.integer :admin_id   
      t.integer :moderator_id   
      t.timestamps
    end

    create_table :workflow_role_accesses , id: :bigserial, primary_key: :id do |t|
 
      t.integer :workflow_id   
      t.integer :role_id   
      t.boolean :own_article_traceable   
      t.boolean :other_articles_traceable   

      t.timestamps
    end

    create_table :workflow_states , id: :bigserial, primary_key: :id do |t|
 
      t.string :title   
      t.integer :workflow_id   

      t.integer :node_id   
      t.text :editable   
      t.integer :refundable   
      t.integer :commentable   
      t.integer :start_point   
      t.integer :end_point   
      t.integer :role_id   
      t.integer :votable   
      t.integer :publishable   
      t.integer :notifiable   
      t.boolean :deleted   
      t.integer :default_state_page   
      t.timestamps
    end

    create_table :workflow_transitions , id: :bigserial, primary_key: :id do |t|
 
      t.integer :workflow_id   
      t.integer :from_state_id   
      t.integer :to_state_id   
      t.text :message   
      t.integer :user_id   
      t.integer :role_id   
      t.integer :transition_type   

      t.integer :article_id   
      t.string :revision_number   
      t.timestamps
    end
  end
end
