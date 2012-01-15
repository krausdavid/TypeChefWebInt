#
# Copyright (c) 2000-2005 Silicon Graphics, Inc.
# All Rights Reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it would be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write the Free Software Foundation,
# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

EXTRA_CFLAGS +=	 -I$(src) -I$(src)/linux-2.6 -funsigned-char

XFS_LINUX := linux-2.6

ifeq ($(CONFIG_XFS_DEBUG),y)
	EXTRA_CFLAGS += -g
endif

obj-$(CONFIG_XFS_FS)		+= xfs.o

xfs-$(CONFIG_XFS_QUOTA)		+= quota/xfs_dquot.o \
				   quota/xfs_dquot_item.o \
				   quota/xfs_trans_dquot.o \
				   quota/xfs_qm_syscalls.o \
				   quota/xfs_qm_bhv.o \
				   quota/xfs_qm.o
#xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix quota/, \
#				   xfs_dquot.o \
#				   xfs_dquot_item.o \
#				   xfs_trans_dquot.o \
#				   xfs_qm_syscalls.o \
#				   xfs_qm_bhv.o \
#				   xfs_qm.o)

ifeq ($(CONFIG_XFS_QUOTA),y)
xfs-$(CONFIG_PROC_FS)		+= quota/xfs_qm_stats.o
endif

xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
xfs-$(CONFIG_PROC_FS)		+= linux-2.6/xfs_stats.o
xfs-$(CONFIG_SYSCTL)		+= linux-2.6/xfs_sysctl.o
xfs-$(CONFIG_COMPAT)		+= linux-2.6/xfs_ioctl32.o


xfs-y				+= xfs_alloc.o \
				   xfs_alloc_btree.o \
				   xfs_attr.o \
				   xfs_attr_leaf.o \
				   xfs_bit.o \
				   xfs_bmap.o \
				   xfs_bmap_btree.o \
				   xfs_btree.o \
				   xfs_buf_item.o \
				   xfs_da_btree.o \
				   xfs_dir2.o \
				   xfs_dir2_block.o \
				   xfs_dir2_data.o \
				   xfs_dir2_leaf.o \
				   xfs_dir2_node.o \
				   xfs_dir2_sf.o \
				   xfs_error.o \
				   xfs_extfree_item.o \
				   xfs_filestream.o \
				   xfs_fsops.o \
				   xfs_ialloc.o \
				   xfs_ialloc_btree.o \
				   xfs_iget.o \
				   xfs_inode.o \
				   xfs_inode_item.o \
				   xfs_iomap.o \
				   xfs_itable.o \
				   xfs_dfrag.o \
				   xfs_log.o \
				   xfs_log_recover.o \
				   xfs_mount.o \
				   xfs_mru_cache.o \
				   xfs_rename.o \
				   xfs_trans.o \
				   xfs_trans_ail.o \
				   xfs_trans_buf.o \
				   xfs_trans_extfree.o \
				   xfs_trans_inode.o \
				   xfs_trans_item.o \
				   xfs_utils.o \
				   xfs_vfsops.o \
				   xfs_vnodeops.o \
				   xfs_rw.o \
				   xfs_dmops.o \
				   xfs_qmops.o

xfs-$(CONFIG_XFS_TRACE)		+= xfs_dir2_trace.o

# Objects in linux/
xfs-y				+= linux-2.6/kmem.o \
				   linux-2.6/xfs_aops.o \
				   linux-2.6/xfs_buf.o \
				   linux-2.6/xfs_export.o \
				   linux-2.6/xfs_file.o \
				   linux-2.6/xfs_fs_subr.o \
				   linux-2.6/xfs_globals.o \
				   linux-2.6/xfs_ioctl.o \
				   linux-2.6/xfs_iops.o \
				   linux-2.6/xfs_lrw.o \
				   linux-2.6/xfs_super.o \
				   linux-2.6/xfs_vnode.o \
				   linux-2.6/xfs_xattr.o

# Objects in support/
xfs-y				+= support/debug.o \
				   support/uuid.o

xfs-$(CONFIG_XFS_TRACE)		+= support/ktrace.o

