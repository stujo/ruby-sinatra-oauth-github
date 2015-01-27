before '/notes*' do
  authenticate!
end


get '/notes' do
  @notes = Note.all
  erb :"notes/index"
end

get '/notes/mine' do
  @notes = Note.where(:github_username => current_github_username)

  if @notes.blank?
    flash[:info] = 'You don\'t have any notes yet, make one!'
    redirect '/notes/new'
  else
    erb :"users/notes"
  end

end

get '/notes/new' do
  @note = Note.new
  erb :"notes/new"
end

post '/notes' do
  @note = Note.new(params[:note])
  @note.github_username = current_github_username
  if @note.save
    flash[:info] = 'New note added!'
    redirect "/notes"
  else
    erb :"notes/new"
  end
end

get '/notes/:id' do
  @note = Note.find(params[:id])
  erb :"notes/show"
end

get '/notes/:id/edit' do
  @note = Note.find(params[:id])
  halt 401 unless @note.github_username == current_github_username
  erb :"notes/edit"
end

post '/notes/:id' do
  @note = Note.find(params[:id])
  halt 401 unless @note.github_username == current_github_username
  if @note.update_attributes(params[:note])
    flash[:info] = 'Note updated!'
    redirect '/notes/mine'
  else
    erb :"notes/edit"
  end
end

delete '/notes/:id' do
  @note = Note.find(params[:id])
  halt 401 unless @note.github_username == current_github_username
  @note.destroy
  flash[:info] = 'Note deleted!'
  redirect '/notes/mine'
end




