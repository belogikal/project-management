json.resource do
  json.partial! 'members/details', member: @resource
end
