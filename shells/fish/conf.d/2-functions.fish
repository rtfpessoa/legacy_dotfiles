# Helpers
function export_globally
	set -gx $argv[1] "$argv[2]"
end

function list_paths
	echo $fish_user_paths | tr " " "\n" | nl
end

function erase_path
	set --erase --universal fish_user_paths[$argv[1]]
end

function add_to_path
	if test -d "$argv[1]"
		set -gx fish_user_paths "$argv[1]" $fish_user_paths
	end
end

function varclear --description 'Remove duplicates from environment variable'
	if test (count $argv) = 1
		set -l newvar
		set -l count 0
		for v in $$argv
			if contains -- $v $newvar
				set count (math $count+1)
			else
				set newvar $newvar $v
			end
		end
		set $argv $newvar
		test $count -gt 0
		and echo Removed $count duplicates from $argv
	else
		for a in $argv
			varclear $a
		end
	end
end

function orDefault
	set -q $argv[1]
	and echo $$argv[1]
	or echo $argv[2]
end

# Create a new directory and enter it
function md
	mkdir -p "$argv"
	and cd "$argv"
end

# find shorthand
function f
	find . -name "$argv[1]" 2>&1 | grep -v 'Permission denied'
end

# Start an HTTP server from a directory, optionally specifying the port
function server --argument port
	set -q port[1]
	or set port 8000
	open "http://localhost:$port/"
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c \$'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
end

# Copy w/ progress
function cp_p --argument source --argument destination
	rsync -WavP --human-readable --progress $source $destination
end

# get gzipped size
function gz --argument target
	echo "orig size    (bytes): "
	cat "$target" | wc -c
	echo "gzipped size (bytes): "
	gzip -c "$target" | wc -c
end

# whois a domain or a URL
function whois --argument url
	set -l domain (echo "$url" | awk -F/ '{print $3}') # get domain from URL
	if test -z $domain
		domain=$url
	end
	echo "Getting whois record for: $domain ..."

	# avoid recursion
	# this is the best whois server
	# strip extra fluff
	/usr/bin/whois -h whois.internic.net $domain | sed '/NOTICE:/q'
end

function strip_diff_leading_symbols
	color_code_regex="(\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K])"
	reset_color="\x1B\[m"
	dim_magenta="\x1B\[38;05;146m"

	# simplify the unified patch diff header
	sed -r "s/^($color_code_regex)diff --git .*\$//g" | \
	  sed -r "s/^($color_code_regex)index .*\$/\n\1\$(rule)/g" | \
	  sed -r "s/^($color_code_regex)\+\+\+(.*)\$/\1+++\5\n\1\$(rule)\x1B\[m/g" | \
	  # extra color for @@ context line
	  sed -r "s/@@$reset_color $reset_color(.*\$)/@@ $dim_magenta\1/g" | \
	  # actually strips the leading symbols
	  sed -r "s/^($color_code_regex)[\+\-]/\1 /g"
end

# who is using the laptop's iSight camera?
function camerausedby
	echo "Checking to see who is using the iSight camera… 📷"
	set usedby (lsof | grep -w "AppleCamera\|USBVDC\|iSight" | awk '{printf $2"\n"}' | xargs ps)
	echo -e "Recent camera uses:\n$usedby"
end

# animated gifs from any video
# from alex sexton   gist.github.com/SlexAxton/4989674
function gifify --argument video --argument quality
	if test -n "$video"
		if $quality -eq '--good'
			ffmpeg -i $video -r 10 -vcodec png out-static-%05d.png
			time convert -verbose +dither -layers Optimize -resize 900x900\> out-static*.png GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - >$video.gif
			rm out-static*.png
		else
			ffmpeg -i $video -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 >$videos.gif
		end
	else
		echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
	end
end

# turn that video into webm.
# brew reinstall ffmpeg --with-libvpx
function webmify --argument video --argument flags
	ffmpeg -i $video -vcodec libvpx -acodec libvorbis -isync -copyts -aq 80 -threads 3 -qmax 30 -y $flags $video.webm
end
