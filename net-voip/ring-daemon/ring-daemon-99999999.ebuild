# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == *99999999* ]]; then
	inherit eutils git-r3

	EGIT_REPO_URI="https://gerrit-ring.savoirfairelinux.com/ring-daemon"
	SRC_URI=""

	IUSE="+alsa +dbus doc graph +gsm +hwaccel ipv6 jack -libav +libilbc nat-pmp +opus portaudio +pulseaudio -restbed +ringns +sdes +speex  upnp +vaapi vdpau +video +vorbis +vpx +x264 system-gnutls system-pjproject"
	KEYWORDS=""
else
	inherit eutils versionator

	COMMIT_HASH=""
	MY_SRC_P="ring_${PV}.${COMMIT_HASH}"
	SRC_URI="https://dl.ring.cx/ring-release/tarballs/${MY_SRC_P}.tar.gz"

	IUSE="+alsa +dbus doc graph +gsm +hwaccel ipv6 jack -libav +libilbc nat-pmp +opus portaudio +pulseaudio -restbed +ringns +sdes +speex upnp +vaapi vdpau +video +vorbis +vpx +x264 system-gnutls system-pjproject"
	KEYWORDS="~amd64"

	S="${WORKDIR}/ring-project/daemon"
fi

DESCRIPTION="Ring daemon"
HOMEPAGE="https://tuleap.ring.cx/projects/ring"

LICENSE="GPL-3"

SLOT="0"

RDEPEND="system-gnutls? ( >=net-libs/gnutls-3.4.14 )
	system-pjproject? ( >=net-libs/pjproject-2.5.5:2/9999 )

	>=dev-cpp/yaml-cpp-0.5.3

	>=dev-libs/boost-1.61.0
	>=dev-libs/crypto++-5.6.5
	>=dev-libs/jsoncpp-1.7.2

	>=media-libs/libsamplerate-0.1.8
	>=media-libs/libsndfile-1.0.25[-minimal]

	!libav? (	>=media-video/ffmpeg-3.1.3[encode,gsm?,iconv,libilbc?,opus?,speex?,v4l,vaapi?,vdpau?,vorbis?,vpx?,x264?,zlib] )
	libav? ( >=media-video/libav-12:0=[encode,gsm?,opus?,speex?,v4l,vaapi?,vdpau?,vorbis?,vpx?,x264?,zlib] )

	libilbc? ( media-libs/libilbc )

	>=net-libs/opendht-1.3.0
	>=sys-libs/zlib-1.2.8
		x11-libs/libva

	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	portaudio? ( >=media-libs/portaudio-19_pre20140130 )
	pulseaudio? ( media-sound/pulseaudio[alsa?,libsamplerate] )

	dbus? ( dev-libs/dbus-c++ )
	ringns? ( >=net-libs/restbed-4.5 )
	restbed? ( >=net-libs/restbed-4.5 )
	sdes? ( >=dev-libs/libpcre-8.40 )
	video? ( virtual/libudev )

	nat-pmp? ( net-libs/libnatpmp )
	upnp? ( >=net-libs/libupnp-1.6.19:= )
"

DEPEND="${RDEPEND}
	doc? (
		graph? ( app-doc/doxygen[dot] )
		!graph? ( app-doc/doxygen )
	)"

REQUIRED_USE="dbus? ( sdes )
		graph? ( doc )
		hwaccel? ( video )
		restbed? ( sdes video )
		vaapi? ( hwaccel )
		?? ( dbus restbed )"

src_configure() {
	rm -rf ../client-*
	cd contrib

	# remove folders for other OSes
	# android
	rm -r src/{asio,boost,cryptopp,ffmpeg,flac,gcrypt,gmp,gpg-error,gsm,iconv,jack,jsoncpp,libav,msgpack,natpmp,nettle,ogg,opendht,opus,pcre,portaudio,pthreads,restbed,samplerate,sndfile,speex,speexdsp,upnp,uuid,vorbis,vpx,x264,yaml-cpp,zlib}

	#gmp
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)gmp $(DEPS_gmp)\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
	#iconv
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)iconv $(DEPS_iconv)\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)iconv\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
	#nettle
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)nettle $(DEPS_nettle)\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
	#opus
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)$(DEPS_opus)\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)opus\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
	#speex; then
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)$(DEPS_speex)\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)speex\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
	#uuid
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)$(DEPS_uuid)\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)uuid\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) += \(.*\)$(DEPS_uuid)\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) += \(.*\)uuid\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
	#vpx
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)$(DEPS_vpx)\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)vpx\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
	#x264
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)x264 $(DEPS_x264)\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)x264\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
	#zlib
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)zlib $(DEPS_zlib)\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak
		sed -i.bak 's/^DEPS_\(.*\) = \(.*\)zlib\(.*\)/DEPS_\1 = \2 \3/g' src/*/rules.mak

	if use system-gnutls; then
		rm -r src/gnutls
	fi

	if use system-pjproject; then
		rm -r src/pjproject
	fi

	mkdir build
	cd build
	../bootstrap || die "Bootstrap of bundled libraries failed"

	make || die "Bundled libraries could not be compiled"

	cd ../..
	# patch jsoncpp include
	grep -rli '#include <json/json.h>' . | xargs -i@ sed -i 's/#include <json\/json.h>/#include <jsoncpp\/json\/json.h>/g' @
	./autogen.sh || die "Autogen failed"

#opensl is android stuff (OpenSLES)
	econf \
			--without-opensl \
			$(use_with alsa alsa ) \
			$(use_with dbus dbus) \
			$(use_with gsm gsm) \
			$(use_with jack jack) \
			$(use_with libilbc libilbc) \
			$(use_with nat-pmp natpmp) \
			$(use_with opus opus) \
			$(use_with portaudio portaudio) \
			$(use_with pulseaudio pulse ) \
			$(use_with restbed restcpp) \
			$(use_with sdes sdes) \
			$(use_with speex speex) \
			$(use_with speex speexdsp) \
			$(use_with upnp upnp) \
			$(use_enable doc doxygen) \
			$(use_enable graph dot) \
			$(use_enable hwaccel accel) \
			$(use_enable ipv6 ipv6) \
			$(use_enable ringns ringns) \
			$(use_enable vaapi vaapi) \
			$(use_enable video video)
		sed -i.bak 's/LIBS = \(.*\)$/LIBS = \1 -lopus /g' bin/Makefile
}

src_install() {
	use doc && HTML_DOCS=( "${S}/doc/doxygen/core-doc/" )
	use !doc && rm  "${S}"/{AUTHORS,ChangeLog,NEWS,README}
	default
	prune_libtool_files --all
}
