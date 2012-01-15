#
# Makefile for the kernel security code
#

obj-$(CONFIG_KEYS)			+= keys/
# Thorsten, cleanup for my parser, since I don't care about build order... 
#subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
#subdir-$(CONFIG_SECURITY_SMACK)		+= smack
obj-$(CONFIG_SECURITY_SELINUX)	+= selinux/
obj-$(CONFIG_SECURITY_SMACK)		+= smack/

# always enable default capabilities
obj-y		+= commoncap.o

# Object file lists
obj-$(CONFIG_SECURITY)			+= security.o capability.o
obj-$(CONFIG_SECURITYFS)		+= inode.o
# Must precede capability.o in order to stack properly.

# Thorsten, see above
#obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
#obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o

obj-$(CONFIG_SECURITY_ROOTPLUG)		+= root_plug.o
obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
