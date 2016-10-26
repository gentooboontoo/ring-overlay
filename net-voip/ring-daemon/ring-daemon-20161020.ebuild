# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit autotools eutils

DESCRIPTION="Ring daemon"
HOMEPAGE="https://projects.savoirfairelinux.com/projects/ring-daemon/wiki"

SRC_URI="https://dl.ring.cx/ring-release/tarballs/ring_20161020.1.42bef36.tar.gz"

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64"

IUSE="system-asio system-boost +system-cryptopp system-ffmpeg +system-flac +system-gcrypt +system-gmp +system-gpg-error +system-gsm system-iconv +system-jack +system-jsoncpp +system-msgpack +system-nettle +system-ogg +system-opendht +system-opus +system-pcre +system-portaudio +system-samplerate +system-sndfile +system-speex +system-upnp +system-vorbis +system-vpx +system-x264 +system-yaml-cpp +system-zlib system-gnutls"

DEPEND="system-asio? ( >=dev-cpp/asio-1.10.8 )
	system-boost? ( >=dev-libs/boost-1.56.0 )
	system-cryptopp? ( >=dev-libs/crypto++-5.6.5 )
	system-ffmpeg? ( >=media-video/ffmpeg-3.1.3[v4l,vaapi,vdpau] )
	system-flac? ( >=media-libs/flac-1.3.0 )
	system-gcrypt? ( >=dev-libs/libgcrypt-1.6.5 )
	system-gmp? ( >=dev-libs/gmp-6.1.0 )
	system-gpg-error? ( >=dev-libs/libgpg-error-1.15 )
	system-gsm? ( >=media-sound/gsm-1.0.13 )
	system-iconv? ( >=dev-libs/libiconv-1.14 )
	system-jack? ( >=media-sound/jack-audio-connection-kit-0.121.3 )
	system-jsoncpp? ( >=dev-libs/jsoncpp-1.7.2 )
	system-msgpack? ( >=dev-libs/msgpack-1.1.0 )
	system-nettle? ( >=dev-libs/nettle-3.1 )
	system-ogg? ( >=media-libs/libogg-1.3.1 )
	system-opendht? ( >=net-libs/opendht-0.6.3 )
	system-opus? ( >=media-libs/opus-1.1.2 )
	system-portaudio? ( >=media-libs/portaudio-19_pre20140130 )
	system-samplerate? ( >=media-libs/libsamplerate-0.1.8 )
	system-sndfile? ( >=media-libs/libsndfile-1.0.25 )
	system-speex? ( >=media-libs/speex-1.0.5 )
	system-upnp? ( >=net-libs/libupnp-1.6.19 )
	system-vorbis? ( >=media-libs/libvorbis-1.3.4 )
	system-vpx? ( >=media-libs/libvpx-1.6.0 )
	system-x264? ( >=media-libs/x264-0.0.20140308 )
	system-yaml-cpp? ( >=dev-cpp/yaml-cpp-0.5.1 )
	system-zlib? ( >=sys-libs/zlib-1.2.8 )
	system-gnutls? ( >=net-libs/gnutls-3.4.14 )
	dev-libs/dbus-c++
	x11-libs/libva"

# msgpack commit equals 2.0.0 but it only tests for 1.1
# boost should be at 1.61

#	system-pjproject? (
#		>=net-libs/pjproject-2.4.5[-oss,-alsa,-sdl,-ffmpeg,-v4l2,-openh264,-libyuv,portaudio,-speex,-g711,-l16,-gsm,-g722,-g7221,-ilbc,-amr,-silk,-resample,ssl]
#                >=net-libs/gnutls-3.4.14 )


# restbed
# speexdsp
# uuid

RDEPEND="${DEPEND}"

S=${WORKDIR}/ring-project/daemon/

src_configure() {
	cd contrib

	# remove folders for other OSes
	#android
	rm -r src/natpmp
	rm -r src/libav

	if use system-asio; then
		die "asio blocked by restbed"
		rm -r src/asio
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)asio\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
	fi

	if ! use system-boost; then
		# boost is failing with a compilation error
		# patch boost
		sed -i.bak 's/\.\/b2/\.\/b2 --ignore-site-config /g' src/boost/rules.mak
	fi
	if use system-boost; then
		rm -r src/boost
	fi

	if use system-cryptopp; then
		rm -r src/cryptopp
	fi

	if use system-ffmpeg; then
		rm -r src/ffmpeg
	fi

	if use system-flac; then
		rm -r src/flac
	fi

	if use system-gcrypt; then
		rm -r src/gcrypt
	fi

	if ! use system-gmp; then
		export ABI=64 # check the gmp ebuild how to adapt for different platforms
	fi

	if use system-gmp; then
		rm -r src/gmp
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)gmp $(DEPS_gmp)\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
	fi

	if use system-gpg-error; then
		rm -r src/gpg-error
	fi

	if use system-gsm; then
		rm -r src/gsm
	fi

	if use system-iconv; then
		rm -r src/iconv
	fi

	if use system-jsoncpp; then
		rm -r src/jsoncpp
	fi

	if use system-msgpack; then
		rm -r src/msgpack
	fi

	if use system-nettle; then
		rm -r src/nettle
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)nettle $(DEPS_nettle)\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
	fi

	if use system-ogg; then
		rm -r src/ogg
	fi

	if use system-opendht; then
		rm -r src/opendht
	fi

	if use system-opus; then
		rm -r src/opus
	fi

	if use system-pcre; then
		rm -r src/pcre
	fi

	if use system-portaudio; then
		rm -r src/portaudio
	fi

	if use system-samplerate; then
		rm -r src/samplerate
	fi

	if use system-sndfile; then
		rm -r src/sndfile
	fi

	if use system-speex; then
		rm -r src/speex
	fi

	if use system-upnp; then
		rm -r src/upnp
	fi

	if use system-vorbis; then
		rm -r src/vorbis
	fi

	if use system-vpx; then
		rm -r src/vpx
	fi

	if use system-x264; then
		rm -r src/x264
	fi

	if use system-yaml-cpp; then
		rm -r src/yaml-cpp
	fi

	if use system-zlib; then
		rm -r src/zlib
	fi

	if use system-gnutls; then
		rm -r src/gnutls
	fi

	mkdir build
	cd build
	../bootstrap

	make

	cd ../..
	# patch jsoncpp include
	grep -rli '#include <json/json.h>' . | xargs -i@ sed -i 's/#include <json\/json.h>/#include <jsoncpp\/json\/json.h>/g' @
	./autogen.sh

	./configure --prefix=/usr
	sed -i.bak 's/LIBS = \(.*\)$/LIBS = \1 -lopus /g' bin/Makefile
}

src_compile() {
	emake
}

# add a log warning if
# system-ffmpeg overwriting a patched dep I hope you know what you are doing
