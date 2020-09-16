module ChordDirectory
  CustomFieldAdder = Struct.new(:users) do
    def enable_searchable_ucfs(ucf_names)
      # query all the custom user field data and add it to the search index as a ts vector
      
      # query custom user fields
      user_field_data = UserCustomField.joins("INNER JOIN users u on u.id = user_custom_fields.user_id").where(name:ucf_names).to_a

      # make the default for new keys an empty array
      data_by_user = Hash.new {|hash, key| hash[key] = [] }
      # for each record result, append the user field data to an array
      user_field_data.each {|record| data_by_user[record.user_id] << record.value}
      
      users.each do |u|
        if data_by_user.key?(u.id)
          # add the username data that always is in there like:  discourse/app/services/search_indexer.rb 
          username = u.username_lower || ''
          fullname = u.name ? u.name.downcase : ''
          # add the search data to the index
          SearchIndexer.update_index(table: 'user', id: u.id, a_weight: data_by_user[u.id].join(","), b_weight: fullname, c_weight: username)
        end
      end

    end
  end
end
