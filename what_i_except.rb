#new view
screen :file_manager do
  #set title frame
  title :uplaod
  #h1 html
  h1 :uplaod
  #group i.e. div
  group do
    #html: <input type="file">...
    # when the button is released, call the function select_on_release (ligne 16)
    # for a button, the first argument is the name of the button (id for the moment) and the method to call, if exist.
    button :select, type: :file, event: on_release
    #other buttons, each one call the method cancel, downlaod and delete
    button :cancel, type: :cancel
    button :downlaod
    button :delete
  end
  
  #method called when the button select in released
  select_on_release do
    #ul html element
    ul do
      #All selected file from an html tag <input type="file">...
      Repository.selected_files.each do |file|
        #orint file name
        file.name
        #a chackbox with id="file.to_id"
        # So we can do File.select_checked.checked or File-select_checked.unchecked to get all (un)checked elements
        checkbox :select_checked, model: file
        #buttons, the method download_one called on click have the argument file
        button :download_one, params: file
      end
    end
  end
  ul  do
    # Do a GET request on the resource corresspondig of an index(a list of element)
    # The url can be changed by calling the method index_url in the model
    # In this case, it should get a list of files and repositories
    # We print only the list of files
    Repository.index.files.each do |file|
      li do
        file.name
        checkbox model: file
        button :delete_one
      end
    end
  end
end

def cancel
  RepoFile.select_checked.checked.each do |file|
    file.remove
  end
end

def downlaod
  Repository.selected_files.post
end

def delete
  Repository.selected_files.destroy
end

def download_one(file)
  file.post
end

# The model repository.
# It extend from InputFile useful to get a list of selected files in the user space
class Repository
  extend InputFile
  # Called when a user has selected files in this computer
  # The return value will be passed to the field :selected_files
  on_input_files_available do
    repo = Repository.new
    repo << input_files.each do |input|
      File.new(name: input.path)
    end
    repo
  end
  # A repository can have a list of instance of Class RepoFile (0..n)
  has_many :repo_file
  
  has_many :repository
end

class RepoFile
  attr_json :id, :name
  
  # The Repository in which the file is the member
  belongs_to :repository
end

Robl.config do |config|
  # We can set the base url for the request
  config.base_url = '0.0.0.0:3000'
end