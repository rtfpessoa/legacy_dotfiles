require 'rake'
require 'fileutils'
require 'tmpdir'

desc 'Hook Unix configs into system-standard positions.'
task install: [:update] do
  puts
  puts '======================================================'
  puts 'Welcome to Unix configs Installation.'
  puts '======================================================'
  puts

  install_ubuntu_packages if RUBY_PLATFORM.downcase.include?('linux') && want_to_install?('ubuntu packages')

  install_homebrew_and_packages if RUBY_PLATFORM.downcase.include?('darwin') && want_to_install?('homebrew and packages')

  install_pyenv if want_to_install?('pyenv')
  install_rbenv if want_to_install?('rbenv')
  install_nodenv if want_to_install?('nodenv')
  install_jabba if want_to_install?('jabba')

  install_files Dir.glob('git/*') if want_to_install?('git configs (color, aliases)')
  install_files Dir.glob('tmux/*') if want_to_install?('tmux config')
  install_files Dir.glob('vim/{*,.[a-zA-Z]*}'), destination: "#{ENV['HOME']}/.vim", prefix: '' if want_to_install?('vim configuration')

  install_files Dir.glob('bin/linux/*'), destination: "#{ENV['HOME']}/.bin", prefix: '' if RUBY_PLATFORM.downcase.include?('linux') && want_to_install?('linux binaries')

  install_files Dir.glob('shells/bash/runcoms/*'), with_directories: false if want_to_install?('bash configs')
  setup_fish if want_to_install?('setup fish')

  install_fonts if want_to_install?('powerline fonts')

  install_term_theme if RUBY_PLATFORM.downcase.include?('darwin') && want_to_install?('Apply custom ITerm2.app settings (ex: solarized theme)')
  install_terminal_app_theme if RUBY_PLATFORM.downcase.include?('darwin') && want_to_install?('Apply custom Terminal.app settings (ex: solarized theme)')

  copy_files('keyboard/layouts', "#{ENV['HOME']}/Library/Keyboard\ Layouts") if
    RUBY_PLATFORM.downcase.include?('darwin') && want_to_install?('Fixed UK keyboard layout')

  success_msg('installed')
end

desc 'Init and update submodules.'
task :update do
  unless ENV['SKIP_SUBMODULES']
    puts '======================================================'
    puts 'Downloading Unix configs submodules...please wait'
    puts '======================================================'
    puts run %( cd $DOTFILES; git submodule update --init --recursive --remote --force --jobs 12 )
    puts
  end
end

task default: 'install'

private
def run(cmd)
  puts "[Running] #{cmd}"
  `#{cmd}` unless ENV['DEBUG']
end

