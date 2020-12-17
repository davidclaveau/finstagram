helpers do
    def current_user
        User.find_by(id: session[:user_id])
    end
end


get '/' do
    @finstagram_posts = FinstagramPost.order(created_at: :desc)
    erb(:index)
end

# signup form
get '/signup' do
    @user = User.new
    erb(:signup)
end

# sign up a new user
post '/signup' do
    
    # grab user input values from params
    email       = params[:email]
    avatar_url  = params[:avatar_url]
    username    = params[:username]
    password    = params[:password]

    
  # instantiate a User
  @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })

  # if user validations pass and user is saved
  if @user.save
    redirect to('/login')
  else
    erb(:signup)
  end
end

# login form
get '/login' do
  erb(:login)
end

# allow user to login
post '/login' do
  username = params[:username]
  password = params[:password]

  @user = User.find_by(username: username)

  if @user && @user.password == password
    session[:user_id] = @user.id
    redirect to('/')
  else
    @error_message = "Login failed."
    erb(:login)
  end
end

# logout user
get '/logout' do
    session[:user_id] = nil
    redirect to('/')
end

get '/finstagram_posts/new' do
    @finstagram_post = FinstagramPost.new
    erb(:"finstagram_posts/new")
end

post '/finstagram_posts' do
    photo_url = params[:photo_url]

    #instantiate new FinstagramPost
    @finstagram_post = FinstagramPost.new({ photo_url: photo_url, user_id: current_user.id })

    #if @post validates, save
    if @finstagram_post.save
        redirect(to('/'))
    else
        erb(:"finstagram_posts/new")
    end
end

get '/finstagram_posts/:id' do
    @finstagram_post = FinstagramPost.find(params[:id]) # find the finstagram post with the ID from the URL
    erb(:"finstagram_posts/show")
end

post '/comments' do
  # point values from params to variables
  text = params[:text]
  finstagram_post_id = params[:finstagram_post_id]

  # instantiate a comment with those values & assign the comment to the `current_user`
  comment = Comment.new({ text: text, finstagram_post_id: finstagram_post_id, user_id: current_user.id })

  # save the comment
  comment.save

  # `redirect` back to wherever we came from
  redirect(back)
end

post '/likes' do
  # point values from params to variables
  finstagram_post_id = params[:finstagram_post_id]

  # instantiate a comment with those values & assign the comment to the `current_user`
  like = Like.new({ finstagram_post_id: finstagram_post_id, user_id: current_user.id })

  # save the comment
  like.save

  # `redirect` back to wherever we came from
  redirect(back)
end

delete '/likes/:id' do
  like = Like.find(params[:id])
  like.destroy
  redirect(back)
end