# frozen_string_literal: true

RedmineApp::Application.routes.draw do
  # Query (fixed paths — must precede dynamic :title routes)
  get  'projects/:project_id/wiki_draft/approvers',      to: 'wiki_draft#approvers', as: 'wiki_draft_approvers'
  get  'projects/:project_id/wiki_draft/pending',         to: 'wiki_draft#pending',   as: 'wiki_draft_pending'
  get  'projects/:project_id/wiki_draft/my_tasks',        to: 'wiki_draft#my_tasks',  as: 'wiki_draft_my_tasks'
  get  'projects/:project_id/wiki_draft/statuses',        to: 'wiki_draft#statuses', as: 'wiki_draft_statuses'

  # Draft management (:title — hierarchical titles with / not supported)
  put  'projects/:project_id/wiki_draft/:title',          to: 'wiki_draft#update',    as: 'wiki_draft_update'
  post 'projects/:project_id/wiki_draft/:title/release',  to: 'wiki_draft#release',   as: 'wiki_draft_release'
  post 'projects/:project_id/wiki_draft/:title/submit',   to: 'wiki_draft#submit',    as: 'wiki_draft_submit'
  get  'projects/:project_id/wiki_draft/:title/status',   to: 'wiki_draft#status',    as: 'wiki_draft_status'

  # Wiki meta (page ID for title-rename tracking)
  get  'projects/:project_id/wiki_meta/index',            to: 'wiki_meta#index',      as: 'wiki_meta_index'
end
