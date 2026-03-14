# frozen_string_literal: true

class WikiMetaController < ApplicationController
  accept_api_auth :index

  before_action :find_project
  before_action :check_wiki_approval_enabled
  before_action :authorize_view

  # GET /projects/:project_id/wiki_meta/index.json
  # Returns wiki page list with internal DB id for title-rename tracking
  def index
    wiki = @project.wiki
    return render_404 unless wiki

    pages = wiki.pages.includes(:parent).select(:id, :title, :wiki_id, :parent_id, :created_on)

    respond_to do |format|
      format.api do
        render json: {
          wiki_pages: pages.map { |p|
            {
              id: p.id,
              title: p.title,
              parent_title: p.parent&.title,
              created_on: p.created_on
            }
          }
        }, status: :ok
      end
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def check_wiki_approval_enabled
    return render_403 unless RedmineWikiApproval.is_enabled?(@project)
  end

  def authorize_view
    return render_403 unless User.current.allowed_to?(:view_wiki_pages, @project)
  end
end
