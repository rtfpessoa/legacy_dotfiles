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

  if RUBY_PLATFORM.downcase.include?('darwin') && want_to_install?('homebrew and packages')
    install_homebrew_and_packages
  end

  install_files Dir.glob('git/*') if want_to_install?('git configs (color, aliases)')
  install_files Dir.glob('tmux/*') if want_to_install?('tmux config')
  install_file File.expand_path('vim'), "#{ENV['HOME']}/.vim" if want_to_install?('vim configuration')

  if want_to_install?('VSCode settings and keybindings')
    install_files Dir.glob('vscode/*'), destination_directory: File.join(ENV['HOME'], '.config/Code/User'), prefix: ''
  end

  install_files Dir.glob('shells/bash/runcoms/*') if want_to_install?('bash configs')
  setup_fish if want_to_install?('setup fish')

  install_fonts if want_to_install?('powerline fonts')

  if RUBY_PLATFORM.downcase.include?('darwin') && want_to_install?('Apply custom ITerm2.app settings (ex: solarized theme)')
    install_term_theme
  end
  if RUBY_PLATFORM.downcase.include?('darwin') && want_to_install?('Apply custom Terminal.app settings (ex: solarized theme)')
    install_terminal_app_theme
  end

  copy_files('macos/keyboard/layouts', "#{ENV['HOME']}/Library/Keyboard\ Layouts") if
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
  `#{cmd}` unless ENV['DRY-RUN']
end

