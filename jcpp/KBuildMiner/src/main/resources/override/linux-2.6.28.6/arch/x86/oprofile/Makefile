obj-$(CONFIG_OPROFILE) += oprofile.o

#DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
#		oprof.o cpu_buffer.o buffer_sync.o \
#		event_buffer.o oprofile_files.o \
#		oprofilefs.o oprofile_stats.o  \
#		timer_int.o )

# Thorsten, resolved DRIVER_OBJS and expanded addprefix
#oprofile-y				:= $(DRIVER_OBJS)
oprofile-y				:= /drivers/oprofile/oprof.o \
							/drivers/oprofile/cpu_buffer.o \
							/drivers/oprofile/buffer_sync.o \
							/drivers/oprofile/event_buffer.o \
							/drivers/oprofile/oprofile_files.o \
							/drivers/oprofile/oprofilefs.o \
							/drivers/oprofile/oprofile_stats.o \
							/drivers/oprofile/timer_int.o \
							init.o backtrace.o
oprofile-$(CONFIG_X86_LOCAL_APIC) 	+= nmi_int.o op_model_amd.o \
					   op_model_ppro.o op_model_p4.o
oprofile-$(CONFIG_X86_IO_APIC)		+= nmi_timer_int.o
