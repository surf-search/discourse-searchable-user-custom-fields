# frozen_string_literal: true

module ChordDirectory
  class ChordDirectoryController < ApplicationController
    requires_plugin 'chord-directory'

    def index
      filters = {
        tags: params[:tags],
        category: params[:category],
        solved: params[:solved],
        search_term: params[:search],
        ascending: params[:ascending],
        order: params[:order],
        page: params[:page]
      }

      query = ChordDirectory::Query.new(current_user, filters).list

      render json: query
    end
  end
end
