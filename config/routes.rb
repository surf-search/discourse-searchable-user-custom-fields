# frozen_string_literal: true

require_dependency 'chord_directory_constraint'

ChordDirectory::Engine.routes.draw do
  get '/' => 'chord_directory#index', constraints: ChordDirectoryConstraint.new
  get '.json' => 'chord_directory#index', constraints: ChordDirectoryConstraint.new
end
