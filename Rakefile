require 'rake'
require 'fileutils'

desc "Hook Unix configs into system-standard positions."
task :install => [:update] do
  puts
  puts "======================================================"
  puts "Welcome to Unix configs Installation."
  puts "======================================================"
  puts

  the_world_is_mine if RUBY_PLATFORM.downcase.include?("darwin") && want_to_install?('take control of /usr/local contents')
  install_packages if RUBY_PLATFORM.downcase.include?("linux") && want_to_install?('ubuntu packages')
  install_jdk8_ubuntu if RUBY_PLATFORM.downcase.include?("linux") && want_to_install?('ubuntu jdk8')
  install_homebrew if want_to_install?('brew')
  install_pip if want_to_install?('pip')
  install_rbenv if want_to_install?('rbenv')
  install_gems if want_to_install?('gems')
  install_nodenv if want_to_install?('nodenv')

  install_files Dir.glob('git/*') if want_to_install?('git configs (color, aliases)')
  install_files Dir.glob('tmux/*') if want_to_install?('tmux config')
  install_files Dir.glob('bash/runcoms/*'), withDirectories: false if want_to_install?('bash configs')
  install_files Dir.glob('vim/{*,.[a-zA-Z]*}'), destination: "#{ENV['HOME']}/.vim", prefix: '' if want_to_install?('vim configuration')

  link_binaries('shells/bins') if want_to_install?('custom binaries')

  install_fish if want_to_install?('fish')

  install_fonts if want_to_install?('powerline fonts')

  install_term_theme if RUBY_PLATFORM.downcase.include?("darwin") && want_to_install?('Apply custom ITerm2.app settings (ex: solarized theme)')

  install_terminal_app_theme if RUBY_PLATFORM.downcase.include?("darwin") && want_to_install?('Apply custom Terminal.app settings (ex: solarized theme)')

  copy_files('keyboard/layouts', '/Library/Keyboard\ Layouts', 'sudo') if
    RUBY_PLATFORM.downcase.include?("darwin") && want_to_install?('Fixed UK keyboard layout')

  run_bundle_config if want_to_install?('bundle config')

  success_msg("installed")
end

desc "Init and update submodules."
task :update do
  unless ENV["SKIP_SUBMODULES"]
    puts "======================================================"
    puts "Downloading Unix configs submodules...please wait"
    puts "======================================================"

    puts run %{
      cd $DOTFILES &&
      git pull --rebase --autostash --recurse-submodules &&
      git submodule update --init --recursive --remote --force --jobs 8 &&
      git submodule status --recursive
    }
    puts
  end
end

task :default => 'install'

private
def run(cmd)
  puts "[Running] #{cmd}"
  `#{cmd}` unless ENV['DEBUG']
end

def number_of_cores
  if RUBY_PLATFORM.downcase.include?("darwin")
    cores = run %{ sysctl -n hw.ncpu }
  else
    cores = run %{ nproc }
  end
  puts
  cores.to_i
end

