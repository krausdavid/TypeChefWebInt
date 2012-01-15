#
# Makefile for Kernel-based Virtual Machine module
#

# Thorsten, manually expanded $(addprefix...
common-objs = /virt/kvm/kvm_main.o \
			/virt/kvm/ioapic.o \
			/virt/kvm/coalesced_mmio.o \
			/virt/kvm/irq_comm.o
#common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
#                coalesced_mmio.o irq_comm.o)
ifeq ($(CONFIG_KVM_TRACE),y)
# Thorsten, same story...
#common-objs += $(addprefix ../../../virt/kvm/, kvm_trace.o)
common-objs += /virt/kvm/kvm_trace.o
endif
ifeq ($(CONFIG_DMAR),y)
# Thorsten, same story...
#common-objs += $(addprefix ../../../virt/kvm/, vtd.o)
common-objs += /virt/kvm/vtd.o
endif

EXTRA_CFLAGS += -Ivirt/kvm -Iarch/x86/kvm

# Thorsten, cleanup mistake: $(common-objs) -> common.o
#kvm-objs := $(common-objs) x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o \
kvm-objs := common.o x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o \
	i8254.o
obj-$(CONFIG_KVM) += kvm.o
kvm-intel-objs = vmx.o
obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
kvm-amd-objs = svm.o
obj-$(CONFIG_KVM_AMD) += kvm-amd.o