def install_homebrew_and_packages
  brew_bin = 'brew'

  run %(which #{brew_bin})
  unless $?.success?
    puts '======================================================'
    puts "Installing Homebrew, the OSX package manager...If it's"
    puts 'already installed, this will do nothing.'
    puts '======================================================'
    run %(curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/master/install" | ruby)
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

  run %(mkdir -p #{ENV['HOME']}/.local/bin)

  run %(sudo apt -y update)
  run %(sudo apt -y install curl unzip bc)
  run %(sudo apt -y install ruby-dev build-essential libssl-dev zlib1g-dev make libbz2-dev libsqlite3-dev llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev libreadline-dev autoconf bison libyaml-dev libreadline6-dev libgdbm-dev)
  run %(sudo add-apt-repository -y ppa:git-core/ppa)
  run %(sudo add-apt-repository -y ppa:fish-shell/release-3)
  run %(sudo apt -y update)
  run %(sudo apt -y upgrade)
  run %(sudo apt -y install git)
  run %(sudo apt -y install fish)
  run %(sudo apt -y install xclip fontconfig)
  run %(sudo locale-gen en_GB.UTF-8)
  run %(sudo update-locale LANG=en_GB.UTF-8)
  run %(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest | grep -E "browser_download_url.*git-delta_.*_amd64\.deb" | cut -d : -f 2,3 | tr -d '"' | xargs -L 1 curl -fsSL -o git-delta.deb && sudo apt -y install ./git-delta.deb; rm -f git-delta.deb)

  # System tools
  run %(sudo apt -y install linux-tools-$\(uname -r\) intel-microcode intel-gpu-tools lm-sensors smbios-utils)

  # Setup swap and hibernation
  run %(swapon --show | grep "32G" || \(sudo swapoff /swapfile && sudo fallocate -l 32G /swapfile && sudo mkswap /swapfile && sudo chmod 600 /swapfile && sudo swapon /swapfile && swapon --show && bash ./linux/bin/update-hibernate\))

  # Gnome software plugins
  run %(sudo apt -y install gnome-software-plugin-snap)

  # Ammonite & Coursier (Scala)
  run %(echo "#!/usr/bin/env sh" | tee #{ENV['HOME']}/.local/bin/amm && curl -fsSL "https://github.com/lihaoyi/Ammonite/releases/download/2.2.0/2.13-2.2.0" | tee -a #{ENV['HOME']}/.local/bin/amm && chmod +x #{ENV['HOME']}/.local/bin/amm)
  run %(curl -fsSL https://git.io/coursier-cli-linux -o #{ENV['HOME']}/.local/bin/coursier && chmod u+x #{ENV['HOME']}/.local/bin/coursier)

  # Docker & K8s tools
  run %(sudo apt -y install apt-transport-https ca-certificates curl software-properties-common)
  run %(curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -)
  run %(sudo add-apt-repository -y "deb [arch=amd64] \"https://download.docker.com/linux/ubuntu\" $(lsb_release -cs) stable")
  run %(sudo apt -y install docker-ce)
  run %(sudo usermod -aG docker #{ENV['USER']})

  # Yubico
  run %(sudo add-apt-repository -y ppa:yubico/stable)
  run %(sudo apt -y install yubikey-manager-qt yubioath-desktop yubikey-personalization-gui)

  # Trackpad
  run %(sudo apt -y install xserver-xorg-input-libinput && sudo apt -y remove --purge xserver-xorg-input-synaptics)

  # Kitty terminal
  run %(curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n)
  install_file File.expand_path('kitty'), File.join(ENV['HOME'], '.config/kitty') if want_to_install?('kitty configs')

  # I3 & tools
  run %(sudo add-apt-repository -y ppa:regolith-linux/release)
  run %(sudo apt -y update)
  run %(sudo apt -y install regolith-desktop-mobile regolith-gnome-flashback regolith-rofication- regolith-look-nord i3xrocks-focused-window-name i3xrocks-net-traffic i3xrocks-volume i3xrocks-time i3xrocks-temp i3xrocks-memory i3xrocks-cpu-usage i3xrocks-battery)
  if want_to_install?('regolith i3 configs')
    install_file File.expand_path('linux/regolith/i3/config'), File.join(ENV['HOME'], '.config/regolith/i3/config')
  end
  install_files Dir.glob('linux/regolith/home/*') if want_to_install?('regolith home configs')

  # Input Sources
  languages = "[('xkb', 'gb'), ('xkb', 'pt')]"
  run %(gsettings set org.gnome.desktop.input-sources sources "#{languages}")

  # Others
  run %(sudo apt -y install policykit-1-gnome)
  if want_to_install?('polkit-1 configs')
    install_files Dir.glob('linux/polkit-1/*'), destination_directory: '/etc/polkit-1/localauthority/50-local.d', prefix: '', sudo: true
  end
  if want_to_install?('linux binaries')
    install_files Dir.glob('linux/bin/*'), destination_directory: File.join(ENV['HOME'], '.local/bin'), prefix: ''
  end
  if want_to_install?('x11 configs')
    install_files Dir.glob('linux/x11/*'), destination_directory: '/etc/X11/xorg.conf.d', prefix: '', sudo: true
  end
  if want_to_install?('systemd user configs')
    install_files Dir.glob('linux/systemd/*'), destination_directory: '/etc/systemd', prefix: '', sudo: true
  end
  if want_to_install?('spotify scaling')
    install_files Dir.glob('linux/spotify/*'), destination_directory: '/var/lib/snapd/desktop/applications', prefix: '', sudo: true
  end
  if want_to_install?('sysctl configs')
    install_files Dir.glob('linux/sysctl/*'), destination_directory: '/etc/sysctl.d', prefix: '', sudo: true
  end

  if want_to_install?('udev configs')
    install_files Dir.glob('linux/udev/*'), destination_directory: '/etc/udev/rules.d', prefix: '', sudo: true
  end
  run %(sudo usermod -aG video #{ENV['USER']})

  if want_to_install?('systemd services')
    install_files Dir.glob('linux/systemctl/*'), destination_directory: '/etc/systemd/system', prefix: '', sudo: true
  end
  run %(sudo systemctl daemon-reload)
  Dir.glob('linux/systemctl/*').map do |service|
    run %(sudo systemctl start #{File.basename(service)})
    run %(sudo systemctl enable #{File.basename(service)})
  end

  run %(curl -fsSL https://zoom.us/client/latest/zoom_amd64.deb -o zoom_amd64.deb && sudo apt -y install ./zoom_amd64.deb; rm -f zoom_amd64.deb)
  run %(sudo snap install spotify)
  run %(sudo snap install vlc)
  run %(sudo snap install code --classic)
  run %(sudo snap install intellij-idea-ultimate --classic)
  run %(sudo snap install circleci)

  # Work
  run %(sudo apt -y install openvpn)

  install_asdf if want_to_install?('asdf')

  puts
  puts
end

def install_asdf_package(package_name, global: true, version: nil, plugin_url: nil)
  if version.nil?
    version = run %(#{ENV['HOME']}/.asdf/bin/asdf latest #{package_name})
  end
  if plugin_url.nil?
    run %(#{ENV['HOME']}/.asdf/bin/asdf plugin add #{package_name})
  else
    run %(#{ENV['HOME']}/.asdf/bin/asdf plugin add #{package_name} #{plugin_url})
  end
  run %(#{ENV['HOME']}/.asdf/bin/asdf install #{package_name} #{version})
  if global == true
    run %(#{ENV['HOME']}/.asdf/bin/asdf global #{package_name} #{version})
  end
end

def install_asdf
  asdf_bin = 'asdf'

  run %(which #{asdf_bin})
  unless $?.success?
    puts '======================================================'
    puts 'Installing asdf'
    puts '======================================================'
    run %(git clone https://github.com/asdf-vm/asdf.git #{ENV['HOME']}/.asdf)
    run %(cd #{ENV['HOME']}/.asdf && git checkout "$(git describe --abbrev=0 --tags)")
  end

  puts
  puts
  puts '======================================================'
  puts 'Updating asdf.'
  puts '======================================================'
  run %(cd #{ENV['HOME']}/.asdf && git fetch --prune --tags --all --force && git checkout "$(git describe --abbrev=0 --tags)")
  puts
  puts
  puts '======================================================'
  puts 'Installing asdf packages.'
  puts '======================================================'

  run %(#{ENV['HOME']}/.asdf/bin/asdf update)

  ["bat", "doctl", "gcloud", "github-cli", "golang", "graalvm", "helm", "k9s", "kubectl", "minikube", "ripgrep", "rust", "saml2aws", "sbt", "scala", "terraform", "terraform-lsp", "vim", "yq"].map do |package_name|
    install_asdf_package package_name
  end

  install_asdf_package "jq", plugin_url:"https://github.com/AZMCode/asdf-jq.git"

  # Java
  install_asdf_package "java", global:false, version:"adoptopenjdk-8.0.275+1"
  install_asdf_package "java", global:false, version:"adoptopenjdk-11.0.9+101"
  install_asdf_package "java", version:"corretto-11.0.9.12.1"

  # Node.JS
  run %(#{ENV['HOME']}/.asdf/bin/asdf plugin add nodejs)
  run %(bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring')
  install_asdf_package "nodejs", version:"14.15.0"
  install_asdf_package "yarn"
  run %(#{ENV['HOME']}/.asdf/shims/yarn global add diff2html-cli)
  run %(#{ENV['HOME']}/.asdf/bin/asdf reshim nodejs)

  # Python
  install_asdf_package "python", global:false, version:"2.7.18"
  install_asdf_package "python", global:false, version:"3.7.9"
  run %(#{ENV['HOME']}/.asdf/bin/asdf global python 3.7.9 2.7.18)
  run %(#{ENV['HOME']}/.asdf/shims/pip3 install --ignore-installed --no-cache-dir --upgrade --requirement requirements.txt)
  run %(#{ENV['HOME']}/.asdf/bin/asdf reshim python)
  if RUBY_PLATFORM.downcase.include?('linux')
    # Rofimoji
    # Python 3 is installed above and Rofi is installed by Regolith
    run %(sudo apt -y install fonts-emojione xdotool xsel)
    run %(curl -fsSL https://api.github.com/repos/fdw/rofimoji/releases/latest | grep -E "browser_download_url.*rofimoji-.*-py3-none-any\.whl" | cut -d : -f 2,3 | tr -d '"' | xargs -L 1 curl -fsSL -o rofimoji-1.0.0-py3-none-any.whl && #{ENV['HOME']}/.asdf/shims/pip3 install --ignore-installed --no-cache-dir --upgrade ./rofimoji-1.0.0-py3-none-any.whl; rm -f rofimoji-1.0.0-py3-none-any.whl)
    run %(#{ENV['HOME']}/.asdf/bin/asdf reshim python)
  end

  # Ruby
  install_asdf_package "ruby", version:"2.7.2"
  run %(#{ENV['HOME']}/.asdf/shims/bundler install)
  run %(#{ENV['HOME']}/.asdf/bin/asdf reshim ruby)

  puts
  puts
end

def install_fonts
  puts '======================================================'
  puts 'Installing patched fonts for Powerline/Lightline.'
  puts 'Source: https://github.com/powerline/fonts'
  puts '======================================================'
  run %( cp -f $DOTFILES/fonts/* #{ENV['HOME']}/Library/Fonts ) if RUBY_PLATFORM.downcase.include?('darwin')
  if RUBY_PLATFORM.downcase.include?('linux')
    run %( mkdir -p #{ENV['HOME']}/.fonts && cp $DOTFILES/fonts/* #{ENV['HOME']}/.fonts && fc-cache -vf #{ENV['HOME']}/.fonts )
  end
  puts
end

def install_terminal_app_theme
  puts '======================================================'
  puts 'Restoring Terminal.app settings.'
  puts '======================================================'
  if File.exist?('macos/terminal.app/com.apple.Terminal.plist')
    run %(defaults import #{ENV['HOME']}/Library/Preferences/com.apple.Terminal.plist macos/terminal.app/com.apple.Terminal.plist)
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

  if want_to_install?('Fish configs')
    install_file File.expand_path('shells/fish/config.fish'), "#{ENV['HOME']}/.config/fish/config.fish"
  end
  if want_to_install?('Fish extras')
    install_files Dir.glob('shells/fish/conf.d/*'), destination_directory: "#{ENV['HOME']}/.config/fish/conf.d", prefix: ''
  end

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
      puts "Could not find #{shell_name} localtion in #{paths_to_search.join(', ')}"
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

def install_files(files, source_directory: ENV['PWD'], destination_directory: ENV['HOME'], prefix: '.', sudo: false)
  files.each do |file|
    source = File.join(source_directory, file)
    filename = "#{prefix}#{File.basename(file)}"
    destination = File.join(destination_directory, filename)

    install_file source, destination, sudo: sudo
  end
end

def install_file(source, destination, sudo: false)
  maybe_sudo = if sudo
                 'sudo'
               else
                 ''
               end

  puts '=========================================================='
  puts "Source: #{source}"
  puts "Target: #{destination}"

  destination_directory = File.dirname(destination)
  run %( #{maybe_sudo} mkdir -p "#{destination_directory}" ) unless File.exist?(destination_directory)

  run %( #{maybe_sudo} ln -nfs "#{source}" "#{destination}" )

  puts '=========================================================='
  puts
end

def install_term_theme
  puts '======================================================'
  puts 'Restoring iTerm2 settings.'
  puts '======================================================'
  if File.exist?('macos/iTerm2/com.googlecode.iterm2.plist')
    run %(defaults import #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist macos/iTerm2/com.googlecode.iterm2.plist)
  end

  puts '======================================================'
  puts 'Installing iTerm2 solarized theme.'
  puts '======================================================'
  run %( /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Light' dict" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Merge 'macos/iTerm2/themes/Solarized-Light.itermcolors' :'Custom Color Presets':'Solarized Light'" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Dark' dict" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Merge 'macos/iTerm2/themes/Solarized-Dark.itermcolors' :'Custom Color Presets':'Solarized Dark'" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist )

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

  color_scheme_file = File.join('macos/iTerm2/themes', "#{color_scheme}.itermcolors")

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
  Dir['macos/iTerm2/themes/*.itermcolors'].map { |value| File.basename(value, '.itermcolors') } << 'None'
end

def iTerm_profile_list
  profiles = []
  loop do
    profiles << `/usr/libexec/PlistBuddy -c "Print :'New Bookmarks':#{profiles.size}:Name" #{ENV['HOME']}/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null`
    break unless $CHILD_STATUS.exitstatus == 0
  end
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
