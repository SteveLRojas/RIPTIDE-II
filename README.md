# RIPTIDE-II
RIPTIDE-II CPU and platform based on 8X-RIPTIDE.  
  
This project consists of the RIPTIDE-II CPU and a platform with cache controllers and an SDRAM controller. The platform also includes an RS-232 controller and a VGA graphics controller with multiple video modes.  
The RIPTIDE-II CPU is an improved version of the 8X-RIPTIDE, and is designed to support program and data caches as well as faster IO access.  
Two 4KB direct mapped cache controllers are included with the platform, as well as an SDRAM controller that is especially designed to interface with the cache controllers.  
The SDRAM controller has a dedicated port for initializing the main memory from any kind of ROM during system startup, which eliminates the need to map a ROM to the program memory space.  
While the program and data spaces remain separate, it is now possible to access and modify program memory by using the MSC (Memory Subsystem Control) module to synchronize the caches, as they both share the main memory. Data is byte addressable and is accessed in 64KB pages, while program memory is word addressable, and accessed in 128KB pages.  
Registers in the MSC can be used to set the program and data page offsets, and if desired the two pages can be set to overlap.

# Instruction Set and Assembler
The RIPTIDE-II processor has the same instruction set and encoding as the 8X-RIPTIDE processor, so the 8X-RIPTIDE assembler can be used to generate code for it.  
