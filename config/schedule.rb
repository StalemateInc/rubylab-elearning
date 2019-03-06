every :day do 
  rake 'import:elasticsearch'
  rake 'import_autocomplete:elasticsearch'
end
