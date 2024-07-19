MEMORY
{
  RAM : ORIGIN = 0x80000000, LENGTH = 0x00a00000
}

ENTRY(_boot)
SECTIONS
{
  . = 0x80000000;
  .text : {
      *(.boot)
      *(.text)
  }  > RAM

  .data : {
      . = ALIGN(4);
      *(.data);
      . = ALIGN(4);
  } > RAM

  _end = .; PROVIDE (end = .);
}