def run_bundle_config
  return unless system("which bundle")

  bundler_jobs = number_of_cores - 1
  puts "======================================================"
  puts "Configuring Bundlers for parallel gem installation"
  puts "======================================================"
  run %{ bundle config --global jobs #{bundler_jobs} }
  puts
end

def the_world_is_mine
  puts "======================================================"
  puts "Gaining control of /usr/local on OSX ..."
  puts "======================================================"
  run %{sudo chown -R #{ENV["USER"]}:staff /usr/local/*}
end

def install_homebrew
  brew_bin = "brew"

  run %{which #{brew_bin}}
  unless $?.success?
    puts "======================================================"
    puts "Installing Homebrew, the OSX package manager...If it's"
    puts "already installed, this will do nothing."
    puts "======================================================"
    if RUBY_PLATFORM.downcase.include?("darwin") then
      run %{ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"}
    else
      puts "Skipping brew installation on Linux for now."
      return
    end
  end

  puts
  puts
  puts "======================================================"
  puts "Updating Homebrew."
  puts "======================================================"
  run %{#{brew_bin} update}
  puts
  puts
  puts "======================================================"
  puts "Installing Homebrew packages...There may be some warnings."
  puts "======================================================"
  run %{#{brew_bin} tap homebrew/bundle}
  run %{#{brew_bin} bundle}
  run %{#{brew_bin} uninstall --force reattach-to-user-namespace}
  run %{#{brew_bin} uninstall --force tmux}
  run %{#{brew_bin} install reattach-to-user-namespace}
  run %{#{brew_bin} install tmux}
  puts
  puts
end

def install_packages
  puts
  puts
  puts "======================================================"
  puts "Installing Ubuntu Packages."
  puts "======================================================"
  run %{sudo apt -y update}
  run %{sudo apt -y install software-properties-common}
  run %{sudo apt -y install curl wget unzip nano}
  run %{sudo apt -y install build-essential checkinstall}
  run %{sudo add-apt-repository -y ppa:git-core/ppa}
  run %{sudo apt-add-repository ppa:fish-shell/release-2}
  run %{sudo apt -y update}
  run %{sudo apt -y upgrade}
  run %{sudo apt -y install git git-core}
  run %{sudo apt -y install fish}
  run %{sudo apt -y install libreadline-dev}
  run %{sudo apt -y install python-setuptools xclip}
  run %{sudo apt -y install fontconfig}
  puts
  puts
end

def install_pip
  puts
  puts
  puts "======================================================"
  puts "Installing PIP"
  puts "======================================================"

  if RUBY_PLATFORM.downcase.include?("darwin") then
    run %{brew install python3}
  else
    run %{sudo apt -y install python3 python3-dev python3-pip}
  end

  run %{sudo python3 -m pip install --ignore-installed --no-cache-dir --upgrade pip setuptools wheel}
  run %{sudo python3 -m pip install --ignore-installed --no-cache-dir --upgrade --requirement Pipfile}

  puts
  puts
end

def install_jdk8_ubuntu
  puts
  puts
  puts "======================================================"
  puts "Installing Ubuntu Packages."
  puts "======================================================"
  run %{echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections}
  run %{sudo add-apt-repository -y ppa:webupd8team/java}
  run %{sudo apt -y update}
  run %{sudo apt -y upgrade}
  run %{sudo apt -y install oracle-java8-installer}
  run %{sudo apt -y install oracle-java8-set-default}
  puts
  puts
end

def install_rbenv
  ruby_version = '2.5.1'

  run %{which rbenv}
  unless $?.success?

    puts "======================================================"
    puts "Installing rbenv"
    puts "already installed, this will do nothing."
    puts "======================================================"

    run %{git clone https://github.com/rbenv/rbenv.git #{ENV['HOME']}/.rbenv}
    run %{git clone https://github.com/rbenv/ruby-build.git #{ENV['HOME']}/.rbenv/plugins/ruby-build}
  end

  puts
  puts
  puts "======================================================"
  puts "Updating rbenv."
  puts "======================================================"

  run %{cd #{ENV['HOME']}/.rbenv && git pull}
  run %{cd #{ENV['HOME']}/.rbenv/plugins/ruby-build && git pull}
  run %{#{ENV['HOME']}/.rbenv/bin/rbenv install -s #{ruby_version}}
  run %{#{ENV['HOME']}/.rbenv/bin/rbenv global #{ruby_version}}
  run %{#{ENV['HOME']}/.rbenv/bin/rbenv rehash}

  puts
  puts
end

def install_nodenv
  node_version = '8.11.1'

  run %{which nodenv}
  unless $?.success?
    puts "======================================================"
    puts "Installing nodenv"
    puts "already installed, this will do nothing."
    puts "======================================================"
    run %{git clone https://github.com/nodenv/nodenv.git #{ENV['HOME']}/.nodenv}
    run %{cd #{ENV['HOME']}/.nodenv && src/configure && make -C src}
    run %{git clone https://github.com/nodenv/node-build.git #{ENV['HOME']}/.nodenv/plugins/node-build}
  end

  puts
  puts
  puts "======================================================"
  puts "Updating nodenv."
  puts "======================================================"

  run %{cd #{ENV['HOME']}/.nodenv && git pull}
  run %{cd #{ENV['HOME']}/.nodenv/plugins/node-build && git pull}
  run %{#{ENV['HOME']}/.nodenv/bin/nodenv install -s #{node_version}}
  run %{#{ENV['HOME']}/.nodenv/bin/nodenv global #{node_version}}

  puts
  puts
  puts "======================================================"
  puts "Installing node packages with yarn."
  puts "======================================================"

  run %{#{ENV['HOME']}/.nodenv/shims/npm install -g yarn}
  run %{#{ENV['HOME']}/.nodenv/bin/nodenv rehash}

  run %{yarn global add diff2html-cli}
  run %{yarn global add cloc}
  run %{#{ENV['HOME']}/.nodenv/bin/nodenv rehash}

  puts
  puts
end

def install_gems
  run %{which gem}
  unless $?.success?
    puts "======================================================"
    puts "Install gem and try again."
    puts "======================================================"
    return
  end

  puts
  puts
  puts "======================================================"
  puts "Installing Gems...There may be some warnings."
  puts "======================================================"
  run %{gem install bundler sass}
  run %{#{ENV['HOME']}/.rbenv/bin/rbenv rehash}
  puts
  puts
end

def install_fonts
  puts "======================================================"
  puts "Installing patched fonts for Powerline/Lightline."
  puts "Source: https://github.com/powerline/fonts"
  puts "======================================================"
  run %{ cp -f $DOTFILES/fonts/* $HOME/Library/Fonts } if RUBY_PLATFORM.downcase.include?("darwin")
  run %{ mkdir -p #{ENV['HOME']}/.fonts && cp $DOTFILES/fonts/* #{ENV['HOME']}/.fonts && fc-cache -vf #{ENV['HOME']}/.fonts } if RUBY_PLATFORM.downcase.include?("linux")
  puts
end

def install_term_theme
  puts "======================================================"
  puts "Restoring iTerm2 settings."
  puts "======================================================"
  if File.exists?('iTerm2/com.googlecode.iterm2.plist')
    run %{defaults import #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist iTerm2/com.googlecode.iterm2.plist}
  end

  puts "======================================================"
  puts "Installing iTerm2 solarized theme."
  puts "======================================================"
  run %{ /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Light' dict" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ /usr/libexec/PlistBuddy -c "Merge 'iTerm2/themes/Solarized-Light.itermcolors' :'Custom Color Presets':'Solarized Light'" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Dark' dict" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ /usr/libexec/PlistBuddy -c "Merge 'iTerm2/themes/Solarized-Dark.itermcolors' :'Custom Color Presets':'Solarized Dark'" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist }

  # If iTerm2 is not installed or has never run, we can't autoinstall the profile since the plist is not there
  if !File.exists?(File.join(ENV['HOME'], '/Library/Preferences/com.googlecode.iterm2.plist'))
    puts "======================================================"
    puts "To make sure your profile is using the solarized theme"
    puts "Please check your settings under:"
    puts "Preferences> Profiles> [your profile]> Colors> Load Preset.."
    puts "======================================================"
    return
  end

  # Ask the user which theme he wants to install
  message = "Which theme would you like to apply to your iTerm2 profile?"
  color_scheme = ask message, iTerm_available_themes

  return if color_scheme == 'None'

  color_scheme_file = File.join('iTerm2/themes', "#{color_scheme}.itermcolors")

  # Ask the user on which profile he wants to install the theme
  profiles = iTerm_profile_list
  message = "I've found #{profiles.size} #{profiles.size>1 ? 'profiles': 'profile'} on your iTerm2 configuration, which one would you like to apply the Solarized theme to?"
  profiles << 'All'
  selected = ask message, profiles

  if selected == 'All'
    (profiles.size-1).times { |idx| apply_theme_to_iterm_profile_idx idx, color_scheme_file }
  else
    apply_theme_to_iterm_profile_idx profiles.index(selected), color_scheme_file
  end
end

def iTerm_available_themes
   Dir['iTerm2/themes/*.itermcolors'].map { |value| File.basename(value, '.itermcolors')} << 'None'
end

def iTerm_profile_list
  profiles=Array.new
  begin
    profiles <<  %x{ /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':#{profiles.size}:Name" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null}
  end while $?.exitstatus==0
  profiles.pop
  profiles
end

def install_terminal_app_theme
  puts "======================================================"
  puts "Restoring Terminal.app settings."
  puts "======================================================"
  if File.exists?('terminal.app/com.apple.Terminal.plist')
    run %{defaults import #{ENV['HOME']}/Library/Preferences/com.apple.Terminal.plist terminal.app/com.apple.Terminal.plist}
  end
end

def ask(message, values)
  puts message
  while true
    values.each_with_index { |val, idx| puts " #{idx+1}. #{val}" }
    selection = STDIN.gets.chomp
    if (Float(selection)==nil rescue true) || selection.to_i < 0 || selection.to_i > values.size+1
      puts "ERROR: Invalid selection.\n\n"
    else
      break
    end
  end
  selection = selection.to_i-1
  values[selection]
end

def install_fish
  puts
  puts "Installing Shell Enhancements..."

  run %{ curl -L https://get.oh-my.fish | fish }
  run %{ omf install bobthefish }
  run %{ omf theme bobthefish }

  # Other Themes
  # run %{ omf theme agnoster }
  # run %{ omf theme bobthefish }
  # run %{ omf theme ocean }
  # run %{ omf theme budspencer }

  install_files Dir.glob('fish/*'), destination: "#{ENV['HOME']}/.config/fish", withDirectories: false, prefix: '' if want_to_install?('Fish configs')
  install_files Dir.glob('fish/conf.d/*'), destination: "#{ENV['HOME']}/.config/fish/conf.d", withDirectories: false, prefix: '' if want_to_install?('Fish extras')

  if ENV["SHELL"].include? 'fish' then
    puts "Fish is already configured as your shell of choice. Restart your session to load the new settings"
  else
    puts "Setting fish as your default shell"
    if File.exists?("/usr/local/bin/fish")
      if File.readlines("/private/etc/shells").grep("/usr/local/bin/fish").empty?
        puts "Adding fish to standard shell list"
        run %{ echo "/usr/local/bin/fish" | sudo tee -a /private/etc/shells }
      end
      run %{ chsh -s /usr/local/bin/fish }
    else
      run %{ chsh -s /bin/fish }
    end
  end
end

def want_to_install? (section, default = true)
  if ENV["ASK"]=="true"
    puts "Would you like to install configuration files for: #{section}? [y]es, [n]o"
    STDIN.gets.chomp == 'y'
  else
    true && default
  end
end

def copy_files (src, dest, prefix = '')
  puts "======================================================"
  puts "Copying files from #{src} to #{dest} ..."
  puts "======================================================"

  run %{mkdir -p #{dest}}

  if File.exists?(src) && File.exists?(dest)
    run %{#{prefix} cp -rfv #{src}/* #{dest}/}
  end
end

def install_files(files, origin: ENV["PWD"], destination: ENV["HOME"], method: :symlink, withDirectories: true, prefix: '.')
  files.each do |f|
    file = f.split('/').last
    source = "#{origin}/#{f}"
    target = "#{destination}/#{prefix}#{file}"

    puts "======================#{file}=============================="
    puts "Source: #{source}"
    puts "Target: #{target}"

    backup_dir = "#{ENV["HOME"]}/.dotfiles.bak"

    if File.exists?(target) && !File.symlink?(target)
      puts "[Overwriting] #{target}...leaving original at #{backup_dir}/#{file}..."
      run %{ mkdir -p "#{backup_dir}" }
      run %{ mv "#{target}" "#{backup_dir}/#{file}" }
    end

    if !File.directory?(source) || withDirectories
      run %{ mkdir -p "#{destination}" }
      if method == :symlink
        run %{ ln -nfs "#{source}" "#{target}" }
      elsif
        run %{ cp -f "#{source}" "#{target}" }
      end
    end

    puts "=========================================================="
    puts
  end
end

def link_binaries(path)
  # create home .bins dir if not exists
  home_bins = File.join(Dir.home, ".bins")
  Dir.mkdir(home_bins) unless Dir.exist?(home_bins)

  # list all the binaries recursivelly
  binaries = Dir.glob(path << '/*/*')
  binaries.each do |bin|
    orig_path = "#{ENV["DOTFILES"]}/#{bin}"
    bin_name = File.basename(bin.split('/').last, '.*')
    dest_path = File.join(home_bins, bin_name)

    puts
    puts "======================#{file}=============================="
    puts "Source: #{orig_path}"
    puts "Target: #{dest_path}"
    run %{ ln -nfs #{orig_path} #{dest_path} }
    puts "=========================================================="
    puts
  end
end

def apply_theme_to_iterm_profile_idx(index, color_scheme_path)
  values = Array.new
  16.times { |i| values << "Ansi #{i} Color" }
  values << ['Background Color', 'Bold Color', 'Cursor Color', 'Cursor Text Color', 'Foreground Color', 'Selected Text Color', 'Selection Color']
  values.flatten.each { |entry| run %{ /usr/libexec/PlistBuddy -c "Delete :'New Bookmarks':#{index}:'#{entry}'" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist } }

  run %{ /usr/libexec/PlistBuddy -c "Merge '#{color_scheme_path}' :'New Bookmarks':#{index}" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist }
  run %{ defaults read com.googlecode.iterm2 }
end

def success_msg(action)
  puts "Unix configs have been #{action}. Please restart your terminal."
end
