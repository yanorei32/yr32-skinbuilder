#!/bin/bash

set -eu
shopt -s extglob

####################

depends=( ffmpeg curl unzip zip convert bc )
notfound=()

for app in ${depends[@]}; do
	if ! type $app > /dev/null 2>&1; then
		notfound+=($app)
	fi
done

if [[ ${#notfound[@]} -ne 0 ]]; then
	echo Failed to lookup dependency:

	for app in ${notfound[@]}; do
		echo - $app
	done

	exit 1
fi

####################

DIR=$(cd $(dirname $0) && pwd)

####################

set -x

mkdir -p "${DIR}/workdir/yr32"
cd "${DIR}/workdir"

####################

# depName=git@github.com:googlefonts/Inconsolata.git
INCONSOLATA_COMMIT="b8dbb7714534a1b60145fc46d08e7a417aa30e7d"

if [[ ! -e Inconsolata-Black.ttf ]]; then
	curl -L -s \
		--output Inconsolata-Black.ttf \
		https://github.com/googlefonts/Inconsolata/raw/${INCONSOLATA_COMMIT}/fonts/ttf/Inconsolata-Black.ttf
fi

# depName=git@github.com:sevmeyer/oxanium.git
OXANIUM_COMMIT="a8f39e0c71186190027a093e9001459410192d1e"

if [[ ! -e  Oxanium-Regular.ttf ]]; then
	curl -L -s \
		--output Oxanium-Regular.ttf \
		https://github.com/sevmeyer/oxanium/raw/${OXANIUM_COMMIT}/fonts/ttf/Oxanium-Regular.ttf
fi

###################

function generate_empty_wav() {
	if [[ ! -e empty.ogg ]]; then
		touch empty.ogg
	fi

	for f in $@; do
		cp empty.ogg yr32/$f.ogg
	done
}

function generate_empty_png() {
	if [[ ! -e empty.png ]]; then
		convert \
			-size 1x1 xc:transparent \
			empty.png
	fi

	for f in $@; do
		cp empty.png yr32/$f.png
	done
}

function generate_hit_emoji() {
	color=$1
	label=$2
	output=$3

	convert \
		-size 128x128 \
		-gravity center \
		-font "Inconsolata-Black.ttf" \
		-pointsize 64 \
		-fill white \
		-stroke $color \
		-strokewidth 4 \
		-background transparent \
		"label:$label" \
		\( \
			+clone \
			-background "#33333366" \
			-shadow 80x3+3+3 \
		\) \
		-background transparent \
		+swap \
		-layers merge \
		+repage \
		-rotate 5 \
		-trim \
		$output
}

function generate_ranking_image() {
	rankname=$1
	rankchar=$2
	color=$3
	yshift=$4

	convert \
		-size 800x1000 \
		-gravity center \
		-kerning -250 \
		-font "Oxanium-Regular.ttf" \
		-stroke '#ffffff30' \
		-strokewidth 20 \
		-pointsize 1000 \
		-fill "$color" \
		-background transparent \
		"label:$rankchar" \
		-roll ${yshift}+50 \
		\( \
			+clone \
			-background "#33333366" \
			-shadow 80x16+16+16 \
		\) \
		-background transparent \
		+swap \
		-layers merge \
		+repage \
		yr32/ranking-$rankname@2x.png

	convert \
		yr32/ranking-$rankname@2x.png \
		-resize 64x \
		yr32/ranking-$rankname-small@2x.png
}

function generate_single_char_image(){
	char=$1
	size=$2
	output=$3

	convert \
		-font "Oxanium-Regular.ttf" \
		-fill white \
		-pointsize $2 \
		-background transparent \
		"label:$char" \
		\( \
			+clone \
			-background "#33333366" \
			-shadow 80x2+2+2 \
		\) \
		-background transparent \
		+swap \
		-layers merge \
		+repage \
		$output
}

function generate_string_image() {
	size=$1
	color=$2
	left_spacing=$3
	top_spacing=$4
	label=$5
	output=$6
	convert \
		-font "Oxanium-Regular.ttf" \
		-pointsize $size \
		-fill $color \
		-background transparent \
		"label:$label" \
		\( \
			+clone \
			-background "#33333366" \
			-shadow 80x3+3+3 \
		\) \
		-background transparent \
		+swap \
		-layers merge \
		+repage \
		-trim \
		-gravity northwest \
		-splice ${left_spacing}x${top_spacing} \
		$output
}

function generate_mod_image() {
	color=$1
	label=$4
	output=$5
	convert \
		-size 128x128 \
		-font "Oxanium-Regular.ttf" \
		-pointsize 48 \
		-background $color \
		"label:$label" \
		-draw "circle 64,64 64,24" \
		\( \
			+clone \
			-background "#33333366" \
			-shadow 80x3+3+3 \
		\) \
		-background transparent \
		+swap \
		-layers merge \
		+repage \
		$output
	
}

####################

sound_prefixes=( soft normal drum )

function expand_all_prefix() {
	for f in $@; do
		for prefix in ${sound_prefixes[@]}; do
			echo $prefix-$f
		done
	done
}

####################

rm -rf yr32/*

# osu! - Skinnable Files - Detail List
#   https://docs.google.com/spreadsheets/d/1bhnV-CQRMy3Z0npQd9XSoTdkYxz0ew5e648S00qkJZ8/edit
# Browse Fonts - Google Fonts
#   https://fonts.google.com/

# osu! UI sounds
generate_empty_wav \
	shutter

# osu! UI textures
generate_empty_png \
	star2@2x \
	cursortrail@2x \
	menu-snow@2x \
	scorebar-marker@2x \
	ranking-title@2x \
	scorebar-bg@2x

convert -size 128x128 \
	xc:none \
	-fill none \
	-stroke "#ffff99cc" \
	-strokewidth 7.5 \
	-draw """
		circle 64,64 64,32
	""" \
	-stroke "#ffff99ff" \
	-strokewidth 2 \
	-draw """
		line 64,48 64,80
	""" \
	-draw """
		line 48,64 80,64
	""" \
	yr32/cursor@2x.png

convert -size 32x32 \
	xc:#50506733 \
	yr32/cursor-smoke@2x.png

convert -size 1600x220 \
	-define gradient:angle=45 \
	gradient:#606060ff-#00000000 \
	-fill none \
	-stroke "#33336666" \
	-strokewidth 5 \
	-draw """
		circle 800,-20 800,155
	""" \
	-strokewidth 10 \
	-draw """
		circle 1000,300 1000,50
	""" \
	\( \
		xc:none \
		-size 1600x220 \
		-stroke none \
		-fill white \
		-draw "roundrectangle 10,15 1400,205 10,10" \
	\) \
	-compose dst_in -composite \
	yr32/menu-button-background@2x.png

convert -size 1290x10 \
	xc:#aaaaff40 \
	yr32/scorebar-colour@2x.png

generate_ranking_image xh SS '#eeeeeeff' +0
generate_ranking_image sh S '#eeeeeeff' +0
generate_ranking_image x SS '#ffff66ff' +0
generate_ranking_image s S '#ffff66ff' +0
generate_ranking_image a A '#66bb66ff' +0
generate_ranking_image b B '#6666bbff' +0
generate_ranking_image c C '#bb66bbff' -40
generate_ranking_image d D '#bb6666ff' +0

for n in `seq 0 9`; do
	generate_single_char_image $n 64 yr32/score-$n@2x.png
done

generate_single_char_image ',' 64 yr32/score-comma@2x.png
generate_single_char_image '.' 64 yr32/score-dot@2x.png
generate_single_char_image '%' 64 yr32/score-percent@2x.png
generate_single_char_image 'x' 64 yr32/score-x@2x.png

for f in ./yr32/score-*@2x.png; do
	filename=$(basename $f)
	char=${filename#score-}
	char=${char%@2x.png}
	convert \
		yr32/score-$char@2x.png \
		-scale x32 \
		yr32/scoreentry-$char@2x.png
done

generate_string_image 192 '#eeeeeeff' 0 0 '!UNRANKED!' yr32/play-unranked@2x.png
generate_string_image 128 '#eeeeeeff' 0 0 'CLEAR' yr32/spinner-clear@2x.png
generate_string_image 192 '#eeeeeeff' 0 0 'PASS' yr32/section-pass@2x.png
generate_string_image 192 '#eeeeeeff' 0 0 'FAILURE' yr32/section-fail@2x.png
generate_string_image 96 '#eeeeeeff' 0 0 '- PERFECT -' yr32/ranking-perfect@2x.png
generate_string_image 64 '#eeeeeeff' 20 0 'combo' yr32/ranking-maxcombo@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 'accuracy' yr32/ranking-accuracy@2x.png
generate_string_image 192 '#eeeeeeff' 0 0 '3' yr32/count3@2x.png
generate_string_image 192 '#eeeeeeff' 0 0 '2' yr32/count2@2x.png
generate_string_image 192 '#eeeeeeff' 0 0 '1' yr32/count1@2x.png
generate_string_image 96 '#eeeeeeff'  0 5 '#' yr32/star@2x.png
generate_string_image 128 '#eeeeeeff' 0 0 'START' yr32/go@2x.png
generate_string_image 192 '#eeeeee99' 0 0 '>' yr32/arrow-warning@2x.png
generate_string_image 192 '#eeeeee99' 0 0 '>' yr32/arrow-pause@2x.png
generate_string_image 128 '#eeeeeeff' 0 0 '- Continue -' yr32/pause-continue@2x.png
generate_string_image 128 '#eeeeeeff' 0 0 '- Retry -' yr32/pause-retry@2x.png
generate_string_image 128 '#eeeeeeff' 0 0 '- Replay -' yr32/pause-replay@2x.png
generate_string_image 128 '#eeeeeeff' 0 0 '- Back -' yr32/pause-back@2x.png
generate_string_image 192 '#eeeeeeff' 0 0 'Skip >>' yr32/play-skip@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[EZ]' yr32/selection-mod-easy@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[NF]' yr32/selection-mod-nofail@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[HT]' yr32/selection-mod-halftime@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[HR]' yr32/selection-mod-hardrock@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[SD]' yr32/selection-mod-suddendeath@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[PF]' yr32/selection-mod-perfect@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[DT]' yr32/selection-mod-doubletime@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[NC]' yr32/selection-mod-nightcore@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[HD]' yr32/selection-mod-hidden@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[FD]' yr32/selection-mod-fadein@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[FL]' yr32/selection-mod-flashlight@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[RX]' yr32/selection-mod-relax@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[RX]' yr32/selection-mod-relax2@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[SO]' yr32/selection-mod-spunout@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[AP]' yr32/selection-mod-autoplay@2x.png
generate_string_image 64 '#eeeeeeff' 0 0 '[v2]' yr32/selection-mod-scorev2@2x.png
generate_string_image 48 '#eeeeeeff' 20 25 'spin/min' yr32/spinner-rpm@2x.png


convert -size 560x120 \
	-define gradient:angle=90 \
	gradient:#33333388-#33333333 \
	yr32/spinner-rpm@2x.png \
	-composite \
	yr32/spinner-rpm@2x.png


convert -size 1200x975 \
	-define gradient:angle=135 \
	gradient:#00003388-#00003300 \
	-fill '#ffffff33' \
	-draw "polygon 0,140 0,160 1200,160 1200,140" \
	yr32/ranking-panel@2x.png

convert -size 616x296 \
	-define gradient:angle=135 \
	gradient:#00003388-#00003300 \
	yr32/ranking-graph@2x.png

# osu! play textures
generate_empty_png \
	hit300@2x hit300g@2x hit300k@2x \
	sliderendcircle@2x \
	sliderfollowcircle@2x \
	spinner-glow@2x \
	spinner-middle@2x \
	spinner-middle2@2x \
	spinner-top@2x \
	spinner-approachcircle@2x \
	spinner-spin@2x \
	spinner-osu@2x \
	followpoint-0@2x followpoint-1@2x \
	followpoint-2@2x followpoint-3@2x \
	ready@2x

len=350
center=800
pos_x_left=$( expr $center - $len ) || true
pos_x_right=$( expr $center + $len "*" 2 )
pos_y_top=$( echo "$center-sqrt(3)*$len" | bc -l )
pos_y_bottom=$( echo "$center+sqrt(3)*$len" | bc -l )

convert -size 1600x1600 \
	xc:none \
	-fill "#00003311" \
	-stroke "#ffffff88" \
	-strokewidth 15 \
	-draw """
		circle $center,$center $center,$( expr $center + $len "*" 2 )
	""" \
	-fill "#ffffffee" \
	-stroke none \
	-draw """
		circle $center,$center $center,$( expr $center - 15 )
	""" \
	yr32/spinner-bottom@2x.png

convert -size 256x256 \
	xc:none \
	-stroke  "#ffffffdd" \
	-strokewidth 12 \
	-fill none \
	-draw "circle 128,128 128,15" \
	yr32/hitcircleoverlay@2x.png

cp yr32/hitcircleoverlay@2x.png yr32/sliderb@2x.png

convert -size 256x256 \
	xc:none \
	-stroke  "#ffffff55" \
	-strokewidth 5 \
	-fill none \
	-draw "circle 128,128 128,15" \
	yr32/approachcircle@2x.png

convert -size 256x256 \
	gradient:#00000060-#ffffff60 \
	\( \
		-size 256x256 \
		xc:none \
		-draw "circle 128,128 128,10" \
	\) \
	-compose dst_in -composite \
	yr32/hitcircle@2x.png

# plz set skin.ini [Fonts] HitCircleOverlap to size
for n in `seq 0 9`; do
	convert -size 64x64 \
		xc:none \
		-fill "#eeeeeeff" \
		-draw "circle 32,32 32,1" \
		yr32/default-$n@2x.png
done

for n in `seq 0 9`; do
	convert -size 256x8 \
		"radial-gradient:#ffffff2${n}-#ffffff00" \
		yr32/followpoint-$(expr $n + 3)@2x.png
done

len=16
center=128
pos_x_left=$( expr $center - $len - 32)
pos_x_right=$( expr $center + $len "*" 2 - 32)
pos_y_top=$( echo "$center-sqrt(3)*$len" | bc -l )
pos_y_bottom=$( echo "$center+sqrt(3)*$len" | bc -l )

convert -size 256x256 \
	xc:none \
	-fill "#ffffffaa" \
	-draw "polygon $pos_x_left,$pos_y_top $pos_x_left,$pos_y_bottom $pos_x_right,$center" \
	yr32/reversearrow@2x.png

generate_hit_emoji "#60A020" "-_¡" yr32/hit100@2x.png
generate_hit_emoji "#60A020" "-_¡" yr32/hit100k@2x.png
generate_hit_emoji "#2060A0" "-_¡" yr32/hit50@2x.png
generate_hit_emoji "#2060A0" "-_¡" yr32/hit50k@2x.png
generate_hit_emoji "#E04040" "¡_¡" yr32/hit0@2x.png

convert -size 32x32 \
	xc:none \
	-fill "#ffffff88" \
	-draw "circle 16,16 16,5" \
	yr32/sliderscorepoint@2x.png


# Set true to render slider end
if false; then
	convert -size 32x32 \
		xc:none \
		-fill "#ffffff88" \
		-draw "circle 16,16 16,0" \
		yr32/sliderendcircle@2x.png
fi


# osu! play sounds

generate_empty_wav \
	$(expand_all_prefix sliderslide) \
	$(expand_all_prefix sliderwhistle) \
	$(expand_all_prefix hitwhistle) \
	readys


ffmpeg \
	-hide_banner -loglevel error \
	-y \
	-f lavfi -i aevalsrc="random(0)-0.5:s=44100" \
	-f lavfi -i anullsrc \
	-filter_complex \
		"""
			[0]atrim=0:0.05[a0];
			[1]atrim=0:0.05[a1];
			[a0][a1]acrossfade=d=0.05,highpass=f=200,lowpass=f=5000,volume=15dB
		""" \
	normal-hitnormal.ogg

for prefix in ${sound_prefixes[@]}; do
	cp normal-hitnormal.ogg yr32/$prefix-hitnormal.ogg
done

ffmpeg \
	-hide_banner -loglevel error \
	-y \
	-f lavfi -i aevalsrc="random(0)-0.5:s=44100" \
	-f lavfi -i anullsrc \
	-filter_complex \
		"""
			[0]atrim=0:0.05[a0];
			[1]atrim=0:0.05[a1];
			[a0][a1]acrossfade=d=0.05,highpass=f=200,lowpass=f=4000,volume=10dB
		""" \
	normal-hitfinish.ogg

for prefix in ${sound_prefixes[@]}; do
	cp normal-hitfinish.ogg yr32/$prefix-hitfinish.ogg
done

ffmpeg \
	-hide_banner -loglevel error \
	-y \
	-f lavfi -i aevalsrc="random(0)-0.25:s=44100" \
	-f lavfi -i anullsrc \
	-filter_complex \
		"""
			[0]atrim=0:0.025[a0];
			[1]atrim=0:0.025[a1];
			[a0][a1]acrossfade=d=0.025,highpass=f=5000,lowpass=f=15000,volume=10dB
		""" \
	normal-slidertick.ogg

for prefix in ${sound_prefixes[@]}; do
	cp normal-slidertick.ogg yr32/$prefix-slidertick.ogg
done

ffmpeg \
	-hide_banner -loglevel error \
	-y \
	-f lavfi -i aevalsrc="random(0)-0.25:s=44100" \
	-f lavfi -i anullsrc \
	-filter_complex \
		"""
			[0]atrim=0:0.025[a0];
			[1]atrim=0:0.025[a1];
			[a0][a1]acrossfade=d=0.025,highpass=f=5000,lowpass=f=8000,volume=10dB
		""" \
	normal-hitclap.ogg

for prefix in ${sound_prefixes[@]}; do
	cp normal-hitclap.ogg yr32/$prefix-hitclap.ogg
done

ffmpeg \
	-hide_banner -loglevel error \
	-y \
	-f lavfi -i sine="frequency=2000:sample_rate=44100" \
	-f lavfi -i anullsrc \
	-filter_complex \
		"""
			[0]atrim=0:0.33[a0];
			[1]atrim=0:0.33[a1];
			[a0][a1]acrossfade=d=0.33,volume=12dB
		""" \
	yr32/combobreak.ogg

cp yr32/combobreak.ogg yr32/gos.ogg
cp yr32/combobreak.ogg yr32/spinnerbonus.ogg

ffmpeg \
	-hide_banner -loglevel error \
	-y \
	-f lavfi -i sine="frequency=1000:sample_rate=44100" \
	-f lavfi -i anullsrc \
	-filter_complex \
		"""
			[0]atrim=0:0.33[a0];
			[1]atrim=0:0.33[a1];
			[a0][a1]acrossfade=d=0.33,volume=12dB
		""" \
	yr32/count1s.ogg

cp yr32/count1s.ogg yr32/count3s.ogg
cp yr32/count1s.ogg yr32/count2s.ogg
cp yr32/combobreak.ogg yr32/count1s.ogg

ffmpeg \
	-hide_banner -loglevel error \
	-y \
	-f lavfi -i sine="frequency=2000:sample_rate=44100" \
	-f lavfi -i anullsrc \
	-f lavfi -i sine="frequency=1000:sample_rate=44100" \
	-f lavfi -i anullsrc \
	-filter_complex \
		"""
			[0]atrim=0:0.15[a0];
			[1]atrim=0:0.15[a1];
			[a0][a1]acrossfade=d=0.15[a2];

			[2]atrim=0:0.15[a3];
			[3]atrim=0:0.15[a4];
			[a3][a4]acrossfade=d=0.15[a5];

			[a2][a5]concat=n=2:v=0:a=1,volume=12dB
		""" \
	-t 1 \
	yr32/sectionpass.ogg

ffmpeg \
	-hide_banner -loglevel error \
	-y \
	-f lavfi -i sine="frequency=1000:sample_rate=44100" \
	-f lavfi -i anullsrc \
	-f lavfi -i sine="frequency=1000:sample_rate=44100" \
	-f lavfi -i anullsrc \
	-filter_complex \
		"""
			[0]atrim=0:0.15[a0];
			[1]atrim=0:0.15[a1];
			[a0][a1]acrossfade=d=0.15[a2];

			[2]atrim=0:0.15[a3];
			[3]atrim=0:0.15[a4];
			[a3][a4]acrossfade=d=0.15[a5];

			[a2][a5]concat=n=2:v=0:a=1,volume=12dB
		""" \
	-t 1 \
	yr32/sectionfail.ogg

####################

cd ./yr32


VERSION_NAME=$(git rev-parse --short HEAD)

set +u
if [[ -n "$GITHUB_REF" ]]; then
	VERSION_NAME=${GITHUB_REF##*/}

	if [[ $VERSION_NAME == "master" ]]; then
		VERSION_NAME=$(git rev-parse --short HEAD)
	fi
fi

set -u

cat "${DIR}/skin.ini" | sed s/SB_VERSION/$VERSION_NAME/g > skin.ini

cp "${DIR}/README.md" README.md
cp "${DIR}/LICENSE" LICENSE

zip -r "${DIR}/yr32-skinbuilder@$VERSION_NAME.osk" .

