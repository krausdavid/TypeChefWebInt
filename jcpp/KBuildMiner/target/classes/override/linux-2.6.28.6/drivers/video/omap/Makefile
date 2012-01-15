#
# Makefile for the new OMAP framebuffer device driver
#

obj-$(CONFIG_FB_OMAP) += omapfb.o

objs-y := omapfb_main.o

objs-$(CONFIG_ARCH_OMAP1) += lcdc.o
objs-$(CONFIG_ARCH_OMAP2) += dispc.o

ifeq ($(CONFIG_ARCH_OMAP1),y)
objs-$(CONFIG_FB_OMAP_LCDC_EXTERNAL) += sossi.o
endif
ifeq ($(CONFIG_ARCH_OMAP2),y)
objs-$(CONFIG_FB_OMAP_LCDC_EXTERNAL) += rfbi.o
endif

objs-$(CONFIG_FB_OMAP_LCDC_HWA742) += hwa742.o
objs-$(CONFIG_FB_OMAP_LCDC_BLIZZARD) += blizzard.o

objs-$(CONFIG_MACH_OMAP_H4) += lcd_h4.o
objs-$(CONFIG_MACH_OMAP_H3) += lcd_h3.o
objs-$(CONFIG_MACH_OMAP_PALMTE) += lcd_palmte.o
objs-$(CONFIG_MACH_OMAP_PALMTT) += lcd_palmtt.o
objs-$(CONFIG_MACH_OMAP_PALMZ71) += lcd_palmz71.o

ifeq ($(CONFIG_ARCH_OMAP16XX),y)
objs-$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1610.o
endif
ifeq ($(CONFIG_ARCH_OMAP15XX),y)
objs-$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1510.o
endif

objs-$(CONFIG_MACH_OMAP_OSK) += lcd_osk.o

omapfb-objs := $(objs-y)

