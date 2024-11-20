#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=socat
PKG_VERSION:=1.8.0.0
PKG_RELEASE:=3

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=http://www.dest-unreach.org/socat/download
PKG_HASH:=e1de683dd22ee0e3a6c6bbff269abe18ab0c9d7eb650204f125155b9005faca7

PKG_MAINTAINER:=Ted Hess <thess@kitschensync.net>
PKG_LICENSE:=GPL-2.0-or-later OpenSSL
PKG_LICENSE_FILES:=COPYING COPYING.OpenSSL
PKG_CPE_ID:=cpe:/a:dest-unreach:socat

PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/socat
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libpthread +librt +SOCAT_SSL:libopenssl
  TITLE:=A multipurpose relay (SOcket CAT)
  URL:=http://www.dest-unreach.org/socat/
endef

define Package/socat/description
	SoCat (for SOcket CAT) establishes two bidirectional byte streams and
	transfers data between them.
	Data channels may be files, pipes, devices (terminal or modem, etc.), or
	sockets (Unix, IPv4, IPv6, raw, UDP, TCP, SSL). It provides forking,
	logging and tracing, different modes for interprocess communication and
	many more options.
endef

define Package/socat/config
config SOCAT_SSL
        bool "SSL support"
        depends on PACKAGE_socat
        default n
        help
          Implements SSL support in socat (using libopenssl).
endef

CONFIGURE_ARGS += \
	--disable-libwrap \
	--disable-readline \
	--enable-termios

## procan.c fails to compile when ccache is enabled
MAKE_FLAGS += CC="$(TARGET_CC_NOCACHE)"

ifneq ($(CONFIG_SOCAT_SSL),y)
  CONFIGURE_ARGS+= --disable-openssl
endif

# PowerPC has different TERMIOS bits
ifneq ($(findstring powerpc,$(CONFIG_ARCH)),)
  CONFIGURE_VARS += \
	  sc_cv_sys_crdly_shift=12 \
	  sc_cv_sys_tabdly_shift=10 \
	  sc_cv_sys_csize_shift=8
else
  CONFIGURE_VARS += \
	  sc_cv_sys_crdly_shift=9 \
	  sc_cv_sys_tabdly_shift=11 \
	  sc_cv_sys_csize_shift=4
endif

CONFIGURE_VARS += \
	sc_cv_termios_ispeed="no" \
	ac_cv_header_bsd_libutil_h=no \
	ac_cv_lib_bsd_openpty=no \
	BUILD_DATE=$(SOURCE_DATE_EPOCH)

define Package/socat/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/socat $(1)/usr/bin/
endef

$(eval $(call BuildPackage,socat))
