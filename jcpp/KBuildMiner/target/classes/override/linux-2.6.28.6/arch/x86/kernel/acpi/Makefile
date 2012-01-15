# Thorsten, commented out:
#subdir-				:= realmode

obj-$(CONFIG_ACPI)		+= boot.o
obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_rm.o wakeup_$(BITS).o

# Thorsten, ifneq -> ifdef
#ifneq ($(CONFIG_ACPI_PROCESSOR),)
ifdef CONFIG_ACPI_PROCESSOR
obj-y				+= cstate.o processor.o
endif

$(obj)/wakeup_rm.o:    $(obj)/realmode/wakeup.bin

# Thorsten, commented out:
#$(obj)/realmode/wakeup.bin: FORCE
#	$(Q)$(MAKE) $(build)=$(obj)/realmode

# Thorsten, added realmode subdir:
obj-y += realmode/
