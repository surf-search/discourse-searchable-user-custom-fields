module ChordDirectory
  CustomFieldAdder = Struct.new(:users) do
    def enable_searchable_ucfs(ucf_names)
      # query all the custom user field data and add it to the search index as a ts vector
      # users = User.where(active: true).where(staged: false)
      
      # included_fields = SiteSetting.searchable_user_fields.split('|')
      # included_fields = ["Previous Institutions & Majors","Ask Me About"]
      # query custom user fields
      # custom_u_field_names = UserField.where(name:included_fields).pluck(:id).map {|x| "user_field_#{x}"}
      user_field_data = UserCustomField.joins("INNER JOIN users u on u.id = user_custom_fields.user_id").where(name:ucf_names).to_a

      # make the default for new keys an empty array
      data_by_user = Hash.new {|hash, key| hash[key] = [] }
      # for each record result, append the user field data to an array
      user_field_data.each {|record| data_by_user[record.user_id] << record.value}
      # add the username data that always is in there like:  discourse/app/services/search_indexer.rb 
      # users.each {|u| data_by_user[u.id].push(u.username_lower || '', u.name ? u.name.downcase: '')}

      users.each do |u|
        if data_by_user.key?(u.id)
          # add the username data that always is in there like:  discourse/app/services/search_indexer.rb 
          data_by_user[u.id].push(u.username_lower || '', u.name ? u.name.downcase: '')
          # add the search data to the index
          SearchIndexer.update_index(table: 'user', id: u.id, raw_data: data_by_user[u.id])
        end
      end

    end
  end
end
