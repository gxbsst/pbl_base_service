json.partial! 'post', post: @clazz_instance
if @include_replies
  json.replies do
    json.array! @clazz_instance.replies
  end
end