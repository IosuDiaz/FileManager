class FileManager
  def initialize
    @root_folder = Folder.new('root')
    @current_folder = @root_folder
    @current_folder_name = 'root'
    @path = []
    @current_user = nil
    @users = []
  end

  def create_user(username, password)
    return 'Invalid input. Usage: create_user <username> <password>' if username.nil? || password.nil?

    @users.find { |u| u.username == username } ? puts('Username: Already in use.') : user_creation(username, password)
  end

  def login(username, password)
    return 'Invalid input. Usage: login <username> <password>' if username.nil? || password.nil?

    user = @users.find { |u| u.username == username && u.password == password }
    user ? log_user(user) : puts('Invalid username or password.')
  end

  def whoami
    @current_user ? puts("Current user: #{@current_user.username}") : puts('No user logged in.')
  end

  def execute_command(input)
    comand_with_args = input.split(' ')
    command = comand_with_args[0]
    args = comand_with_args[1..]
    case command
    when 'create_user'
      create_user(args[0], args[1])
    when 'login'
      login(args[0], args[1])
    when 'whoami'
      whoami
    when 'exit'
      exit
    else
      @current_folder ? execute_file_manager_command(command, args) : puts('Login required.')
    end
  end

  def execute_file_manager_command(command, args)
    case command
    when 'create_file'
      return 'Invalid input. Usage: create_file <filename> <content>' if args.length < 2

      create_file(args[0], args[1..].join(' '), @current_user.username)
    when 'show'
      return 'Invalid input. Usage: show <filename>' if args.empty?

      show(args[0])
    when 'metadata'
      return 'Invalid input. Usage: metadata <filename>' if args.empty?

      metadata(args[0])
    when 'create_folder'
      return 'Invalid input. Usage: create_folder <foldername>' if args.empty?

      create_folder(args[0])
    when 'cd'
      return 'Invalid input. Usage: cd <foldername>' if args.empty?

      cd(args[0])
    when 'destroy'
      return 'Invalid input. Usage: destroy <filename or foldername>' if args.empty?

      destroy(args[0])
    when 'ls'
      ls
    when 'whereami'
      whereami
    else
      "Invalid command: #{command}"
    end
  end

  def create_file(name, content, created_by)
    file_item = @current_folder.contents.find { |f| f.is_a?(FileItem) && f.name == name }
    file_item ? puts('File name already in use.') : file_creation(name, content, created_by)
  end

  def show(name)
    file_item = @current_folder.contents.find { |f| f.is_a?(FileItem) && f.name == name }
    file_item ? show_file_content(file_item, name) : puts("File not found: #{name}")
  end

  def metadata(name)
    file_item = @current_folder.contents.find { |f| f.is_a?(FileItem) && f.name == name }
    file_item ? show_metadata(file_item) : puts("File not found: #{name}")
  end

  def create_folder(name)
    @current_folder.contents << Folder.new(name)
    @current_folder.updated_at = DateTime.now
  end

  def cd(name)
    return 'Invalid input. Usage: cd <foldername>' if name.nil?

    name == '..' ? move_up : move_into(name)
  end

  def destroy(name)
    item = @current_folder.contents.find { |f| f.name == name }
    item ? delete_item(item, name) : puts("Item not found: #{name}")
  end

  def ls
    puts "Contents of #{@current_folder_name}"
    @current_folder.contents.each do |item|
      puts item.display
    end
  end

  def whereami
    path = @path.map(&:name).join('/')
    puts "Current path: /#{path}/#{@current_folder_name}"
  end

  private

  def log_user(user)
    @current_user = user
    puts "Logged in as '#{user.username}'."
  end

  def user_creation(username, password)
    user = User.new(username, password)
    @users << user
    puts "User '#{user.username}' created."
  end

  def file_creation(name, content, created_by)
    file_item = FileItem.new(name, content, created_by)
    @current_folder.contents << file_item
    @current_folder.updated_at = DateTime.now
  end

  def show_file_content(file_item, name)
    puts "Content of #{name}:"
    puts file_item.content
  end

  def show_metadata(file_item)
    puts "Metadata for #{name}:"
    puts "Created at: #{file_item.created_at}"
    puts "Updated at: #{file_item.updated_at}"
    puts "Created by: #{file_item.created_by}"
  end

  def move_up
    if @path.empty?
      puts 'Already at the root folder'
    else
      @current_folder = @path.pop
      @current_folder_name = @current_folder.name
      puts "Entered folder: #{@current_folder_name}"
    end
  end

  def move_into(name)
    folder = find_folder_by_name(name)
    if folder
      @path.push(@current_folder)
      @current_folder = folder
      @current_folder_name = @current_folder.name
      puts "Entered folder: #{@current_folder_name}"
    else
      puts "Folder not found: #{name}"
    end
  end

  def find_folder_by_name(name)
    @current_folder.contents.find { |f| f.is_a?(Folder) && f.name == name }
  end

  def delete_item(item, name)
    @current_folder.contents.delete(item)
    puts "#{name} has been deleted."
  end
end