def install_homebrew_and_packages
  brew_bin = 'brew'

  run %(which #{brew_bin})
  unless $?.success?
    puts '======================================================'
    puts "Installing Homebrew, the OSX package manager...If it's"
    puts 'already installed, this will do nothing.'
    puts '======================================================'
    run %{curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/master/install" | ruby}
  end

  puts
  puts
  puts '======================================================'
  puts 'Updating Homebrew.'
  puts '======================================================'
  run %(#{brew_bin} update)
  puts
  puts
  puts '======================================================'
  puts 'Installing Homebrew packages...There may be some warnings.'
  puts '======================================================'
  run %(#{brew_bin} bundle)
  run %(#{brew_bin} bundle)
  puts
  puts
end

def install_ubuntu_packages
  puts
  puts
  puts '======================================================'
  puts 'Installing Ubuntu Packages.'
  puts '======================================================'

  run %(mkdir -p #{ENV['HOME']}/.bin)

  run %(sudo apt -y update)
  run %(sudo apt -y install curl unzip vim)
  run %(sudo apt -y install ruby-dev build-essential libssl-dev zlib1g-dev make libbz2-dev libsqlite3-dev llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev libreadline-dev autoconf bison libyaml-dev libreadline6-dev libgdbm5 libgdbm-dev)
  run %(sudo add-apt-repository -y ppa:git-core/ppa)
  run %(sudo add-apt-repository -y ppa:fish-shell/release-2)
  run %(sudo apt -y update)
  run %(sudo apt -y upgrade)
  run %(sudo apt -y install git)
  run %(sudo apt -y install fish)
  run %(sudo apt -y install xclip fontconfig)
  run %(sudo locale-gen en_GB.UTF-8)
  run %(sudo update-locale LANG=en_GB.UTF-8)

  # run %(sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/dell-xps-9570-ubuntu-respin/master/xps-tweaks.sh)")
  run %(sudo apt -y install intel-microcode inteltool intel-gpu-tools)
  run %(sudo apt -y install gnome-software-plugin-snap gnome-software-plugin-flatpak)
  run %(sudo add-apt-repository -y ppa:yubico/stable)
  run %(sudo apt -y install yubikey-manager-qt yubioath-desktop yubikey-personalization-gui yubikey-piv-manager)
  run %(sudo apt -y install chrome-gnome-shell)
  run %(sudo apt -y install smbios-utils)
  run %(sudo smbios-thermal-ctl --set-thermal-mode=cool-bottom)
  run %(sudo apt -y install xserver-xorg-input-libinput)
  run %(sudo apt -y remove --purge xserver-xorg-input-synaptics)
  run %(sudo apt -y install i7z powertop powerstat i8kutils)

  run %(sudo add-apt-repository -y ppa:kgilmer/speed-ricer)
  run %(sudo apt -y update)
  run %(sudo apt -y install polybar compton fonts-source-code-pro-ttf i3-gaps-wm xbacklight)
  run %(curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin)
  run %(sudo apt -y install fonts-emojione python3 rofi xdotool xsel)
  run %(curl -fsSL https://raw.githubusercontent.com/UtkarshVerma/installer-scripts/master/betterlockscreen.sh | sudo bash)
  run %(sudo apt -y install bc imagemagick libjpeg-turbo8-dev libpam0g-dev libxcb-composite0 libxcb-composite0-dev libxcb-image0-dev libxcb-randr0 libxcb-util-dev libxcb-xinerama0 libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-x11-dev feh libev-dev)
  run %(curl -fsSL https://github.com/altdesktop/playerctl/releases/download/v2.1.1/playerctl-2.1.1_amd64.deb -o playerctl.deb && sudo dpkg -i playerctl.deb; rm -f playerctl.deb)
  run %(sudo apt -y install libdbus-1-dev libx11-dev libxinerama-dev libxrandr-dev libxss-dev libglib2.0-dev libpango1.0-dev libgtk-3-dev libxdg-basedir-dev libnotify-dev)
  run %(cd /tmp && git clone https://github.com/dunst-project/dunst.git && cd dunst && make dunstify && cp -f ./dunstify #{ENV['HOME']}/.bin/dunstify)
  run %(sudo apt -y install libxcb-xrm-dev checkinstall xautolock xss-lock)
  run %(sudo apt -y install fonts-inconsolata fonts-droid-fallback fonts-dejavu fonts-freefont-ttf fonts-liberation fonts-ubuntu fonts-ubuntu-font-family-console fonts-ubuntu-console fonts-noto fonts-noto-cjk fonts-croscore fonts-open-sans fonts-roboto fonts-dejavu fonts-dejavu-extra)
  run %(curl -fsSL https://raw.githubusercontent.com/rjekker/i3-battery-popup/master/i3-battery-popup -o $HOME/.bin/i3-battery-popup && chmod +x $HOME/.bin/i3-battery-popup)

  install_files Dir.glob('i3/home_configs/*') if RUBY_PLATFORM.downcase.include?('linux') && want_to_install?('i3 home configs')
  install_files Dir.glob('i3/config/*'), destination: "#{ENV['HOME']}/.config/i3", with_directories: false, prefix: '' if RUBY_PLATFORM.downcase.include?('linux') && want_to_install?('i3 configs')
  install_files Dir.glob('x11/*'), destination: "/etc/X11/xorg.conf.d", with_directories: false, prefix: '', sudo: true if RUBY_PLATFORM.downcase.include?('linux') && want_to_install?('x11 configs')
  
  run %(git clone git://github.com/i3-gnome/i3-gnome.git && cd i3-gnome && sudo make install; cd ..; rm -rf i3-gnome)

  install_files Dir.glob('systemctl/*'), destination: "/etc/systemd/system", with_directories: false, prefix: '', sudo: true if RUBY_PLATFORM.downcase.include?('linux') && want_to_install?('systemd services')
  run %(sudo systemctl daemon-reload)
  Dir.glob('systemctl/*').map { |service|
    run %(sudo systemctl start #{File.basename(service)})
    run %(sudo systemctl enable #{File.basename(service)})
  }

  puts
  puts
end

def install_pyenv
  python2_version = '2.7.17'
  python3_version = '3.7.7'

  if RUBY_PLATFORM.downcase.include?('darwin')
    run %(brew install python3)
  else
    run %(sudo apt -y install python3 python3-dev python3-pip)
  end

  run %(which pyenv)
  unless $?.success?

    puts '======================================================'
    puts 'Installing pyenv'
    puts 'already installed, this will do nothing.'
    puts '======================================================'

    run %(git clone https://github.com/pyenv/pyenv.git #{ENV['HOME']}/.pyenv)
  end

  puts
  puts
  puts '======================================================'
  puts 'Updating pyenv.'
  puts '======================================================'

  run %(cd #{ENV['HOME']}/.pyenv && git pull)
  run %(#{ENV['HOME']}/.pyenv/bin/pyenv install -s #{python2_version})
  run %(#{ENV['HOME']}/.pyenv/bin/pyenv install -s #{python3_version})
  run %(#{ENV['HOME']}/.pyenv/bin/pyenv global #{python3_version})
  run %(#{ENV['HOME']}/.pyenv/bin/pyenv rehash)

  puts
  puts
  puts '======================================================'
  puts 'Installing packages...There may be some warnings.'
  puts '======================================================'
  run %(#{ENV['HOME']}/.pyenv/shims/python -m pip install --ignore-installed --no-cache-dir --upgrade --requirement requirements.txt)
  run %(curl -fsSL https://github.com/fdw/rofimoji/releases/download/4.1.0/rofimoji-4.1.0-py3-none-any.whl -o rofimoji-4.1.0-py3-none-any.whl && #{ENV['HOME']}/.pyenv/shims/python -m pip install rofimoji-4.1.0-py3-none-any.whl; rm -f rofimoji-4.1.0-py3-none-any.whl)
  puts
  puts
end

def install_rbenv
  ruby_version = '2.7.0'

  run %(which rbenv)
  unless $?.success?

    puts '======================================================'
    puts 'Installing rbenv'
    puts 'already installed, this will do nothing.'
    puts '======================================================'

    run %(git clone https://github.com/rbenv/rbenv.git #{ENV['HOME']}/.rbenv)
    run %(cd #{ENV['HOME']}/.rbenv && src/configure && make -C src)
    run %(git clone https://github.com/rbenv/ruby-build.git #{ENV['HOME']}/.rbenv/plugins/ruby-build)
  end

  puts
  puts
  puts '======================================================'
  puts 'Updating rbenv.'
  puts '======================================================'

  run %(cd #{ENV['HOME']}/.rbenv && git pull)
  run %(cd #{ENV['HOME']}/.rbenv/plugins/ruby-build && git pull)
  run %(#{ENV['HOME']}/.rbenv/bin/rbenv install -s #{ruby_version})
  run %(#{ENV['HOME']}/.rbenv/bin/rbenv global #{ruby_version})
  run %(#{ENV['HOME']}/.rbenv/bin/rbenv rehash)

  puts
  puts
  puts '======================================================'
  puts 'Installing Gems...There may be some warnings.'
  puts '======================================================'
  run %(#{ENV['HOME']}/.rbenv/shims/gem install bundler)
  run %(#{ENV['HOME']}/.rbenv/bin/rbenv rehash)
  run %(#{ENV['HOME']}/.rbenv/shims/bundle install)
  puts
  puts

  puts
  puts
end

def install_nodenv
  node_version = '12.16.1'

  run %(which nodenv)
  unless $?.success?
    puts '======================================================'
    puts 'Installing nodenv'
    puts 'already installed, this will do nothing.'
    puts '======================================================'
    run %(git clone https://github.com/nodenv/nodenv.git #{ENV['HOME']}/.nodenv)
    run %(cd #{ENV['HOME']}/.nodenv && src/configure && make -C src)
    run %(git clone https://github.com/nodenv/node-build.git #{ENV['HOME']}/.nodenv/plugins/node-build)
  end

  puts
  puts
  puts '======================================================'
  puts 'Updating nodenv.'
  puts '======================================================'

  run %(cd #{ENV['HOME']}/.nodenv && git pull)
  run %(cd #{ENV['HOME']}/.nodenv/plugins/node-build && git pull)
  run %(#{ENV['HOME']}/.nodenv/bin/nodenv install -s #{node_version})
  run %(#{ENV['HOME']}/.nodenv/bin/nodenv global #{node_version})

  puts
  puts
  puts '======================================================'
  puts 'Installing node packages with yarn.'
  puts '======================================================'

  run %(#{ENV['HOME']}/.nodenv/shims/npm install -g yarn)
  run %(#{ENV['HOME']}/.nodenv/bin/nodenv rehash)

  run %(#{ENV['HOME']}/.nodenv/shims/yarn global add diff2html-cli i3-cycle-focus)
  run %(#{ENV['HOME']}/.nodenv/bin/nodenv rehash)

  puts
  puts
end

def install_jabba
  java_version = 'amazon-corretto@1.8.242-08.1'

  run %(which jabba)
  unless $?.success?
    puts '======================================================'
    puts 'Installing jabba'
    puts 'already installed, this will do nothing.'
    puts '======================================================'
    run %(curl -fsSL https://github.com/shyiko/jabba/raw/master/install.sh | bash)
  end

  puts
  puts
  puts '======================================================'
  puts 'Installing Java.'
  puts '======================================================'
  run %(. ~/.jabba/jabba.sh && jabba install adopt@1.8.0-242)
  run %(. ~/.jabba/jabba.sh && jabba install adopt-openj9@1.8.0-242)
  run %(. ~/.jabba/jabba.sh && jabba install graalvm@20.0.0)
  run %(. ~/.jabba/jabba.sh && jabba install #{java_version})
  run %(. ~/.jabba/jabba.sh && jabba alias default #{java_version})

  puts
  puts
end

def install_fonts
  puts '======================================================'
  puts 'Installing patched fonts for Powerline/Lightline.'
  puts 'Source: https://github.com/powerline/fonts'
  puts '======================================================'
  run %( cp -f $DOTFILES/fonts/* #{ENV['HOME']}/Library/Fonts ) if RUBY_PLATFORM.downcase.include?('darwin')
  run %( mkdir -p #{ENV['HOME']}/.fonts && cp $DOTFILES/fonts/* #{ENV['HOME']}/.fonts && fc-cache -vf #{ENV['HOME']}/.fonts ) if RUBY_PLATFORM.downcase.include?('linux')
  puts
end

def install_terminal_app_theme
  puts '======================================================'
  puts 'Restoring Terminal.app settings.'
  puts '======================================================'
  if File.exist?('terminal.app/com.apple.Terminal.plist')
    run %(defaults import #{ENV['HOME']}/Library/Preferences/com.apple.Terminal.plist terminal.app/com.apple.Terminal.plist)
  end
end

def ask(message, values)
  puts message
  loop do
    values.each_with_index { |val, idx| puts " #{idx + 1}. #{val}" }
    selection = STDIN.gets.chomp
    if (begin
          Float(selection).nil?
        rescue StandardError
          true
        end) || selection.to_i < 0 || selection.to_i > values.size + 1
      puts "ERROR: Invalid selection.\n\n"
    else
      break
    end
  end
  selection = selection.to_i - 1
  values[selection]
end

def setup_fish
  puts
  puts 'Installing Fish Enhancements...'

  tmp_dir = Dir.mktmpdir('fish-', ENV['TMPDIR'] || '/tmp')
  run %( git clone https://github.com/oh-my-fish/oh-my-fish #{tmp_dir} )
  run %( cd #{tmp_dir}; bin/install --offline --noninteractive -y )
  run %( rm -rf #{tmp_dir} )
  run %( fish -c 'omf install bobthefish' )
  run %( fish -c 'omf theme bobthefish' )

  # Other Themes
  # run %{ omf theme agnoster }
  # run %{ omf theme bobthefish }
  # run %{ omf theme ocean }
  # run %{ omf theme budspencer }

  install_files Dir.glob('shells/fish/*'), destination: "#{ENV['HOME']}/.config/fish", with_directories: false, prefix: '' if want_to_install?('Fish configs')
  install_files Dir.glob('shells/fish/configurations/*'), destination: "#{ENV['HOME']}/.config/fish/configurations", with_directories: false, prefix: '' if want_to_install?('Fish extras')

  set_default_shell('fish')
end

def set_default_shell(shell_name)
  shell_list_path =
    if RUBY_PLATFORM.downcase.include?('darwin')
      '/private/etc/shells'
    else
      '/etc/shells'
    end

  if ENV['SHELL'].include?(shell_name)
    puts "#{shell_name} is already configured as your shell of choice. Restart your session to load the new settings"
  else
    paths_to_search = ['/usr/local/bin', '/usr/bin', '/bin']
    binary_path = paths_to_search.find { |path| File.exist?("#{path}/#{shell_name}") }

    puts "Setting #{shell_name} as your default shell"
    if binary_path
      if File.readlines(shell_list_path).grep(Regexp.quote("#{binary_path}/#{shell_name}")).empty?
        puts "Adding #{shell_name} to standard shell list"
        run %( echo "#{binary_path}/#{shell_name}" | sudo tee -a #{shell_list_path} )
      end
      run %( chsh -s #{binary_path}/#{shell_name} )
    else
      puts "Could not find #{shell_name} localtion in #{paths_to_search.join(", ")}"
    end
  end
end

def want_to_install?(section, default = true)
  if ENV['ASK'] == 'true'
    puts "Would you like to install configuration files for: #{section}? [y]es, [n]o"
    STDIN.gets.chomp == 'y'
  else
    default
  end
end

def copy_files(src, dest)
  puts '======================================================'
  puts "Copying files from #{src} to #{dest} ..."
  puts '======================================================'

  run %(mkdir -p #{dest})

  run %(cp -rfv #{src}/* #{dest}/) if File.exist?(src) && File.exist?(dest)
end

def install_files(files, origin: ENV['PWD'], destination: ENV['HOME'], method: :symlink, with_directories: true, prefix: '.', sudo: false)
  maybe_sudo = if sudo
    'sudo'
  else
    ''
  end

  run %( #{maybe_sudo} mkdir -p #{ENV['HOME']}/.dotfiles.bak )
  backup_dir = Dir.mktmpdir('backup-', "#{ENV['HOME']}/.dotfiles.bak")

  files.each do |f|
    file = f.split('/').last
    source = "#{origin}/#{f}"
    target = "#{destination}/#{prefix}#{file}"

    puts "======================#{file}=============================="
    puts "Source: #{source}"
    puts "Target: #{target}"

    if File.exist?(target) && !File.symlink?(target)
      puts "[Overwriting] #{target}...leaving original at #{backup_dir}/#{file}..."
      run %( #{maybe_sudo} mkdir -p "#{backup_dir}" )
      run %( #{maybe_sudo} mv "#{target}" "#{backup_dir}/#{file}" )
    end

    if !File.directory?(source) || with_directories
      run %( #{maybe_sudo} mkdir -p "#{destination}" )
      if method == :symlink
        run %( #{maybe_sudo} ln -nfs "#{source}" "#{target}" )
      else
        run %( #{maybe_sudo} cp -f "#{source}" "#{target}" )
      end
    end

    puts '=========================================================='
    puts
  end
end

def install_term_theme
  puts '======================================================'
  puts 'Restoring iTerm2 settings.'
  puts '======================================================'
  if File.exist?('iTerm2/com.googlecode.iterm2.plist')
    run %(defaults import #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist iTerm2/com.googlecode.iterm2.plist)
  end

  puts '======================================================'
  puts 'Installing iTerm2 solarized theme.'
  puts '======================================================'
  run %( /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Light' dict" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Merge 'iTerm2/themes/Solarized-Light.itermcolors' :'Custom Color Presets':'Solarized Light'" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Dark' dict" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Merge 'iTerm2/themes/Solarized-Dark.itermcolors' :'Custom Color Presets':'Solarized Dark'" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist )

  # If iTerm2 is not installed or has never run, we can't autoinstall the profile since the plist is not there
  unless File.exist?(File.join(ENV['HOME'], '/Library/Preferences/com.googlecode.iterm2.plist'))
    puts '======================================================'
    puts 'To make sure your profile is using the solarized theme'
    puts 'Please check your settings under:'
    puts 'Preferences> Profiles> [your profile]> Colors> Load Preset..'
    puts '======================================================'
    return
  end

  # Ask the user which theme he wants to install
  message = 'Which theme would you like to apply to your iTerm2 profile?'
  color_scheme = ask message, iTerm_available_themes

  return if color_scheme == 'None'

  color_scheme_file = File.join('iTerm2/themes', "#{color_scheme}.itermcolors")

  # Ask the user on which profile he wants to install the theme
  profiles = iTerm_profile_list
  message = "I've found #{profiles.size} #{profiles.size > 1 ? 'profiles' : 'profile'} on your iTerm2 configuration, which one would you like to apply the Solarized theme to?"
  profiles << 'All'
  selected = ask message, profiles

  if selected == 'All'
    (profiles.size - 1).times { |idx| apply_theme_to_iterm_profile_idx idx, color_scheme_file }
  else
    apply_theme_to_iterm_profile_idx profiles.index(selected), color_scheme_file
  end
end

def iTerm_available_themes
  Dir['iTerm2/themes/*.itermcolors'].map { |value| File.basename(value, '.itermcolors') } << 'None'
end

def iTerm_profile_list
  profiles = []
  begin
    profiles << `/usr/libexec/PlistBuddy -c "Print :'New Bookmarks':#{profiles.size}:Name" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null`
  end while $CHILD_STATUS.exitstatus == 0
  profiles.pop
  profiles
end

def apply_theme_to_iterm_profile_idx(index, color_scheme_path)
  values = []
  16.times { |i| values << "Ansi #{i} Color" }
  values << ['Background Color', 'Bold Color', 'Cursor Color', 'Cursor Text Color', 'Foreground Color', 'Selected Text Color', 'Selection Color']
  values.flatten.each { |entry| run %( /usr/libexec/PlistBuddy -c "Delete :'New Bookmarks':#{index}:'#{entry}'" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist ) }

  run %( /usr/libexec/PlistBuddy -c "Merge '#{color_scheme_path}' :'New Bookmarks':#{index}" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist )
  run %( defaults read com.googlecode.iterm2 )
end

def success_msg(action)
  puts "Unix configs have been #{action}. Please restart your terminal."
end
