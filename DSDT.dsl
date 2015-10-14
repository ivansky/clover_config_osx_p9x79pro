DefinitionBlock ("DSDT.aml", "DSDT", 2, "ALASKA", "A M I", 0x00000006)
{
    Name (SP1O, 0x2E)
    Name (IO1B, Zero)
    Name (IO1L, Zero)
    Name (IO2B, Zero)
    Name (IO2L, Zero)
    Name (IO3B, 0x0290)
    Name (IO3L, 0x10)
    Name (IOES, Zero)
    Name (WKTP, Zero)
    Name (SPIO, 0x2E)
    Name (IOHW, 0x0290)
    Name (IOSB, Zero)
    Name (IOSL, 0x10)
    Name (IOHB, 0x0290)
    Name (IOHL, 0x10)
    Name (PSTE, Zero)
    Name (TSTE, Zero)
    Name (PETE, Zero)
    Name (TCBR, 0xFED08000)
    Name (TCLT, 0x1000)
    Name (SRCB, 0xFED1C000)
    Name (SRCL, 0x4000)
    Name (SUSW, 0xFF)
    Name (PMBS, 0x0400)
    Name (PMLN, 0x80)
    Name (SMIP, 0xB2)
    Name (APCB, 0xFEC00000)
    Name (APCL, 0x00100000)
    Name (PM30, 0x0430)
    Name (SMBS, 0x1180)
    Name (SMBL, 0x20)
    Name (HPTB, 0xFED00000)
    Name (HPTC, 0xFED1F404)
    Name (GPBS, 0x0500)
    Name (GPLN, 0x80)
    Name (PEBS, 0xE0000000)
    Name (LAPB, 0xFEE00000)
    Name (LAPL, 0x00100000)
    Name (ACPH, 0xDE)
    Name (ASSB, Zero)
    Name (AOTB, Zero)
    Name (AAXB, Zero)
    Name (SHPC, Zero)
    Name (PEPM, One)
    Name (PECS, One)
    Name (ITKE, Zero)
    Name (MBEC, 0xFFFF)
    Name (AMWV, 0x09)
    Name (PEER, Zero)
    Name (PEHP, Zero)
    Name (PICM, Zero)
    Method (_PIC, 1, NotSerialized)  // _PIC: Interrupt Model
    {
        If (Arg0)
        {
            DBG8 = 0xAA
        }
        Else
        {
            DBG8 = 0xAC
        }
        PICM = Arg0
    }
    Name (OSVR, Ones)
    Method (OSFL, 0, NotSerialized)
    {
        If ((OSVR != Ones))
        {
            Return (OSVR) /* \OSVR */
        }
        If ((PICM == Zero))
        {
            DBG8 = 0xAC
        }
        OSVR = One
        If (CondRefOf (_OSI, Local0))
        {
            If (_OSI ("Linux"))
            {
                OSVR = 0x03
            }
            If (_OSI ("Windows 2001"))
            {
                OSVR = 0x04
            }
            If (_OSI ("Windows 2001.1"))
            {
                OSVR = 0x05
            }
            If (_OSI ("FreeBSD"))
            {
                OSVR = 0x06
            }
            If (_OSI ("HP-UX"))
            {
                OSVR = 0x07
            }
            If (_OSI ("OpenVMS"))
            {
                OSVR = 0x08
            }
            If (_OSI ("Windows 2001 SP1"))
            {
                OSVR = 0x09
            }
            If (_OSI ("Windows 2001 SP2"))
            {
                OSVR = 0x0A
            }
            If (_OSI ("Windows 2001 SP3"))
            {
                OSVR = 0x0B
            }
            If (_OSI ("Windows 2006"))
            {
                OSVR = 0x0C
            }
            If (_OSI ("Windows 2006 SP1"))
            {
                OSVR = 0x0D
            }
            If (_OSI ("Windows 2009"))
            {
                OSVR = 0x0E
            }
        }
        Else
        {
            If (MCTH (_OS, "Microsoft Windows NT"))
            {
                OSVR = Zero
            }
            If (MCTH (_OS, "Microsoft Windows"))
            {
                OSVR = One
            }
            If (MCTH (_OS, "Microsoft WindowsME: Millennium Edition"))
            {
                OSVR = 0x02
            }
            If (MCTH (_OS, "Linux"))
            {
                OSVR = 0x03
            }
            If (MCTH (_OS, "FreeBSD"))
            {
                OSVR = 0x06
            }
            If (MCTH (_OS, "HP-UX"))
            {
                OSVR = 0x07
            }
            If (MCTH (_OS, "OpenVMS"))
            {
                OSVR = 0x08
            }
        }
        Return (OSVR) /* \OSVR */
    }
    Method (MCTH, 2, NotSerialized)
    {
        If ((SizeOf (Arg0) < SizeOf (Arg1)))
        {
            Return (Zero)
        }
        Local0 = (SizeOf (Arg0) + One)
        Name (BUF0, Buffer (Local0) {})
        Name (BUF1, Buffer (Local0) {})
        BUF0 = Arg0
        BUF1 = Arg1
        While (Local0)
        {
            Local0--
            If ((DerefOf (Index (BUF0, Local0)) != DerefOf (Index (BUF1, Local0
                ))))
            {
                Return (Zero)
            }
        }
        Return (One)
    }
    Name (PRWP, Package (0x02)
    {
        Zero, 
        Zero
    })
    Method (GPRW, 2, NotSerialized)
    {
        Index (PRWP, Zero) = Arg0
        Local0 = (SS1 << One)
        Local0 |= (SS2 << 0x02)
        Local0 |= (SS3 << 0x03)
        Local0 |= (SS4 << 0x04)
        If (((One << Arg1) & Local0))
        {
            Index (PRWP, One) = Arg1
        }
        Else
        {
            Local0 >>= One
            If (((OSFL () == One) || (OSFL () == 0x02)))
            {
                FindSetLeftBit (Local0, Index (PRWP, One))
            }
            Else
            {
                FindSetRightBit (Local0, Index (PRWP, One))
            }
        }
        Return (PRWP) /* \PRWP */
    }
    Name (WAKP, Package (0x02)
    {
        Zero, 
        Zero
    })
    OperationRegion (DEB0, SystemIO, 0x80, One)
    Field (DEB0, ByteAcc, NoLock, Preserve)
    {
        DBG8,   8
    }
    OperationRegion (DEB1, SystemIO, 0x90, 0x02)
    Field (DEB1, WordAcc, NoLock, Preserve)
    {
        DBG9,   16
    }
    Name (SS1, One)
    Name (SS2, Zero)
    Name (SS3, One)
    Name (SS4, One)
    Name (IOST, 0x0000)
    Name (TOPM, 0x00000000)
    Name (ROMS, 0xFFE00000)
    Name (VGAF, One)
    Scope (_SB)
    {
        Name (PR00, Package (0x26)
        {
            Package (0x04)
            {
                0x001FFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                LNKH, 
                Zero
            }, 
            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                LNKG, 
                Zero
            }, 
            Package (0x04)
            {
                0x0016FFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0x0016FFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0x0016FFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0x0011FFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0x0011FFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0x0011FFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0x0011FFFF, 
                0x03, 
                LNKD, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                Zero
            }, 
            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0x0001FFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                LNKD, 
                Zero
            }, 
            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0x0002FFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0x0002FFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0x0002FFFF, 
                0x03, 
                LNKD, 
                Zero
            }, 
            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0x0003FFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                LNKD, 
                Zero
            }, 
            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0x0004FFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0x0004FFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0x0004FFFF, 
                0x03, 
                LNKD, 
                Zero
            }, 
            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0x001FFFFF, 
                One, 
                LNKE, 
                Zero
            }, 
            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0x001CFFFF, 
                One, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0x001CFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0x001CFFFF, 
                0x03, 
                LNKD, 
                Zero
            }, 
            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                LNKH, 
                Zero
            }
        })
        Name (AR00, Package (0x26)
        {
            Package (0x04)
            {
                0x001FFFFF, 
                0x02, 
                Zero, 
                0x12
            }, 
            Package (0x04)
            {
                0x001AFFFF, 
                Zero, 
                Zero, 
                0x17
            }, 
            Package (0x04)
            {
                0x001BFFFF, 
                Zero, 
                Zero, 
                0x16
            }, 
            Package (0x04)
            {
                0x0016FFFF, 
                Zero, 
                Zero, 
                0x10
            }, 
            Package (0x04)
            {
                0x0016FFFF, 
                0x02, 
                Zero, 
                0x12
            }, 
            Package (0x04)
            {
                0x0016FFFF, 
                One, 
                Zero, 
                0x11
            }, 
            Package (0x04)
            {
                0x0011FFFF, 
                Zero, 
                Zero, 
                0x10
            }, 
            Package (0x04)
            {
                0x0011FFFF, 
                One, 
                Zero, 
                0x11
            }, 
            Package (0x04)
            {
                0x0011FFFF, 
                0x02, 
                Zero, 
                0x12
            }, 
            Package (0x04)
            {
                0x0011FFFF, 
                0x03, 
                Zero, 
                0x13
            }, 
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x18
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x19
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x19
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x19
            }, 
            Package (0x04)
            {
                0x0001FFFF, 
                Zero, 
                Zero, 
                0x1B
            }, 
            Package (0x04)
            {
                0x0001FFFF, 
                One, 
                Zero, 
                0x1E
            }, 
            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                Zero, 
                0x1C
            }, 
            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                Zero, 
                0x1D
            }, 
            Package (0x04)
            {
                0x0002FFFF, 
                Zero, 
                Zero, 
                0x21
            }, 
            Package (0x04)
            {
                0x0002FFFF, 
                One, 
                Zero, 
                0x25
            }, 
            Package (0x04)
            {
                0x0002FFFF, 
                0x02, 
                Zero, 
                0x26
            }, 
            Package (0x04)
            {
                0x0002FFFF, 
                0x03, 
                Zero, 
                0x24
            }, 
            Package (0x04)
            {
                0x0003FFFF, 
                Zero, 
                Zero, 
                0x29
            }, 
            Package (0x04)
            {
                0x0003FFFF, 
                One, 
                Zero, 
                0x2D
            }, 
            Package (0x04)
            {
                0x0003FFFF, 
                0x02, 
                Zero, 
                0x2E
            }, 
            Package (0x04)
            {
                0x0003FFFF, 
                0x03, 
                Zero, 
                0x2C
            }, 
            Package (0x04)
            {
                0x0004FFFF, 
                Zero, 
                Zero, 
                0x1F
            }, 
            Package (0x04)
            {
                0x0004FFFF, 
                One, 
                Zero, 
                0x27
            }, 
            Package (0x04)
            {
                0x0004FFFF, 
                0x02, 
                Zero, 
                0x1F
            }, 
            Package (0x04)
            {
                0x0004FFFF, 
                0x03, 
                Zero, 
                0x27
            }, 
            Package (0x04)
            {
                0x001FFFFF, 
                Zero, 
                Zero, 
                0x12
            }, 
            Package (0x04)
            {
                0x001FFFFF, 
                One, 
                Zero, 
                0x14
            }, 
            Package (0x04)
            {
                0x001CFFFF, 
                Zero, 
                Zero, 
                0x11
            }, 
            Package (0x04)
            {
                0x001CFFFF, 
                One, 
                Zero, 
                0x10
            }, 
            Package (0x04)
            {
                0x001CFFFF, 
                0x02, 
                Zero, 
                0x12
            }, 
            Package (0x04)
            {
                0x001CFFFF, 
                0x03, 
                Zero, 
                0x13
            }, 
            Package (0x04)
            {
                0x0019FFFF, 
                Zero, 
                Zero, 
                0x12
            }, 
            Package (0x04)
            {
                0x001DFFFF, 
                Zero, 
                Zero, 
                0x17
            }
        })
        Name (PR11, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                Zero
            }
        })
        Name (AR11, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x10
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x11
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x12
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x13
            }
        })
        Name (PR12, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKD, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKA, 
                Zero
            }
        })
        Name (AR12, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x11
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x12
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x13
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x10
            }
        })
        Name (PR13, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKD, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKB, 
                Zero
            }
        })
        Name (AR13, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x12
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x13
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x10
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x11
            }
        })
        Name (PR14, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKD, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKA, 
                Zero
            }
        })
        Name (AR14, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x13
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x10
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x11
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x12
            }
        })
        Name (PR15, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                Zero
            }
        })
        Name (AR15, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x10
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x11
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x12
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x13
            }
        })
        Name (PR17, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKD, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKB, 
                Zero
            }
        })
        Name (AR17, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x12
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x13
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x10
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x11
            }
        })
        Name (PR18, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKD, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKC, 
                Zero
            }
        })
        Name (AR18, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x13
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x10
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x11
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x12
            }
        })
        Name (PR21, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                Zero
            }
        })
        Name (AR21, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x1A
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x1C
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x1D
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x1E
            }
        })
        Name (PR23, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                Zero
            }
        })
        Name (AR23, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x20
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x24
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x25
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x26
            }
        })
        Name (PR27, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                Zero
            }
        })
        Name (AR27, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x28
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x2C
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x2D
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x2E
            }
        })
        Name (PR29, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                LNKA, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                LNKB, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                Zero
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                Zero
            }
        })
        Name (AR29, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                Zero, 
                Zero, 
                0x2A
            }, 
            Package (0x04)
            {
                0xFFFF, 
                One, 
                Zero, 
                0x2D
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                Zero, 
                0x2C
            }, 
            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                Zero, 
                0x2E
            }
        })
        Name (PRSA, ResourceTemplate ()
        {
            IRQ (Level, ActiveLow, Shared, )
                {3,4,5,6,7,10,11,12,14,15}
        })
        Alias (PRSA, PRSB)
        Name (PRSC, ResourceTemplate ()
        {
            IRQ (Level, ActiveLow, Shared, )
                {3,4,5,6,10,11,12,14,15}
        })
        Alias (PRSC, PRSD)
        Alias (PRSA, PRSE)
        Alias (PRSA, PRSF)
        Alias (PRSA, PRSG)
        Alias (PRSA, PRSH)
        Device (PCI0)
        {
            Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
            Name (_ADR, Zero)  // _ADR: Address
            Method (^BN00, 0, NotSerialized)
            {
                Return (Zero)
            }
            Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
            {
                Return (BN00 ())
            }
            Name (_UID, Zero)  // _UID: Unique ID
            Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
            {
                If (PICM)
                {
                    Return (AR00) /* \_SB_.AR00 */
                }
                Return (PR00) /* \_SB_.PR00 */
            }
            Name (CPRB, One)
            Name (STAV, 0x0F)
            Name (LVGA, 0x01)
            Name (BRB, 0x0000)
            Name (BRL, 0x00FF)
            Name (IOB, 0x1000)
            Name (IOL, 0xF000)
            Name (MBB, 0xD0000000)
            Name (MBL, 0x2C000000)
            Name (MABL, 0x00000000)
            Name (MABH, 0x00000000)
            Name (MALL, 0x00000000)
            Name (MALH, 0x00000000)
            Name (MAML, 0x00000000)
            Name (MAMH, 0x00000000)
            Name (CRS1, ResourceTemplate ()
            {
                WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                    0x0000,             // Granularity
                    0x0000,             // Range Minimum
                    0x007F,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x0080,             // Length
                    ,, _Y00)
                IO (Decode16,
                    0x0CF8,             // Range Minimum
                    0x0CF8,             // Range Maximum
                    0x01,               // Alignment
                    0x08,               // Length
                    )
                WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x0000,             // Granularity
                    0x0000,             // Range Minimum
                    0x03AF,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x03B0,             // Length
                    ,, , TypeStatic)
                WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x0000,             // Granularity
                    0x03E0,             // Range Minimum
                    0x0CF7,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x0918,             // Length
                    ,, , TypeStatic)
                WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x0000,             // Granularity
                    0x0000,             // Range Minimum
                    0x0000,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x0001,             // Length
                    ,, _Y02, TypeStatic)
                WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x0000,             // Granularity
                    0x0D00,             // Range Minimum
                    0x0FFF,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x0300,             // Length
                    ,, _Y01, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x00000000,         // Range Minimum
                    0x00000000,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00000001,         // Length
                    ,, _Y03, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x000C0000,         // Range Minimum
                    0x000DFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00020000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x02000000,         // Range Minimum
                    0xFFDFFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0xFDE00000,         // Length
                    ,, _Y04, AddressRangeMemory, TypeStatic)
                QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x0000000000000000, // Granularity
                    0x0000000000000000, // Range Minimum
                    0x0000000000000000, // Range Maximum
                    0x0000000000000000, // Translation Offset
                    0x0000000000000001, // Length
                    ,, _Y05, AddressRangeMemory, TypeStatic)
            })
            Name (CRS2, ResourceTemplate ()
            {
                WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                    0x0000,             // Granularity
                    0x0080,             // Range Minimum
                    0x00FF,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x0080,             // Length
                    ,, _Y06)
                WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x0000,             // Granularity
                    0x0000,             // Range Minimum
                    0x0000,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x0001,             // Length
                    ,, _Y08, TypeStatic)
                WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                    0x0000,             // Granularity
                    0x0000,             // Range Minimum
                    0x0000,             // Range Maximum
                    0x0000,             // Translation Offset
                    0x0001,             // Length
                    ,, _Y07, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x00000000,         // Range Minimum
                    0x00000000,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00000001,         // Length
                    ,, _Y09, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x80000000,         // Range Minimum
                    0xFFFFFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x80000000,         // Length
                    ,, _Y0A, AddressRangeMemory, TypeStatic)
                QWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x0000000000000000, // Granularity
                    0x0000000000000000, // Range Minimum
                    0x0000000000000000, // Range Maximum
                    0x0000000000000000, // Translation Offset
                    0x0000000000000001, // Length
                    ,, _Y0B, AddressRangeMemory, TypeStatic)
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (STAV) /* \_SB_.PCI0.STAV */
            }
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                If (CPRB)
                {
                    CreateWordField (CRS1, \_SB.PCI0._Y00._MIN, MIN0)  // _MIN: Minimum Base Address
                    CreateWordField (CRS1, \_SB.PCI0._Y00._MAX, MAX0)  // _MAX: Maximum Base Address
                    CreateWordField (CRS1, \_SB.PCI0._Y00._LEN, LEN0)  // _LEN: Length
                    MIN0 = BRB /* \_SB_.PCI0.BRB_ */
                    LEN0 = BRL /* \_SB_.PCI0.BRL_ */
                    Local0 = LEN0 /* \_SB_.PCI0._CRS.LEN0 */
                    MAX0 = (MIN0 + Local0--)
                    CreateWordField (CRS1, \_SB.PCI0._Y01._MIN, MIN1)  // _MIN: Minimum Base Address
                    CreateWordField (CRS1, \_SB.PCI0._Y01._MAX, MAX1)  // _MAX: Maximum Base Address
                    CreateWordField (CRS1, \_SB.PCI0._Y01._LEN, LEN1)  // _LEN: Length
                    If ((IOB == 0x1000))
                    {
                        Local0 = IOL /* \_SB_.PCI0.IOL_ */
                        MAX1 = (IOB + Local0--)
                        Local0 = (MAX1 - MIN1) /* \_SB_.PCI0._CRS.MIN1 */
                        LEN1 = (Local0 + One)
                    }
                    Else
                    {
                        MIN1 = IOB /* \_SB_.PCI0.IOB_ */
                        LEN1 = IOL /* \_SB_.PCI0.IOL_ */
                        Local0 = LEN1 /* \_SB_.PCI0._CRS.LEN1 */
                        MAX1 = (MIN1 + Local0--)
                    }
                    If (((LVGA == One) || (LVGA == 0x55)))
                    {
                        If (VGAF)
                        {
                            CreateWordField (CRS1, \_SB.PCI0._Y02._MIN, IMN1)  // _MIN: Minimum Base Address
                            CreateWordField (CRS1, \_SB.PCI0._Y02._MAX, IMX1)  // _MAX: Maximum Base Address
                            CreateWordField (CRS1, \_SB.PCI0._Y02._LEN, ILN1)  // _LEN: Length
                            IMN1 = 0x03B0
                            IMX1 = 0x03DF
                            ILN1 = 0x30
                            CreateDWordField (CRS1, \_SB.PCI0._Y03._MIN, VMN1)  // _MIN: Minimum Base Address
                            CreateDWordField (CRS1, \_SB.PCI0._Y03._MAX, VMX1)  // _MAX: Maximum Base Address
                            CreateDWordField (CRS1, \_SB.PCI0._Y03._LEN, VLN1)  // _LEN: Length
                            VMN1 = 0x000A0000
                            VMX1 = 0x000BFFFF
                            VLN1 = 0x00020000
                            VGAF = Zero
                        }
                    }
                    CreateDWordField (CRS1, \_SB.PCI0._Y04._MIN, MIN3)  // _MIN: Minimum Base Address
                    CreateDWordField (CRS1, \_SB.PCI0._Y04._MAX, MAX3)  // _MAX: Maximum Base Address
                    CreateDWordField (CRS1, \_SB.PCI0._Y04._LEN, LEN3)  // _LEN: Length
                    MIN3 = MBB /* \_SB_.PCI0.MBB_ */
                    LEN3 = MBL /* \_SB_.PCI0.MBL_ */
                    Local0 = LEN3 /* \_SB_.PCI0._CRS.LEN3 */
                    MAX3 = (MIN3 + Local0--)
                    If ((MALH || MALL))
                    {
                        CreateDWordField (CRS1, \_SB.PCI0._Y05._MIN, MN8L)  // _MIN: Minimum Base Address
                        Local0 = (0xB4 + 0x04)
                        CreateDWordField (CRS1, Local0, MN8H)
                        MN8L = MABL /* \_SB_.PCI0.MABL */
                        MN8H = MABH /* \_SB_.PCI0.MABH */
                        CreateDWordField (CRS1, \_SB.PCI0._Y05._MAX, MX8L)  // _MAX: Maximum Base Address
                        Local1 = (0xBC + 0x04)
                        CreateDWordField (CRS1, Local1, MX8H)
                        CreateDWordField (CRS1, \_SB.PCI0._Y05._LEN, LN8L)  // _LEN: Length
                        Local2 = (0xCC + 0x04)
                        CreateDWordField (CRS1, Local2, LN8H)
                        MN8L = MABL /* \_SB_.PCI0.MABL */
                        MN8H = MABH /* \_SB_.PCI0.MABH */
                        LN8L = MALL /* \_SB_.PCI0.MALL */
                        LN8H = MALH /* \_SB_.PCI0.MALH */
                        MX8L = MAML /* \_SB_.PCI0.MAML */
                        MX8H = MAMH /* \_SB_.PCI0.MAMH */
                    }
                    Return (CRS1) /* \_SB_.PCI0.CRS1 */
                }
                Else
                {
                    CreateWordField (CRS2, \_SB.PCI0._Y06._MIN, MIN2)  // _MIN: Minimum Base Address
                    CreateWordField (CRS2, \_SB.PCI0._Y06._MAX, MAX2)  // _MAX: Maximum Base Address
                    CreateWordField (CRS2, \_SB.PCI0._Y06._LEN, LEN2)  // _LEN: Length
                    MIN2 = BRB /* \_SB_.PCI0.BRB_ */
                    LEN2 = BRL /* \_SB_.PCI0.BRL_ */
                    Local1 = LEN2 /* \_SB_.PCI0._CRS.LEN2 */
                    MAX2 = (MIN2 + Local1--)
                    CreateWordField (CRS2, \_SB.PCI0._Y07._MIN, MIN4)  // _MIN: Minimum Base Address
                    CreateWordField (CRS2, \_SB.PCI0._Y07._MAX, MAX4)  // _MAX: Maximum Base Address
                    CreateWordField (CRS2, \_SB.PCI0._Y07._LEN, LEN4)  // _LEN: Length
                    MIN4 = IOB /* \_SB_.PCI0.IOB_ */
                    LEN4 = IOL /* \_SB_.PCI0.IOL_ */
                    Local1 = LEN4 /* \_SB_.PCI0._CRS.LEN4 */
                    MAX4 = (MIN4 + Local1--)
                    If (LVGA)
                    {
                        CreateWordField (CRS2, \_SB.PCI0._Y08._MIN, IMN2)  // _MIN: Minimum Base Address
                        CreateWordField (CRS2, \_SB.PCI0._Y08._MAX, IMX2)  // _MAX: Maximum Base Address
                        CreateWordField (CRS2, \_SB.PCI0._Y08._LEN, ILN2)  // _LEN: Length
                        IMN2 = 0x03B0
                        IMX2 = 0x03DF
                        ILN2 = 0x30
                        CreateDWordField (CRS2, \_SB.PCI0._Y09._MIN, VMN2)  // _MIN: Minimum Base Address
                        CreateDWordField (CRS2, \_SB.PCI0._Y09._MAX, VMX2)  // _MAX: Maximum Base Address
                        CreateDWordField (CRS2, \_SB.PCI0._Y09._LEN, VLN2)  // _LEN: Length
                        VMN2 = 0x000A0000
                        VMX2 = 0x000BFFFF
                        VLN2 = 0x00020000
                    }
                    CreateDWordField (CRS2, \_SB.PCI0._Y0A._MIN, MIN5)  // _MIN: Minimum Base Address
                    CreateDWordField (CRS2, \_SB.PCI0._Y0A._MAX, MAX5)  // _MAX: Maximum Base Address
                    CreateDWordField (CRS2, \_SB.PCI0._Y0A._LEN, LEN5)  // _LEN: Length
                    MIN5 = MBB /* \_SB_.PCI0.MBB_ */
                    LEN5 = MBL /* \_SB_.PCI0.MBL_ */
                    Local1 = LEN5 /* \_SB_.PCI0._CRS.LEN5 */
                    MAX5 = (MIN5 + Local1--)
                    If ((MALH || MALL))
                    {
                        CreateDWordField (CRS2, \_SB.PCI0._Y0B._MIN, MN9L)  // _MIN: Minimum Base Address
                        Local0 = (0x72 + 0x04)
                        CreateDWordField (CRS2, Local0, MN9H)
                        CreateDWordField (CRS2, \_SB.PCI0._Y0B._MAX, MX9L)  // _MAX: Maximum Base Address
                        Local1 = (0x7A + 0x04)
                        CreateDWordField (CRS2, Local1, MX9H)
                        CreateDWordField (CRS2, \_SB.PCI0._Y0B._LEN, LN9L)  // _LEN: Length
                        Local2 = (0x8A + 0x04)
                        CreateDWordField (CRS2, Local2, LN9H)
                        MN9L = MABL /* \_SB_.PCI0.MABL */
                        MN9H = MABH /* \_SB_.PCI0.MABH */
                        LN9L = MALL /* \_SB_.PCI0.MALL */
                        LN9H = MALH /* \_SB_.PCI0.MALH */
                        MX9L = MAML /* \_SB_.PCI0.MAML */
                        MX9H = MAMH /* \_SB_.PCI0.MAMH */
                    }
                    Return (CRS2) /* \_SB_.PCI0.CRS2 */
                }
            }
            Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
            {
                Name (SUPP, Zero)
                Name (CTRL, Zero)
                CreateDWordField (Arg3, Zero, CDW1)
                CreateDWordField (Arg3, 0x04, CDW2)
                CreateDWordField (Arg3, 0x08, CDW3)
                If ((Arg0 == ToUUID ("33db4d5b-1ff7-401c-9657-7441c03dd766") /* PCI Host Bridge Device */))
                {
                    SUPP = CDW2 /* \_SB_.PCI0._OSC.CDW2 */
                    CTRL = CDW3 /* \_SB_.PCI0._OSC.CDW3 */
                    If (((SUPP & 0x16) != 0x16))
                    {
                        CTRL &= 0x1E
                    }
                    If (!PEHP)
                    {
                        CTRL &= 0x1E
                    }
                    If (!SHPC)
                    {
                        CTRL &= 0x1D
                    }
                    If (!PEPM)
                    {
                        CTRL &= 0x1B
                    }
                    If (!PEER)
                    {
                        CTRL &= 0x17
                    }
                    If (!PECS)
                    {
                        CTRL &= 0x0F
                    }
                    If ((Arg1 != One))
                    {
                        CDW1 |= 0x08
                    }
                    If ((CDW3 != CTRL))
                    {
                        CDW1 |= 0x10
                    }
                    CDW3 = CTRL /* \_SB_.PCI0._OSC.CTRL */
                    Return (Arg3)
                }
                Else
                {
                    CDW1 |= 0x04
                    Return (Arg3)
                }
            }
            Device (IOH)
            {
                Name (_HID, EisaId ("PNP0C01") /* System Board */)  // _HID: Hardware ID
                Name (_UID, 0x0A)  // _UID: Unique ID
                Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                {
                    Memory32Fixed (ReadWrite,
                        0xFC000000,         // Address Base
                        0x01000000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFD000000,         // Address Base
                        0x01000000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFE000000,         // Address Base
                        0x00B00000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFBFFF000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFEB00000,         // Address Base
                        0x00100000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED00400,         // Address Base
                        0x0003FC00,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFED45000,         // Address Base
                        0x000BB000,         // Address Length
                        )
                })
            }
            Method (NPTS, 1, NotSerialized)
            {
            }
            Method (NWAK, 1, NotSerialized)
            {
            }
            Device (^UNC0)
            {
                Name (_HID, EisaId ("PNP0A03") /* PCI Bus */)  // _HID: Hardware ID
                Name (UBN0, 0xFF)
                Method (_UID, 0, NotSerialized)  // _UID: Unique ID
                {
                    Return (UBN0) /* \_SB_.UNC0.UBN0 */
                }
                Method (_BBN, 0, NotSerialized)  // _BBN: BIOS Bus Number
                {
                    Return (UBN0) /* \_SB_.UNC0.UBN0 */
                }
                Name (_ADR, Zero)  // _ADR: Address
                Name (CRS1, ResourceTemplate ()
                {
                    WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                        0x0000,             // Granularity
                        0x00FF,             // Range Minimum
                        0x00FF,             // Range Maximum
                        0x0000,             // Translation Offset
                        0x0001,             // Length
                        ,, _Y0C)
                })
                Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                {
                    CreateDWordField (CRS1, \_SB.UNC0._Y0C._MIN, UMIN)  // _MIN: Minimum Base Address
                    UMIN = UBN0 /* \_SB_.UNC0.UBN0 */
                    CreateDWordField (CRS1, \_SB.UNC0._Y0C._MAX, UMAX)  // _MAX: Maximum Base Address
                    UMAX = UBN0 /* \_SB_.UNC0.UBN0 */
                    Return (CRS1) /* \_SB_.UNC0.CRS1 */
                }
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (^^PCI0.STAV) /* \_SB_.PCI0.STAV */
                }
            }
            Device (SBRG)
            {
                Name (_ADR, 0x001F0000)  // _ADR: Address
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    Local0 = Package (0x02)
                        {
                            "device-id", 
                            Buffer (0x04)
                            {
                                 0x02, 0x3B, 0x00, 0x00                           /* .;.. */
                            }
                        }
                    DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                    Return (Local0)
                }
                Method (SPTS, 1, NotSerialized)
                {
                    PS1S = One
                    PS1E = One
                    SLPS = One
                }
                Method (SWAK, 1, NotSerialized)
                {
                    SLPS = Zero
                    PS1E = Zero
                    If (RTCS) {}
                    Else
                    {
                        Notify (PWRB, 0x02) // Device Wake
                    }
                }
                OperationRegion (SMIE, SystemIO, PM30, 0x08)
                Field (SMIE, ByteAcc, NoLock, Preserve)
                {
                        ,   4, 
                    PS1E,   1, 
                        ,   31, 
                    PS1S,   1, 
                    Offset (0x08)
                }
                Scope (\_SB)
                {
                    Name (SLPS, Zero)
                    OperationRegion (PMS0, SystemIO, PMBS, 0x04)
                    Field (PMS0, ByteAcc, NoLock, Preserve)
                    {
                            ,   10, 
                        RTCS,   1, 
                            ,   3, 
                        PEXS,   1, 
                        WAKS,   1, 
                        Offset (0x03), 
                        PWBT,   1, 
                        Offset (0x04)
                    }
                    Device (SLPB)
                    {
                        Name (_HID, EisaId ("PNP0C0E") /* Sleep Button Device */)  // _HID: Hardware ID
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            If ((SUSW != 0xFF))
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }
                        Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                        {
                            If ((SUSW != 0xFF))
                            {
                                Return (Package (0x02)
                                {
                                    SUSW, 
                                    0x04
                                })
                            }
                            Else
                            {
                                Return (Package (0x02)
                                {
                                    Zero, 
                                    Zero
                                })
                            }
                        }
                    }
                }
                Scope (\_SB)
                {
                    Scope (PCI0)
                    {
                        Device (PCH)
                        {
                            Name (_HID, EisaId ("PNP0C01") /* System Board */)  // _HID: Hardware ID
                            Name (_UID, 0x01C7)  // _UID: Unique ID
                            Name (_STA, 0x0F)  // _STA: Status
                            Name (ICHR, ResourceTemplate ()
                            {
                                IO (Decode16,
                                    0x0000,             // Range Minimum
                                    0x0000,             // Range Maximum
                                    0x00,               // Alignment
                                    0x00,               // Length
                                    _Y0D)
                                IO (Decode16,
                                    0x0000,             // Range Minimum
                                    0x0000,             // Range Maximum
                                    0x00,               // Alignment
                                    0x00,               // Length
                                    _Y0E)
                                IO (Decode16,
                                    0x0000,             // Range Minimum
                                    0x0000,             // Range Maximum
                                    0x00,               // Alignment
                                    0x00,               // Length
                                    _Y0F)
                                IO (Decode16,
                                    0x0000,             // Range Minimum
                                    0x0000,             // Range Maximum
                                    0x00,               // Alignment
                                    0x00,               // Length
                                    _Y10)
                                Memory32Fixed (ReadWrite,
                                    0x00000000,         // Address Base
                                    0x00000000,         // Address Length
                                    _Y12)
                                Memory32Fixed (ReadWrite,
                                    0x00000000,         // Address Base
                                    0x00000000,         // Address Length
                                    _Y11)
                                Memory32Fixed (ReadWrite,
                                    0x00000000,         // Address Base
                                    0x00000000,         // Address Length
                                    _Y13)
                                Memory32Fixed (ReadWrite,
                                    0xFF000000,         // Address Base
                                    0x01000000,         // Address Length
                                    )
                            })
                            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                            {
                                CreateWordField (ICHR, \_SB.PCI0.PCH._Y0D._MIN, PBB)  // _MIN: Minimum Base Address
                                CreateWordField (ICHR, \_SB.PCI0.PCH._Y0D._MAX, PBH)  // _MAX: Maximum Base Address
                                CreateByteField (ICHR, \_SB.PCI0.PCH._Y0D._LEN, PML)  // _LEN: Length
                                PBB = PMBS /* \PMBS */
                                PBH = PMBS /* \PMBS */
                                PML = 0x54
                                CreateWordField (ICHR, \_SB.PCI0.PCH._Y0E._MIN, P2B)  // _MIN: Minimum Base Address
                                CreateWordField (ICHR, \_SB.PCI0.PCH._Y0E._MAX, P2H)  // _MAX: Maximum Base Address
                                CreateByteField (ICHR, \_SB.PCI0.PCH._Y0E._LEN, P2L)  // _LEN: Length
                                P2B = (PMBS + 0x58)
                                P2H = (PMBS + 0x58)
                                P2L = 0x28
                                If (SMBS)
                                {
                                    CreateWordField (ICHR, \_SB.PCI0.PCH._Y0F._MIN, SMB)  // _MIN: Minimum Base Address
                                    CreateWordField (ICHR, \_SB.PCI0.PCH._Y0F._MAX, SMH)  // _MAX: Maximum Base Address
                                    CreateByteField (ICHR, \_SB.PCI0.PCH._Y0F._LEN, SML)  // _LEN: Length
                                    SMB = SMBS /* \SMBS */
                                    SMH = SMBS /* \SMBS */
                                    SML = SMBL /* \SMBL */
                                }
                                If (GPBS)
                                {
                                    CreateWordField (ICHR, \_SB.PCI0.PCH._Y10._MIN, IGB)  // _MIN: Minimum Base Address
                                    CreateWordField (ICHR, \_SB.PCI0.PCH._Y10._MAX, IGH)  // _MAX: Maximum Base Address
                                    CreateByteField (ICHR, \_SB.PCI0.PCH._Y10._LEN, IGL)  // _LEN: Length
                                    IGB = GPBS /* \GPBS */
                                    IGH = GPBS /* \GPBS */
                                    IGL = GPLN /* \GPLN */
                                }
                                If (APCB)
                                {
                                    CreateDWordField (ICHR, \_SB.PCI0.PCH._Y11._BAS, APB)  // _BAS: Base Address
                                    CreateDWordField (ICHR, \_SB.PCI0.PCH._Y11._LEN, APL)  // _LEN: Length
                                    APB = APCB /* \APCB */
                                    APL = APCL /* \APCL */
                                }
                                CreateDWordField (ICHR, \_SB.PCI0.PCH._Y12._BAS, RCB)  // _BAS: Base Address
                                CreateDWordField (ICHR, \_SB.PCI0.PCH._Y12._LEN, RCL)  // _LEN: Length
                                RCB = SRCB /* \SRCB */
                                RCL = SRCL /* \SRCL */
                                If (TCBR)
                                {
                                    CreateDWordField (ICHR, \_SB.PCI0.PCH._Y13._BAS, TCB)  // _BAS: Base Address
                                    CreateDWordField (ICHR, \_SB.PCI0.PCH._Y13._LEN, TCL)  // _LEN: Length
                                    TCB = TCBR /* \TCBR */
                                    TCL = TCLT /* \TCLT */
                                }
                                Return (ICHR) /* \_SB_.PCI0.PCH_.ICHR */
                            }
                        }
                        Device (CWDT)
                        {
                            Name (_HID, EisaId ("INT3F0D") /* ACPI Motherboard Resources */)  // _HID: Hardware ID
                            Name (_CID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _CID: Compatible ID
                            Name (BUF0, ResourceTemplate ()
                            {
                                IO (Decode16,
                                    0x0454,             // Range Minimum
                                    0x0454,             // Range Maximum
                                    0x04,               // Alignment
                                    0x04,               // Length
                                    _Y14)
                            })
                            Method (_STA, 0, Serialized)  // _STA: Status
                            {
                                Return (0x0F)
                            }
                            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                            {
                                CreateWordField (BUF0, \_SB.PCI0.CWDT._Y14._MIN, WDB)  // _MIN: Minimum Base Address
                                CreateWordField (BUF0, \_SB.PCI0.CWDT._Y14._MAX, WDH)  // _MAX: Maximum Base Address
                                WDB = (PMBS + 0x54)
                                WDH = (PMBS + 0x54)
                                Return (BUF0) /* \_SB_.PCI0.CWDT.BUF0 */
                            }
                        }
                    }
                }
                Device (EC0)
                {
                    Name (_HID, EisaId ("PNP0C09") /* Embedded Controller Device */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0062,             // Range Minimum
                            0x0062,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0066,             // Range Minimum
                            0x0066,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                    })
                    Name (_GPE, 0x1E)  // _GPE: General Purpose Events
                    Name (REGC, Zero)
                    Method (_REG, 2, NotSerialized)  // _REG: Region Availability
                    {
                        If ((Arg0 == 0x03))
                        {
                            REGC = Arg1
                        }
                    }
                    Method (_Q80, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        \AMW0.AMWN (0x05)
                    }
                    Method (_Q81, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        \AMW0.AMWN (0x00010005)
                    }
                    Method (_Q82, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        \AMW0.AMWN (0x00020005)
                    }
                    Method (_Q83, 0, NotSerialized)  // _Qxx: EC Query
                    {
                        \AMW0.AMWN (0x00030005)
                    }
                }
                Device (SIO1)
                {
                    Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
                    Name (_UID, 0x0111)  // _UID: Unique ID
                    Name (CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x00,               // Alignment
                            0x00,               // Length
                            _Y15)
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x00,               // Alignment
                            0x00,               // Length
                            _Y16)
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x00,               // Alignment
                            0x00,               // Length
                            _Y17)
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x00,               // Alignment
                            0x00,               // Length
                            _Y18)
                    })
                    Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                    {
                        If (((SP1O < 0x03F0) && (SP1O > 0xF0)))
                        {
                            CreateWordField (CRS, \_SB.PCI0.SBRG.SIO1._Y15._MIN, GPI0)  // _MIN: Minimum Base Address
                            CreateWordField (CRS, \_SB.PCI0.SBRG.SIO1._Y15._MAX, GPI1)  // _MAX: Maximum Base Address
                            CreateByteField (CRS, \_SB.PCI0.SBRG.SIO1._Y15._LEN, GPIL)  // _LEN: Length
                            GPI0 = SP1O /* \SP1O */
                            GPI1 = SP1O /* \SP1O */
                            GPIL = 0x02
                        }
                        If (IO1B)
                        {
                            CreateWordField (CRS, \_SB.PCI0.SBRG.SIO1._Y16._MIN, GP10)  // _MIN: Minimum Base Address
                            CreateWordField (CRS, \_SB.PCI0.SBRG.SIO1._Y16._MAX, GP11)  // _MAX: Maximum Base Address
                            CreateByteField (CRS, \_SB.PCI0.SBRG.SIO1._Y16._LEN, GPL1)  // _LEN: Length
                            GP10 = IO1B /* \IO1B */
                            GP11 = IO1B /* \IO1B */
                            GPL1 = IO1L /* \IO1L */
                        }
                        If (IO3B)
                        {
                            CreateWordField (CRS, \_SB.PCI0.SBRG.SIO1._Y17._MIN, GP20)  // _MIN: Minimum Base Address
                            CreateWordField (CRS, \_SB.PCI0.SBRG.SIO1._Y17._MAX, GP21)  // _MAX: Maximum Base Address
                            CreateByteField (CRS, \_SB.PCI0.SBRG.SIO1._Y17._LEN, GPL2)  // _LEN: Length
                            GP20 = IO3B /* \IO3B */
                            GP21 = IO3B /* \IO3B */
                            GPL2 = IO3L /* \IO3L */
                        }
                        If (IO2B)
                        {
                            CreateWordField (CRS, \_SB.PCI0.SBRG.SIO1._Y18._MIN, GP30)  // _MIN: Minimum Base Address
                            CreateWordField (CRS, \_SB.PCI0.SBRG.SIO1._Y18._MAX, GP31)  // _MAX: Maximum Base Address
                            CreateByteField (CRS, \_SB.PCI0.SBRG.SIO1._Y18._LEN, GPL3)  // _LEN: Length
                            GP30 = IO2B /* \IO2B */
                            GP31 = IO2B /* \IO2B */
                            GPL3 = IO2L /* \IO2L */
                        }
                        Return (CRS) /* \_SB_.PCI0.SBRG.SIO1.CRS_ */
                    }
                    Name (DCAT, Package (0x15)
                    {
                        0x02, 
                        0x03, 
                        One, 
                        Zero, 
                        0xFF, 
                        0xFF, 
                        0xFF, 
                        0xFF, 
                        0xFF, 
                        0xFF, 
                        0x05, 
                        0xFF, 
                        0xFF, 
                        0xFF, 
                        0x05, 
                        0xFF, 
                        0xFF, 
                        0xFF, 
                        0x06, 
                        0xFF, 
                        0xFF
                    })
                    Mutex (MUT0, 0x00)
                    Method (ENFG, 1, NotSerialized)
                    {
                        Acquire (MUT0, 0x0FFF)
                        INDX = 0x87
                        INDX = 0x87
                        LDN = Arg0
                    }
                    Method (EXFG, 0, NotSerialized)
                    {
                        INDX = 0xAA
                        Release (MUT0)
                    }
                    Method (LPTM, 1, NotSerialized)
                    {
                        ENFG (CGLD (Arg0))
                        Local0 = (OPT0 & 0x02)
                        EXFG ()
                        Return (Local0)
                    }
                    Method (UHID, 1, NotSerialized)
                    {
                        ENFG (CGLD (Arg0))
                        Local0 = (OPT0 & 0x38)
                        EXFG ()
                        If (Local0)
                        {
                            Return (0x1005D041)
                        }
                        Else
                        {
                            Return (0x0105D041)
                        }
                    }
                    OperationRegion (IOID, SystemIO, SP1O, 0x02)
                    Field (IOID, ByteAcc, NoLock, Preserve)
                    {
                        INDX,   8, 
                        DATA,   8
                    }
                    IndexField (INDX, DATA, ByteAcc, NoLock, Preserve)
                    {
                        Offset (0x07), 
                        LDN,    8, 
                        Offset (0x21), 
                        SCF1,   8, 
                        SCF2,   8, 
                        SCF3,   8, 
                        SCF4,   8, 
                        SCF5,   8, 
                        SCF6,   8, 
                        Offset (0x29), 
                        CKCF,   8, 
                        Offset (0x30), 
                        ACTR,   8, 
                        Offset (0x60), 
                        IOAH,   8, 
                        IOAL,   8, 
                        IOH2,   8, 
                        IOL2,   8, 
                        Offset (0x70), 
                        INTR,   8, 
                        Offset (0x74), 
                        DMCH,   8, 
                        Offset (0xE0), 
                        RGE0,   8, 
                        RGE1,   8, 
                        RGE2,   8, 
                        RGE3,   8, 
                        RGE4,   8, 
                        RGE5,   8, 
                        RGE6,   8, 
                        RGE7,   8, 
                        RGE8,   8, 
                        RGE9,   8, 
                        Offset (0xF0), 
                        OPT0,   8, 
                        OPT1,   8, 
                        OPT2,   8, 
                        OPT3,   8, 
                        OPT4,   8, 
                        OPT5,   8, 
                        OPT6,   8, 
                        OPT7,   8, 
                        OPT8,   8, 
                        OPT9,   8
                    }
                    Method (CGLD, 1, NotSerialized)
                    {
                        Return (DerefOf (Index (DCAT, Arg0)))
                    }
                    Method (DSTA, 1, NotSerialized)
                    {
                        ENFG (CGLD (Arg0))
                        Local0 = ACTR /* \_SB_.PCI0.SBRG.SIO1.ACTR */
                        EXFG ()
                        If ((Local0 == 0xFF))
                        {
                            Return (Zero)
                        }
                        Local0 &= One
                        If ((Arg0 >= 0x10))
                        {
                            IOES |= (Local0 << (Arg0 & 0x0F))
                        }
                        Else
                        {
                            IOST |= (Local0 << Arg0)
                        }
                        If (Local0)
                        {
                            Return (0x0F)
                        }
                        Else
                        {
                            If ((Arg0 >= 0x10))
                            {
                                Local0 = IOES /* \IOES */
                            }
                            Else
                            {
                                Local0 = IOST /* \IOST */
                            }
                            Local1 = (Arg0 & 0x0F)
                            If (((One << Local1) & Local0))
                            {
                                Return (0x0D)
                            }
                            Else
                            {
                                Return (Zero)
                            }
                        }
                    }
                    Method (DCNT, 2, NotSerialized)
                    {
                        ENFG (CGLD (Arg0))
                        If (((DMCH < 0x04) && ((Local1 = (DMCH & 0x03)) != Zero)))
                        {
                            RDMA (Arg0, Arg1, Local1++)
                        }
                        ACTR = Arg1
                        Local1 = (IOAH << 0x08)
                        Local1 |= IOAL
                        RRIO (Arg0, Arg1, Local1, 0x08)
                        EXFG ()
                    }
                    Name (CRS1, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x01,               // Alignment
                            0x00,               // Length
                            _Y1B)
                        IRQNoFlags (_Y19)
                            {}
                        DMA (Compatibility, NotBusMaster, Transfer8, _Y1A)
                            {}
                    })
                    CreateWordField (CRS1, \_SB.PCI0.SBRG.SIO1._Y19._INT, IRQM)  // _INT: Interrupts
                    CreateByteField (CRS1, \_SB.PCI0.SBRG.SIO1._Y1A._DMA, DMAM)  // _DMA: Direct Memory Access
                    CreateWordField (CRS1, \_SB.PCI0.SBRG.SIO1._Y1B._MIN, IO11)  // _MIN: Minimum Base Address
                    CreateWordField (CRS1, \_SB.PCI0.SBRG.SIO1._Y1B._MAX, IO12)  // _MAX: Maximum Base Address
                    CreateByteField (CRS1, \_SB.PCI0.SBRG.SIO1._Y1B._LEN, LEN1)  // _LEN: Length
                    Name (CRS2, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x01,               // Alignment
                            0x00,               // Length
                            _Y1E)
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x01,               // Alignment
                            0x00,               // Length
                            _Y1F)
                        IRQNoFlags (_Y1C)
                            {}
                        DMA (Compatibility, NotBusMaster, Transfer8, _Y1D)
                            {2}
                    })
                    CreateWordField (CRS2, \_SB.PCI0.SBRG.SIO1._Y1C._INT, IRQE)  // _INT: Interrupts
                    CreateByteField (CRS2, \_SB.PCI0.SBRG.SIO1._Y1D._DMA, DMAE)  // _DMA: Direct Memory Access
                    CreateWordField (CRS2, \_SB.PCI0.SBRG.SIO1._Y1E._MIN, IO21)  // _MIN: Minimum Base Address
                    CreateWordField (CRS2, \_SB.PCI0.SBRG.SIO1._Y1E._MAX, IO22)  // _MAX: Maximum Base Address
                    CreateByteField (CRS2, \_SB.PCI0.SBRG.SIO1._Y1E._LEN, LEN2)  // _LEN: Length
                    CreateWordField (CRS2, \_SB.PCI0.SBRG.SIO1._Y1F._MIN, IO31)  // _MIN: Minimum Base Address
                    CreateWordField (CRS2, \_SB.PCI0.SBRG.SIO1._Y1F._MAX, IO32)  // _MAX: Maximum Base Address
                    CreateByteField (CRS2, \_SB.PCI0.SBRG.SIO1._Y1F._LEN, LEN3)  // _LEN: Length
                    Name (CRS4, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x01,               // Alignment
                            0x00,               // Length
                            _Y21)
                        IRQ (Edge, ActiveLow, Shared, _Y20)
                            {}
                    })
                    CreateWordField (CRS4, \_SB.PCI0.SBRG.SIO1._Y20._INT, IRQL)  // _INT: Interrupts
                    CreateWordField (CRS4, \_SB.PCI0.SBRG.SIO1._Y21._MIN, IOHL)  // _MIN: Minimum Base Address
                    CreateWordField (CRS4, \_SB.PCI0.SBRG.SIO1._Y21._MAX, IORL)  // _MAX: Maximum Base Address
                    CreateByteField (CRS4, \_SB.PCI0.SBRG.SIO1._Y21._ALN, ALMN)  // _ALN: Alignment
                    CreateByteField (CRS4, \_SB.PCI0.SBRG.SIO1._Y21._LEN, LENG)  // _LEN: Length
                    Method (DCRS, 2, NotSerialized)
                    {
                        ENFG (CGLD (Arg0))
                        IO11 = (IOAH << 0x08)
                        IO11 |= IOAL /* \_SB_.PCI0.SBRG.SIO1.IO11 */
                        IO12 = IO11 /* \_SB_.PCI0.SBRG.SIO1.IO11 */
                        LEN1 = 0x08
                        If (INTR)
                        {
                            IRQM = (One << INTR) /* \_SB_.PCI0.SBRG.SIO1.INTR */
                        }
                        Else
                        {
                            IRQM = Zero
                        }
                        If (((DMCH > 0x03) || (Arg1 == Zero)))
                        {
                            DMAM = Zero
                        }
                        Else
                        {
                            Local1 = (DMCH & 0x03)
                            DMAM = (One << Local1)
                        }
                        EXFG ()
                        Return (CRS1) /* \_SB_.PCI0.SBRG.SIO1.CRS1 */
                    }
                    Method (DCR2, 2, NotSerialized)
                    {
                        ENFG (CGLD (Arg0))
                        IO21 = (IOAH << 0x08)
                        IO21 |= IOAL /* \_SB_.PCI0.SBRG.SIO1.IO21 */
                        IO22 = IO21 /* \_SB_.PCI0.SBRG.SIO1.IO21 */
                        LEN2 = 0x08
                        IO31 = (IOH2 << 0x08)
                        IO31 |= IOL2 /* \_SB_.PCI0.SBRG.SIO1.IO31 */
                        IO32 = IO21 /* \_SB_.PCI0.SBRG.SIO1.IO21 */
                        LEN3 = 0x08
                        If (INTR)
                        {
                            IRQE = (One << INTR) /* \_SB_.PCI0.SBRG.SIO1.INTR */
                        }
                        Else
                        {
                            IRQE = Zero
                        }
                        If (((DMCH > 0x03) || (Arg1 == Zero)))
                        {
                            DMAE = Zero
                        }
                        Else
                        {
                            Local1 = (DMCH & 0x03)
                            DMAE = (One << Local1)
                        }
                        EXFG ()
                        Return (CRS2) /* \_SB_.PCI0.SBRG.SIO1.CRS2 */
                    }
                    Method (DCR4, 2, NotSerialized)
                    {
                        ENFG (CGLD (Arg0))
                        IOHL = (IOAH << 0x08)
                        IOHL |= IOAL /* \_SB_.PCI0.SBRG.SIO1.IOHL */
                        IORL = IOHL /* \_SB_.PCI0.SBRG.SIO1.IOHL */
                        LENG = 0x08
                        If (INTR)
                        {
                            INTR &= 0x0F
                            IRQL = (One << INTR) /* \_SB_.PCI0.SBRG.SIO1.INTR */
                        }
                        Else
                        {
                            IRQL = Zero
                        }
                        EXFG ()
                        Return (CRS4) /* \_SB_.PCI0.SBRG.SIO1.CRS4 */
                    }
                    Method (DSRS, 2, NotSerialized)
                    {
                        If ((Arg1 == 0x02))
                        {
                            If (LPTM (CGLD (Arg1)))
                            {
                                DSR2 (Arg0, Arg1)
                            }
                        }
                        Else
                        {
                            CreateWordField (Arg0, 0x09, IRQM)
                            CreateByteField (Arg0, 0x0C, DMAM)
                            CreateWordField (Arg0, 0x02, IO11)
                            ENFG (CGLD (Arg1))
                            Local1 = (IOAH << 0x08)
                            Local1 |= IOAL
                            RRIO (Arg1, Zero, Local1, 0x08)
                            RRIO (Arg1, One, IO11, 0x08)
                            IOAL = (IO11 & 0xFF)
                            IOAH = (IO11 >> 0x08)
                            If (IRQM)
                            {
                                FindSetRightBit (IRQM, Local0)
                                INTR = (Local0 - One)
                            }
                            Else
                            {
                                INTR = Zero
                            }
                            If (DMAM)
                            {
                                FindSetRightBit (DMAM, Local0)
                                DMCH = (Local0 - One)
                            }
                            Else
                            {
                                DMCH = 0x04
                            }
                            EXFG ()
                            DCNT (Arg1, One)
                            Local2 = Arg1
                            If ((Local2 > Zero))
                            {
                                Local2 -= One
                            }
                        }
                    }
                    Method (DSR2, 2, NotSerialized)
                    {
                        CreateWordField (Arg0, 0x11, IRQT)
                        CreateByteField (Arg0, 0x14, DMAT)
                        CreateWordField (Arg0, 0x02, IOT1)
                        CreateWordField (Arg0, 0x0A, IOT2)
                        ENFG (CGLD (Arg1))
                        IOAL = (IOT1 & 0xFF)
                        IOAH = (IOT1 >> 0x08)
                        IOL2 = (IOT2 & 0xFF)
                        IOH2 = (IOT2 >> 0x08)
                        If (IRQT)
                        {
                            FindSetRightBit (IRQT, Local0)
                            INTR = (Local0 - One)
                        }
                        Else
                        {
                            INTR = Zero
                        }
                        If (DMAT)
                        {
                            FindSetRightBit (DMAT, Local0)
                            DMCH = (Local0 - One)
                        }
                        Else
                        {
                            DMCH = 0x04
                        }
                        EXFG ()
                        DCNT (Arg1, One)
                        Local2 = Arg1
                        If ((Local2 > Zero))
                        {
                            Local2 -= One
                        }
                    }
                    Method (DSR4, 2, NotSerialized)
                    {
                        CreateWordField (Arg0, 0x02, IOHL)
                        CreateWordField (Arg0, 0x09, IRQL)
                        ENFG (CGLD (Arg1))
                        IOAL = (IOHL & 0xFF)
                        IOAH = (IOHL >> 0x08)
                        If (IRQL)
                        {
                            FindSetRightBit (IRQL, Local0)
                            INTR = (Local0 - One)
                        }
                        Else
                        {
                            INTR = Zero
                        }
                        EXFG ()
                        DCNT (Arg1, One)
                        Local2 = Arg1
                        If ((Local2 > Zero))
                        {
                            Local2 -= One
                        }
                    }
                }
                Name (PMFG, Zero)
                Method (SIOS, 1, NotSerialized)
                {
                    Debug = "SIOS"
                    If ((One == Arg0))
                    {
                        ^SIO1.ENFG (0x0A)
                        ^SIO1.RGE0 &= 0x9F
                        If (KBFG)
                        {
                            ^SIO1.OPT6 |= 0x10
                        }
                        Else
                        {
                            ^SIO1.OPT6 &= 0xEF
                        }
                        If (MSFG)
                        {
                            ^SIO1.OPT6 |= 0x20
                        }
                        Else
                        {
                            ^SIO1.OPT6 &= 0xDF
                        }
                        ^SIO1.OPT3 = 0xFF
                        ^SIO1.OPT4 = 0xFF
                        ^SIO1.OPT2 |= One /* \_SB_.PCI0.SBRG.SIO1.OPT2 */
                        ^SIO1.EXFG ()
                        Return (Zero)
                    }
                    If ((0x05 != Arg0))
                    {
                        ^SIO1.ENFG (0x0A)
                        ^SIO1.OPT3 = 0xFF
                        ^SIO1.OPT4 = 0xFF
                        Local0 = ^SIO1.RGE3 /* \_SB_.PCI0.SBRG.SIO1.RGE3 */
                        If (KBFG)
                        {
                            ^SIO1.RGE0 |= 0x41
                        }
                        Else
                        {
                            ^SIO1.RGE0 &= 0xBF
                        }
                        If (MSFG)
                        {
                            ^SIO1.RGE0 &= 0xCD
                            ^SIO1.RGE0 |= 0x22
                            ^SIO1.RGE6 &= 0x7F
                        }
                        Else
                        {
                            ^SIO1.RGE0 &= 0xDF
                        }
                        ^SIO1.OPT2 &= 0xFE /* \_SB_.PCI0.SBRG.SIO1.OPT2 */
                        ^SIO1.EXFG ()
                    }
                }
                Method (SIOW, 1, NotSerialized)
                {
                    Debug = "SIOW"
                    ^SIO1.ENFG (0x0A)
                    PMFG = ^SIO1.OPT3 /* \_SB_.PCI0.SBRG.SIO1.OPT3 */
                    ^SIO1.OPT3 = 0xFF
                    ^SIO1.OPT0 &= 0xE7
                    ^SIO1.OPT2 &= 0xFE /* \_SB_.PCI0.SBRG.SIO1.OPT2 */
                    ^SIO1.EXFG ()
                }
                OperationRegion (RX80, PCI_Config, Zero, 0xFF)
                Field (RX80, ByteAcc, NoLock, Preserve)
                {
                    Offset (0x80), 
                    LPCD,   16, 
                    LPCE,   16
                }
                Name (DBPT, Package (0x04)
                {
                    Package (0x08)
                    {
                        0x03F8, 
                        0x02F8, 
                        0x0220, 
                        0x0228, 
                        0x0238, 
                        0x02E8, 
                        0x0338, 
                        0x03E8
                    }, 
                    Package (0x08)
                    {
                        0x03F8, 
                        0x02F8, 
                        0x0220, 
                        0x0228, 
                        0x0238, 
                        0x02E8, 
                        0x0338, 
                        0x03E8
                    }, 
                    Package (0x03)
                    {
                        0x0378, 
                        0x0278, 
                        0x03BC
                    }, 
                    Package (0x02)
                    {
                        0x03F0, 
                        0x0370
                    }
                })
                Name (DDLT, Package (0x04)
                {
                    Package (0x02)
                    {
                        Zero, 
                        0xFFF8
                    }, 
                    Package (0x02)
                    {
                        0x04, 
                        0xFF8F
                    }, 
                    Package (0x02)
                    {
                        0x08, 
                        0xFCFF
                    }, 
                    Package (0x02)
                    {
                        0x0C, 
                        0xEFFF
                    }
                })
                Method (RRIO, 4, NotSerialized)
                {
                    If (((Arg0 <= 0x03) && (Arg0 >= Zero)))
                    {
                        Local0 = Match (DerefOf (Index (DBPT, Arg0)), MEQ, Arg2, MTR, Zero, 
                            Zero)
                        If ((Local0 != Ones))
                        {
                            Local1 = DerefOf (Index (DerefOf (Index (DDLT, Arg0)), Zero))
                            Local2 = DerefOf (Index (DerefOf (Index (DDLT, Arg0)), One))
                            Local0 <<= Local1
                            LPCD &= Local2
                            LPCD |= Local0
                            WX82 (Arg0, Arg1)
                        }
                    }
                    If ((Arg0 == 0x08))
                    {
                        If ((Arg2 == 0x0200))
                        {
                            WX82 (0x08, Arg0)
                        }
                        Else
                        {
                            If ((Arg2 == 0x0208))
                            {
                                WX82 (0x09, Arg0)
                            }
                        }
                    }
                    If (((Arg0 <= 0x0D) && (Arg0 >= 0x0A)))
                    {
                        WX82 (Arg0, Arg1)
                    }
                }
                Method (WX82, 2, NotSerialized)
                {
                    Local0 = (One << Arg0)
                    If (Arg1)
                    {
                        LPCE |= Local0
                    }
                    Else
                    {
                        Local0 = ~Local0
                        LPCE &= Local0
                    }
                }
                Method (RDMA, 3, NotSerialized)
                {
                }
                Device (PIC)
                {
                    Name (_HID, EisaId ("PNP0000") /* 8259-compatible Programmable Interrupt Controller */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0020,             // Range Minimum
                            0x0020,             // Range Maximum
                            0x00,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A0,             // Range Minimum
                            0x00A0,             // Range Maximum
                            0x00,               // Alignment
                            0x02,               // Length
                            )
                        IRQNoFlags ()
                            {2}
                    })
                }
                Device (DMAD)
                {
                    Name (_HID, EisaId ("PNP0200") /* PC-class DMA Controller */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        DMA (Compatibility, BusMaster, Transfer8, )
                            {4}
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x0081,             // Range Minimum
                            0x0081,             // Range Maximum
                            0x00,               // Alignment
                            0x03,               // Length
                            )
                        IO (Decode16,
                            0x0087,             // Range Minimum
                            0x0087,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0089,             // Range Minimum
                            0x0089,             // Range Maximum
                            0x00,               // Alignment
                            0x03,               // Length
                            )
                        IO (Decode16,
                            0x008F,             // Range Minimum
                            0x008F,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x00C0,             // Range Minimum
                            0x00C0,             // Range Maximum
                            0x00,               // Alignment
                            0x20,               // Length
                            )
                    })
                }
                Device (TMR)
                {
                    Name (_HID, EisaId ("PNP0100") /* PC-class System Timer */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0040,             // Range Minimum
                            0x0040,             // Range Maximum
                            0x00,               // Alignment
                            0x04,               // Length
                            )
                    })
                }
                Device (RTC0)
                {
                    Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0070,             // Range Minimum
                            0x0070,             // Range Maximum
                            0x00,               // Alignment
                            0x02,               // Length
                            )
                    })
                }
                Device (SPKR)
                {
                    Name (_HID, EisaId ("PNP0800") /* Microsoft Sound System Compatible Device */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0061,             // Range Minimum
                            0x0061,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                    })
                }
                Device (RMSC)
                {
                    Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
                    Name (_UID, 0x10)  // _UID: Unique ID
                    Name (CRS1, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0010,             // Range Minimum
                            0x0010,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x0022,             // Range Minimum
                            0x0022,             // Range Maximum
                            0x00,               // Alignment
                            0x1E,               // Length
                            )
                        IO (Decode16,
                            0x0044,             // Range Minimum
                            0x0044,             // Range Maximum
                            0x00,               // Alignment
                            0x1C,               // Length
                            )
                        IO (Decode16,
                            0x0063,             // Range Minimum
                            0x0063,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0065,             // Range Minimum
                            0x0065,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0067,             // Range Minimum
                            0x0067,             // Range Maximum
                            0x00,               // Alignment
                            0x09,               // Length
                            )
                        IO (Decode16,
                            0x0072,             // Range Minimum
                            0x0072,             // Range Maximum
                            0x00,               // Alignment
                            0x0E,               // Length
                            )
                        IO (Decode16,
                            0x0080,             // Range Minimum
                            0x0080,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0084,             // Range Minimum
                            0x0084,             // Range Maximum
                            0x00,               // Alignment
                            0x03,               // Length
                            )
                        IO (Decode16,
                            0x0088,             // Range Minimum
                            0x0088,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x008C,             // Range Minimum
                            0x008C,             // Range Maximum
                            0x00,               // Alignment
                            0x03,               // Length
                            )
                        IO (Decode16,
                            0x0090,             // Range Minimum
                            0x0090,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x00A2,             // Range Minimum
                            0x00A2,             // Range Maximum
                            0x00,               // Alignment
                            0x1E,               // Length
                            )
                        IO (Decode16,
                            0x00E0,             // Range Minimum
                            0x00E0,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x04D0,             // Range Minimum
                            0x04D0,             // Range Maximum
                            0x00,               // Alignment
                            0x02,               // Length
                            )
                    })
                    Name (CRS2, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0010,             // Range Minimum
                            0x0010,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x0022,             // Range Minimum
                            0x0022,             // Range Maximum
                            0x00,               // Alignment
                            0x1E,               // Length
                            )
                        IO (Decode16,
                            0x0044,             // Range Minimum
                            0x0044,             // Range Maximum
                            0x00,               // Alignment
                            0x1C,               // Length
                            )
                        IO (Decode16,
                            0x0072,             // Range Minimum
                            0x0072,             // Range Maximum
                            0x00,               // Alignment
                            0x0E,               // Length
                            )
                        IO (Decode16,
                            0x0080,             // Range Minimum
                            0x0080,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0084,             // Range Minimum
                            0x0084,             // Range Maximum
                            0x00,               // Alignment
                            0x03,               // Length
                            )
                        IO (Decode16,
                            0x0088,             // Range Minimum
                            0x0088,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x008C,             // Range Minimum
                            0x008C,             // Range Maximum
                            0x00,               // Alignment
                            0x03,               // Length
                            )
                        IO (Decode16,
                            0x0090,             // Range Minimum
                            0x0090,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x00A2,             // Range Minimum
                            0x00A2,             // Range Maximum
                            0x00,               // Alignment
                            0x1E,               // Length
                            )
                        IO (Decode16,
                            0x00E0,             // Range Minimum
                            0x00E0,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x04D0,             // Range Minimum
                            0x04D0,             // Range Maximum
                            0x00,               // Alignment
                            0x02,               // Length
                            )
                    })
                    Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                    {
                        If ((MBEC & 0xFFFF))
                        {
                            Return (CRS1) /* \_SB_.PCI0.SBRG.RMSC.CRS1 */
                        }
                        Else
                        {
                            Return (CRS2) /* \_SB_.PCI0.SBRG.RMSC.CRS2 */
                        }
                    }
                }
                Device (COPR)
                {
                    Name (_HID, EisaId ("PNP0C04") /* x87-compatible Floating Point Processing Unit */)  // _HID: Hardware ID
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x00F0,             // Range Minimum
                            0x00F0,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IRQNoFlags ()
                            {13}
                    })
                }
                Device (PS2K)
                {
                    Name (_HID, EisaId ("PNP0303") /* IBM Enhanced Keyboard (101/102-key, PS/2 Mouse) */)  // _HID: Hardware ID
                    Name (_CID, EisaId ("PNP030B"))  // _CID: Compatible ID
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        If ((IOST & 0x0400))
                        {
                            Return (0x0F)
                        }
                        Else
                        {
                            Return (Zero)
                        }
                    }
                    Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                    {
                        IO (Decode16,
                            0x0060,             // Range Minimum
                            0x0060,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0064,             // Range Minimum
                            0x0064,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IRQNoFlags ()
                            {1}
                    })
                    Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                    {
                        StartDependentFn (0x00, 0x00)
                        {
                            FixedIO (
                                0x0060,             // Address
                                0x01,               // Length
                                )
                            FixedIO (
                                0x0064,             // Address
                                0x01,               // Length
                                )
                            IRQNoFlags ()
                                {1}
                        }
                        EndDependentFn ()
                    })
                    Method (_PSW, 1, NotSerialized)  // _PSW: Power State Wake
                    {
                        KBFG = Arg0
                    }
                }
                Scope (\)
                {
                    Name (KBFG, One)
                }
                Method (PS2K._PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x1D, 0x04))
                }
                Device (PS2M)
                {
                    Name (_HID, EisaId ("PNP0F03") /* Microsoft PS/2-style Mouse */)  // _HID: Hardware ID
                    Name (_CID, EisaId ("PNP0F13") /* PS/2 Mouse */)  // _CID: Compatible ID
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        If ((IOST & 0x4000))
                        {
                            Return (0x0F)
                        }
                        Else
                        {
                            Return (Zero)
                        }
                    }
                    Name (CRS1, ResourceTemplate ()
                    {
                        IRQNoFlags ()
                            {12}
                    })
                    Name (CRS2, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0060,             // Range Minimum
                            0x0060,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0064,             // Range Minimum
                            0x0064,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IRQNoFlags ()
                            {12}
                    })
                    Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                    {
                        If ((IOST & 0x0400))
                        {
                            Return (CRS1) /* \_SB_.PCI0.SBRG.PS2M.CRS1 */
                        }
                        Else
                        {
                            Return (CRS2) /* \_SB_.PCI0.SBRG.PS2M.CRS2 */
                        }
                    }
                    Name (_PRS, ResourceTemplate ()  // _PRS: Possible Resource Settings
                    {
                        StartDependentFn (0x00, 0x00)
                        {
                            IRQNoFlags ()
                                {12}
                        }
                        EndDependentFn ()
                    })
                    Method (_PSW, 1, NotSerialized)  // _PSW: Power State Wake
                    {
                        MSFG = Arg0
                    }
                }
                Scope (\)
                {
                    Name (MSFG, One)
                }
                Method (PS2M._PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x1D, 0x04))
                }
                Scope (^^PCI0)
                {
                    Name (SLIC, Buffer (0x9E)
                    {
                        "187215431789Genuine NVIDIA Certified SLI Ready Motherboard for ASUS P9X79 PRO      e402-Copyright 2011 NVIDIA Corporation All Rights Reserved-320198982567(R)"
                    })
                    Device (WMI1)
                    {
                        Name (_HID, "pnp0c14")  // _HID: Hardware ID
                        Name (_UID, "MXM2")  // _UID: Unique ID
                        Name (_WDG, Buffer (0x14)
                        {
                            /* 0000 */  0x3C, 0x5C, 0xCB, 0xF6, 0xAE, 0x9C, 0xBD, 0x4E,  /* <\.....N */
                            /* 0008 */  0xB5, 0x77, 0x93, 0x1E, 0xA3, 0x2A, 0x2C, 0xC0,  /* .w...*,. */
                            /* 0010 */  0x4D, 0x58, 0x01, 0x02                           /* MX.. */
                        })
                        Method (WMMX, 3, NotSerialized)
                        {
                            CreateDWordField (Arg2, Zero, FUNC)
                            If ((FUNC == 0x41494C53))
                            {
                                Return (SLIC) /* \_SB_.PCI0.SLIC */
                            }
                            Return (Zero)
                        }
                    }
                }
            }
            Device (BR20)
            {
                Name (_ADR, 0x001E0000)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x0B, 0x03))
                }
            }
            Device (SMB)
            {
                Name (_ADR, 0x001F0003)  // _ADR: Address
                OperationRegion (SMIO, SystemIO, SMBS, SMBL)
                Field (SMIO, ByteAcc, NoLock, Preserve)
                {
                    HSTS,   8, 
                    HCNT,   8, 
                    HCMD,   8, 
                    TSAD,   8, 
                    HDT0,   8, 
                    HDT1,   8, 
                    HBDT,   8, 
                    RSAD,   8, 
                    RSDA,   16, 
                    AUST,   8, 
                    AUCT,   8, 
                    SMLP,   8, 
                    SMBP,   8, 
                    SSTS,   8, 
                    SCMD,   8, 
                    NDAD,   8, 
                    NDLB,   8, 
                    NDHB,   8
                }
                Method (SMCS, 0, NotSerialized)
                {
                    HSTS = 0x20
                }
                Scope (\_GPE)
                {
                    Method (_L07, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
                    {
                        \_SB.PCI0.SMB.HSTS = 0x20
                    }
                    Method (_L1B, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
                    {
                        \_SB.PCI0.SMB.HSTS = 0x20
                    }
                }
            }
            Device (USBE)
            {
                Name (_ADR, 0x001A0000)  // _ADR: Address
                Name (_S4D, 0x02)  // _S4D: S4 Device State
                Name (_S3D, 0x02)  // _S3D: S3 Device State
                Name (_S2D, 0x02)  // _S2D: S2 Device State
                Name (_S1D, 0x02)  // _S1D: S1 Device State
                Device (HUBN)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Device (PR10)
                    {
                        Name (_ADR, One)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            Zero, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                        {
                            0x81, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            0x30, 
                            0x1C, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero
                        })
                        Device (PR30)
                        {
                            Name (_ADR, One)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xE1, 
                                0x1C, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                        Device (PR31)
                        {
                            Name (_ADR, 0x02)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xE1, 
                                0x1D, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                        Device (PR32)
                        {
                            Name (_ADR, 0x03)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xE1, 
                                0x1D, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                        Device (PR33)
                        {
                            Name (_ADR, 0x04)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xE1, 
                                0x1E, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                        Device (PR34)
                        {
                            Name (_ADR, 0x05)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xB1, 
                                0x1E, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                        Device (PR35)
                        {
                            Name (_ADR, 0x06)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xE1, 
                                0x1E, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                    }
                }
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x0D, 0x04))
                }
            }
            Device (BR33)
            {
                Name (_ADR, 0x00110000)  // _ADR: Address
            }
            Device (NPE2)
            {
                Name (_ADR, 0x00010001)  // _ADR: Address
            }
            Device (NPE4)
            {
                Name (_ADR, 0x00020001)  // _ADR: Address
            }
            Device (NPE6)
            {
                Name (_ADR, 0x00020003)  // _ADR: Address
            }
            Device (NPE8)
            {
                Name (_ADR, 0x00030001)  // _ADR: Address
            }
            Device (NPEA)
            {
                Name (_ADR, 0x00030003)  // _ADR: Address
            }
            Device (NPE1)
            {
                Name (_ADR, 0x00010000)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR21) /* \_SB_.AR21 */
                    }
                    Return (PR21) /* \_SB_.PR21 */
                }
            }
            Device (NPE3)
            {
                Name (_ADR, 0x00020000)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR23) /* \_SB_.AR23 */
                    }
                    Return (PR23) /* \_SB_.PR23 */
                }
            }
            Device (NPE5)
            {
                Name (_ADR, 0x00020002)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
            }
            Device (NPE7)
            {
                Name (_ADR, 0x00030000)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR27) /* \_SB_.AR27 */
                    }
                    Return (PR27) /* \_SB_.PR27 */
                }
            }
            Device (NPE9)
            {
                Name (_ADR, 0x00030002)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR29) /* \_SB_.AR29 */
                    }
                    Return (PR29) /* \_SB_.PR29 */
                }
            }
            Device (SAT0)
            {
                Name (_ADR, 0x001F0002)  // _ADR: Address
                Name (^NATA, Package (0x01)
                {
                    0x001F0002
                })
                Name (\FZTF, Buffer (0x07)
                {
                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF5         /* ....... */
                })
                Name (REGF, One)
                Method (_REG, 2, NotSerialized)  // _REG: Region Availability
                {
                    If ((Arg0 == 0x02))
                    {
                        REGF = Arg1
                    }
                }
                Name (TIM0, Package (0x08)
                {
                    Package (0x04)
                    {
                        0x78, 
                        0xB4, 
                        0xF0, 
                        0x0384
                    }, 
                    Package (0x04)
                    {
                        0x23, 
                        0x21, 
                        0x10, 
                        Zero
                    }, 
                    Package (0x04)
                    {
                        0x0B, 
                        0x09, 
                        0x04, 
                        Zero
                    }, 
                    Package (0x06)
                    {
                        0x78, 
                        0x5A, 
                        0x3C, 
                        0x28, 
                        0x1E, 
                        0x14
                    }, 
                    Package (0x06)
                    {
                        Zero, 
                        One, 
                        0x02, 
                        One, 
                        0x02, 
                        One
                    }, 
                    Package (0x06)
                    {
                        Zero, 
                        Zero, 
                        Zero, 
                        One, 
                        One, 
                        One
                    }, 
                    Package (0x04)
                    {
                        0x04, 
                        0x03, 
                        0x02, 
                        Zero
                    }, 
                    Package (0x04)
                    {
                        0x02, 
                        One, 
                        Zero, 
                        Zero
                    }
                })
                Name (TMD0, Buffer (0x14) {})
                CreateDWordField (TMD0, Zero, PIO0)
                CreateDWordField (TMD0, 0x04, DMA0)
                CreateDWordField (TMD0, 0x08, PIO1)
                CreateDWordField (TMD0, 0x0C, DMA1)
                CreateDWordField (TMD0, 0x10, CHNF)
                OperationRegion (CFG2, PCI_Config, 0x40, 0x20)
                Field (CFG2, DWordAcc, NoLock, Preserve)
                {
                    PMPT,   4, 
                    PSPT,   4, 
                    PMRI,   6, 
                    Offset (0x02), 
                    SMPT,   4, 
                    SSPT,   4, 
                    SMRI,   6, 
                    Offset (0x04), 
                    PSRI,   4, 
                    SSRI,   4, 
                    Offset (0x08), 
                    PM3E,   1, 
                    PS3E,   1, 
                    SM3E,   1, 
                    SS3E,   1, 
                    Offset (0x0A), 
                    PMUT,   2, 
                        ,   2, 
                    PSUT,   2, 
                    Offset (0x0B), 
                    SMUT,   2, 
                        ,   2, 
                    SSUT,   2, 
                    Offset (0x0C), 
                    Offset (0x14), 
                    PM6E,   1, 
                    PS6E,   1, 
                    SM6E,   1, 
                    SS6E,   1, 
                    PMCR,   1, 
                    PSCR,   1, 
                    SMCR,   1, 
                    SSCR,   1, 
                        ,   4, 
                    PMAE,   1, 
                    PSAE,   1, 
                    SMAE,   1, 
                    SSAE,   1
                }
                Name (GMPT, Zero)
                Name (GMUE, Zero)
                Name (GMUT, Zero)
                Name (GMCR, Zero)
                Name (GSPT, Zero)
                Name (GSUE, Zero)
                Name (GSUT, Zero)
                Name (GSCR, Zero)
                Device (CHN0)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Method (_GTM, 0, NotSerialized)  // _GTM: Get Timing Mode
                    {
                        Local1 = (PSCR << One)
                        Local0 = (PMCR | Local1)
                        Local3 = (PMAE << 0x02)
                        Local4 = (PM6E << One)
                        Local3 |= Local4
                        Local1 = (PM3E | Local3)
                        Local3 = (PMPT << 0x04)
                        Local1 |= Local3
                        Local3 = (PSAE << 0x02)
                        Local4 = (PS6E << One)
                        Local3 |= Local4
                        Local2 = (PS3E | Local3)
                        Local3 = (PSPT << 0x04)
                        Local2 |= Local3
                        Return (GTM (PMRI, Local1, PMUT, PSRI, Local2, PSUT, Local0))
                    }
                    Method (_STM, 3, NotSerialized)  // _STM: Set Timing Mode
                    {
                        Debug = Arg0
                        TMD0 = Arg0
                        Local3 = (PMAE << 0x02)
                        Local4 = (PM6E << One)
                        Local3 |= Local4
                        Local0 = (PM3E | Local3)
                        Local3 = (PMPT << 0x04)
                        Local0 |= Local3
                        Local3 = (PSAE << 0x02)
                        Local4 = (PS6E << One)
                        Local3 |= Local4
                        Local1 = (PS3E | Local3)
                        Local3 = (PSPT << 0x04)
                        Local1 |= Local3
                        GMPT = PMRI /* \_SB_.PCI0.SAT0.PMRI */
                        GMUE = Local0
                        GMUT = PMUT /* \_SB_.PCI0.SAT0.PMUT */
                        GMCR = PMCR /* \_SB_.PCI0.SAT0.PMCR */
                        GSPT = PSRI /* \_SB_.PCI0.SAT0.PSRI */
                        GSUE = Local1
                        GSUT = PSUT /* \_SB_.PCI0.SAT0.PSUT */
                        GSCR = PSCR /* \_SB_.PCI0.SAT0.PSCR */
                        STM ()
                        PMRI = GMPT /* \_SB_.PCI0.SAT0.GMPT */
                        Local0 = GMUE /* \_SB_.PCI0.SAT0.GMUE */
                        PMUT = GMUT /* \_SB_.PCI0.SAT0.GMUT */
                        PMCR = GMCR /* \_SB_.PCI0.SAT0.GMCR */
                        Local1 = GSUE /* \_SB_.PCI0.SAT0.GSUE */
                        PSUT = GSUT /* \_SB_.PCI0.SAT0.GSUT */
                        PSCR = GSCR /* \_SB_.PCI0.SAT0.GSCR */
                        If ((Local0 & One))
                        {
                            PM3E = One
                        }
                        Else
                        {
                            PM3E = Zero
                        }
                        If ((Local0 & 0x02))
                        {
                            PM6E = One
                        }
                        Else
                        {
                            PM6E = Zero
                        }
                        If ((Local0 & 0x04))
                        {
                            PMAE = One
                        }
                        Else
                        {
                            PMAE = Zero
                        }
                        If ((Local1 & One))
                        {
                            PS3E = One
                        }
                        Else
                        {
                            PS3E = Zero
                        }
                        If ((Local1 & 0x02))
                        {
                            PS6E = One
                        }
                        Else
                        {
                            PS6E = Zero
                        }
                        If ((Local1 & 0x04))
                        {
                            PSAE = One
                        }
                        Else
                        {
                            PSAE = Zero
                        }
                        ATA0 = GTF (Zero, Arg1)
                        ATA1 = GTF (One, Arg2)
                    }
                    Device (DRV0)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
                        {
                            Return (RATA (ATA0))
                        }
                    }
                    Device (DRV1)
                    {
                        Name (_ADR, One)  // _ADR: Address
                        Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
                        {
                            Return (RATA (ATA1))
                        }
                    }
                }
                Device (CHN1)
                {
                    Name (_ADR, One)  // _ADR: Address
                    Method (_GTM, 0, NotSerialized)  // _GTM: Get Timing Mode
                    {
                        Local1 = (SSCR << One)
                        Local0 = (SMCR | Local1)
                        Local3 = (SMAE << 0x02)
                        Local4 = (SM6E << One)
                        Local3 |= Local4
                        Local1 = (SM3E | Local3)
                        Local3 = (SMPT << 0x04)
                        Local1 |= Local3
                        Local3 = (SSAE << 0x02)
                        Local4 = (SS6E << One)
                        Local3 |= Local4
                        Local2 = (SS3E | Local3)
                        Local3 = (SSPT << 0x04)
                        Local2 |= Local3
                        Return (GTM (SMRI, Local1, SMUT, SSRI, Local2, SSUT, Local0))
                    }
                    Method (_STM, 3, NotSerialized)  // _STM: Set Timing Mode
                    {
                        Debug = Arg0
                        TMD0 = Arg0
                        Local3 = (SMAE << 0x02)
                        Local4 = (SM6E << One)
                        Local3 |= Local4
                        Local0 = (SM3E | Local3)
                        Local3 = (SMPT << 0x04)
                        Local0 |= Local3
                        Local3 = (SSAE << 0x02)
                        Local4 = (SS6E << One)
                        Local3 |= Local4
                        Local1 = (SS3E | Local3)
                        Local3 = (SSPT << 0x04)
                        Local1 |= Local3
                        GMPT = SMRI /* \_SB_.PCI0.SAT0.SMRI */
                        GMUE = Local0
                        GMUT = SMUT /* \_SB_.PCI0.SAT0.SMUT */
                        GMCR = SMCR /* \_SB_.PCI0.SAT0.SMCR */
                        GSPT = SSRI /* \_SB_.PCI0.SAT0.SSRI */
                        GSUE = Local1
                        GSUT = SSUT /* \_SB_.PCI0.SAT0.SSUT */
                        GSCR = SSCR /* \_SB_.PCI0.SAT0.SSCR */
                        STM ()
                        SMRI = GMPT /* \_SB_.PCI0.SAT0.GMPT */
                        Local0 = GMUE /* \_SB_.PCI0.SAT0.GMUE */
                        SMUT = GMUT /* \_SB_.PCI0.SAT0.GMUT */
                        SMCR = GMCR /* \_SB_.PCI0.SAT0.GMCR */
                        Local1 = GSUE /* \_SB_.PCI0.SAT0.GSUE */
                        SSUT = GSUT /* \_SB_.PCI0.SAT0.GSUT */
                        SSCR = GSCR /* \_SB_.PCI0.SAT0.GSCR */
                        If ((Local0 & One))
                        {
                            SM3E = One
                        }
                        Else
                        {
                            SM3E = Zero
                        }
                        If ((Local0 & 0x02))
                        {
                            SM6E = One
                        }
                        Else
                        {
                            SM6E = Zero
                        }
                        If ((Local0 & 0x04))
                        {
                            SMAE = One
                        }
                        Else
                        {
                            SMAE = Zero
                        }
                        If ((Local1 & One))
                        {
                            SS3E = One
                        }
                        Else
                        {
                            SS3E = Zero
                        }
                        If ((Local1 & 0x02))
                        {
                            SS6E = One
                        }
                        Else
                        {
                            SS6E = Zero
                        }
                        If ((Local1 & 0x04))
                        {
                            SSAE = One
                        }
                        Else
                        {
                            SSAE = Zero
                        }
                        ATA2 = GTF (Zero, Arg1)
                        ATA3 = GTF (One, Arg2)
                    }
                    Device (DRV0)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
                        {
                            Return (RATA (ATA2))
                        }
                    }
                    Device (DRV1)
                    {
                        Name (_ADR, One)  // _ADR: Address
                        Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
                        {
                            Return (RATA (ATA3))
                        }
                    }
                }
                Method (GTM, 7, Serialized)
                {
                    PIO0 = Ones
                    PIO1 = Ones
                    DMA0 = Ones
                    DMA1 = Ones
                    CHNF = 0x10
                    If (REGF) {}
                    Else
                    {
                        Return (TMD0) /* \_SB_.PCI0.SAT0.TMD0 */
                    }
                    If ((Arg1 & 0x20))
                    {
                        CHNF |= 0x02
                    }
                    Local6 = Match (DerefOf (Index (TIM0, One)), MEQ, Arg0, MTR, Zero, 
                        Zero)
                    Local7 = DerefOf (Index (DerefOf (Index (TIM0, Zero)), Local6))
                    DMA0 = Local7
                    PIO0 = Local7
                    If ((Arg4 & 0x20))
                    {
                        CHNF |= 0x08
                    }
                    Local6 = Match (DerefOf (Index (TIM0, 0x02)), MEQ, Arg3, MTR, Zero, 
                        Zero)
                    Local7 = DerefOf (Index (DerefOf (Index (TIM0, Zero)), Local6))
                    DMA1 = Local7
                    PIO1 = Local7
                    If ((Arg1 & 0x07))
                    {
                        Local5 = Arg2
                        If ((Arg1 & 0x02))
                        {
                            Local5 += 0x02
                        }
                        If ((Arg1 & 0x04))
                        {
                            Local5 += 0x04
                        }
                        DMA0 = DerefOf (Index (DerefOf (Index (TIM0, 0x03)), Local5))
                        CHNF |= One
                    }
                    If ((Arg4 & 0x07))
                    {
                        Local5 = Arg5
                        If ((Arg4 & 0x02))
                        {
                            Local5 += 0x02
                        }
                        If ((Arg4 & 0x04))
                        {
                            Local5 += 0x04
                        }
                        DMA1 = DerefOf (Index (DerefOf (Index (TIM0, 0x03)), Local5))
                        CHNF |= 0x04
                    }
                    Debug = TMD0 /* \_SB_.PCI0.SAT0.TMD0 */
                    Return (TMD0) /* \_SB_.PCI0.SAT0.TMD0 */
                }
                Method (STM, 0, Serialized)
                {
                    If (REGF)
                    {
                        GMUE = Zero
                        GMUT = Zero
                        GSUE = Zero
                        GSUT = Zero
                        If ((CHNF & One))
                        {
                            Local0 = Match (DerefOf (Index (TIM0, 0x03)), MLE, DMA0, MTR, Zero, 
                                Zero)
                            If ((Local0 > 0x05))
                            {
                                Local0 = 0x05
                            }
                            GMUT = DerefOf (Index (DerefOf (Index (TIM0, 0x04)), Local0))
                            GMUE |= One
                            If ((Local0 > 0x02))
                            {
                                GMUE |= 0x02
                            }
                            If ((Local0 > 0x04))
                            {
                                GMUE &= 0xFD
                                GMUE |= 0x04
                            }
                        }
                        Else
                        {
                            If (((PIO0 == Ones) | (PIO0 == Zero)))
                            {
                                If (((DMA0 < Ones) & (DMA0 > Zero)))
                                {
                                    PIO0 = DMA0 /* \_SB_.PCI0.SAT0.DMA0 */
                                    GMUE |= 0x80
                                }
                            }
                        }
                        If ((CHNF & 0x04))
                        {
                            Local0 = Match (DerefOf (Index (TIM0, 0x03)), MLE, DMA1, MTR, Zero, 
                                Zero)
                            If ((Local0 > 0x05))
                            {
                                Local0 = 0x05
                            }
                            GSUT = DerefOf (Index (DerefOf (Index (TIM0, 0x04)), Local0))
                            GSUE |= One
                            If ((Local0 > 0x02))
                            {
                                GSUE |= 0x02
                            }
                            If ((Local0 > 0x04))
                            {
                                GSUE &= 0xFD
                                GSUE |= 0x04
                            }
                        }
                        Else
                        {
                            If (((PIO1 == Ones) | (PIO1 == Zero)))
                            {
                                If (((DMA1 < Ones) & (DMA1 > Zero)))
                                {
                                    PIO1 = DMA1 /* \_SB_.PCI0.SAT0.DMA1 */
                                    GSUE |= 0x80
                                }
                            }
                        }
                        If ((CHNF & 0x02))
                        {
                            GMUE |= 0x20
                        }
                        If ((CHNF & 0x08))
                        {
                            GSUE |= 0x20
                        }
                        Local0 = (Match (DerefOf (Index (TIM0, Zero)), MGE, PIO0, MTR, Zero, 
                            Zero) & 0x03)
                        Local1 = DerefOf (Index (DerefOf (Index (TIM0, One)), Local0))
                        GMPT = Local1
                        If ((Local0 < 0x03))
                        {
                            GMUE |= 0x50
                        }
                        Local0 = (Match (DerefOf (Index (TIM0, Zero)), MGE, PIO1, MTR, Zero, 
                            Zero) & 0x03)
                        Local1 = DerefOf (Index (DerefOf (Index (TIM0, 0x02)), Local0))
                        GSPT = Local1
                        If ((Local0 < 0x03))
                        {
                            GSUE |= 0x50
                        }
                    }
                }
                Name (AT01, Buffer (0x07)
                {
                     0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0xEF         /* ....... */
                })
                Name (AT02, Buffer (0x07)
                {
                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x90         /* ....... */
                })
                Name (AT03, Buffer (0x07)
                {
                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC6         /* ....... */
                })
                Name (AT04, Buffer (0x07)
                {
                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x91         /* ....... */
                })
                Name (ATA0, Buffer (0x1D) {})
                Name (ATA1, Buffer (0x1D) {})
                Name (ATA2, Buffer (0x1D) {})
                Name (ATA3, Buffer (0x1D) {})
                Name (ATAB, Buffer (0x1D) {})
                CreateByteField (ATAB, Zero, CMDC)
                Method (GTFB, 3, Serialized)
                {
                    Local0 = (CMDC * 0x38)
                    Local1 = (Local0 + 0x08)
                    CreateField (ATAB, Local1, 0x38, CMDX)
                    Local0 = (CMDC * 0x07)
                    CreateByteField (ATAB, (Local0 + 0x02), A001)
                    CreateByteField (ATAB, (Local0 + 0x06), A005)
                    CMDX = Arg0
                    A001 = Arg1
                    A005 = Arg2
                    CMDC++
                }
                Method (GTF, 2, Serialized)
                {
                    Debug = Arg1
                    CMDC = Zero
                    Name (ID49, 0x0C00)
                    Name (ID59, Zero)
                    Name (ID53, 0x04)
                    Name (ID63, 0x0F00)
                    Name (ID88, 0x0F00)
                    Name (IRDY, One)
                    Name (PIOT, Zero)
                    Name (DMAT, Zero)
                    If ((SizeOf (Arg1) == 0x0200))
                    {
                        CreateWordField (Arg1, 0x62, IW49)
                        ID49 = IW49 /* \_SB_.PCI0.SAT0.GTF_.IW49 */
                        CreateWordField (Arg1, 0x6A, IW53)
                        ID53 = IW53 /* \_SB_.PCI0.SAT0.GTF_.IW53 */
                        CreateWordField (Arg1, 0x7E, IW63)
                        ID63 = IW63 /* \_SB_.PCI0.SAT0.GTF_.IW63 */
                        CreateWordField (Arg1, 0x76, IW59)
                        ID59 = IW59 /* \_SB_.PCI0.SAT0.GTF_.IW59 */
                        CreateWordField (Arg1, 0xB0, IW88)
                        ID88 = IW88 /* \_SB_.PCI0.SAT0.GTF_.IW88 */
                    }
                    Local7 = 0xA0
                    If (Arg0)
                    {
                        Local7 = 0xB0
                        IRDY = (CHNF & 0x08)
                        If ((CHNF & 0x10))
                        {
                            PIOT = PIO1 /* \_SB_.PCI0.SAT0.PIO1 */
                        }
                        Else
                        {
                            PIOT = PIO0 /* \_SB_.PCI0.SAT0.PIO0 */
                        }
                        If ((CHNF & 0x04))
                        {
                            If ((CHNF & 0x10))
                            {
                                DMAT = DMA1 /* \_SB_.PCI0.SAT0.DMA1 */
                            }
                            Else
                            {
                                DMAT = DMA0 /* \_SB_.PCI0.SAT0.DMA0 */
                            }
                        }
                    }
                    Else
                    {
                        IRDY = (CHNF & 0x02)
                        PIOT = PIO0 /* \_SB_.PCI0.SAT0.PIO0 */
                        If ((CHNF & One))
                        {
                            DMAT = DMA0 /* \_SB_.PCI0.SAT0.DMA0 */
                        }
                    }
                    If ((((ID53 & 0x04) && (ID88 & 0xFF00)) && DMAT))
                    {
                        Local1 = Match (DerefOf (Index (TIM0, 0x03)), MLE, DMAT, MTR, Zero, 
                            Zero)
                        If ((Local1 > 0x05))
                        {
                            Local1 = 0x05
                        }
                        GTFB (AT01, (0x40 | Local1), Local7)
                    }
                    Else
                    {
                        If (((ID63 & 0xFF00) && PIOT))
                        {
                            Local0 = (Match (DerefOf (Index (TIM0, Zero)), MGE, PIOT, MTR, Zero, 
                                Zero) & 0x03)
                            Local1 = (0x20 | DerefOf (Index (DerefOf (Index (TIM0, 0x07)), Local0)))
                            GTFB (AT01, Local1, Local7)
                        }
                    }
                    If (IRDY)
                    {
                        Local0 = (Match (DerefOf (Index (TIM0, Zero)), MGE, PIOT, MTR, Zero, 
                            Zero) & 0x03)
                        Local1 = (0x08 | DerefOf (Index (DerefOf (Index (TIM0, 0x06)), Local0)))
                        GTFB (AT01, Local1, Local7)
                    }
                    Else
                    {
                        If ((ID49 & 0x0400))
                        {
                            GTFB (AT01, One, Local7)
                        }
                    }
                    If (((ID59 & 0x0100) && (ID59 & 0xFF)))
                    {
                        GTFB (AT03, (ID59 & 0xFF), Local7)
                    }
                    Debug = ATAB /* \_SB_.PCI0.SAT0.ATAB */
                    Return (ATAB) /* \_SB_.PCI0.SAT0.ATAB */
                }
                Method (RATA, 1, NotSerialized)
                {
                    CreateByteField (Arg0, Zero, CMDN)
                    Local0 = (CMDN * 0x38)
                    CreateField (Arg0, 0x08, Local0, RETB)
                    Debug = RETB /* \_SB_.PCI0.SAT0.RATA.RETB */
                    Return (Concatenate (RETB, FZTF))
                }
            }
            Device (SAT1)
            {
                Name (_ADR, 0x001F0005)  // _ADR: Address
                Name (REGF, One)
                Method (_REG, 2, NotSerialized)  // _REG: Region Availability
                {
                    If ((Arg0 == 0x02))
                    {
                        REGF = Arg1
                    }
                }
                Name (TIM0, Package (0x08)
                {
                    Package (0x04)
                    {
                        0x78, 
                        0xB4, 
                        0xF0, 
                        0x0384
                    }, 
                    Package (0x04)
                    {
                        0x23, 
                        0x21, 
                        0x10, 
                        Zero
                    }, 
                    Package (0x04)
                    {
                        0x0B, 
                        0x09, 
                        0x04, 
                        Zero
                    }, 
                    Package (0x06)
                    {
                        0x78, 
                        0x5A, 
                        0x3C, 
                        0x28, 
                        0x1E, 
                        0x14
                    }, 
                    Package (0x06)
                    {
                        Zero, 
                        One, 
                        0x02, 
                        One, 
                        0x02, 
                        One
                    }, 
                    Package (0x06)
                    {
                        Zero, 
                        Zero, 
                        Zero, 
                        One, 
                        One, 
                        One
                    }, 
                    Package (0x04)
                    {
                        0x04, 
                        0x03, 
                        0x02, 
                        Zero
                    }, 
                    Package (0x04)
                    {
                        0x02, 
                        One, 
                        Zero, 
                        Zero
                    }
                })
                Name (TMD0, Buffer (0x14) {})
                CreateDWordField (TMD0, Zero, PIO0)
                CreateDWordField (TMD0, 0x04, DMA0)
                CreateDWordField (TMD0, 0x08, PIO1)
                CreateDWordField (TMD0, 0x0C, DMA1)
                CreateDWordField (TMD0, 0x10, CHNF)
                OperationRegion (CFG2, PCI_Config, 0x40, 0x20)
                Field (CFG2, DWordAcc, NoLock, Preserve)
                {
                    PMPT,   4, 
                    PSPT,   4, 
                    PMRI,   6, 
                    Offset (0x02), 
                    SMPT,   4, 
                    SSPT,   4, 
                    SMRI,   6, 
                    Offset (0x04), 
                    PSRI,   4, 
                    SSRI,   4, 
                    Offset (0x08), 
                    PM3E,   1, 
                    PS3E,   1, 
                    SM3E,   1, 
                    SS3E,   1, 
                    Offset (0x0A), 
                    PMUT,   2, 
                        ,   2, 
                    PSUT,   2, 
                    Offset (0x0B), 
                    SMUT,   2, 
                        ,   2, 
                    SSUT,   2, 
                    Offset (0x0C), 
                    Offset (0x14), 
                    PM6E,   1, 
                    PS6E,   1, 
                    SM6E,   1, 
                    SS6E,   1, 
                    PMCR,   1, 
                    PSCR,   1, 
                    SMCR,   1, 
                    SSCR,   1, 
                        ,   4, 
                    PMAE,   1, 
                    PSAE,   1, 
                    SMAE,   1, 
                    SSAE,   1
                }
                Name (GMPT, Zero)
                Name (GMUE, Zero)
                Name (GMUT, Zero)
                Name (GMCR, Zero)
                Name (GSPT, Zero)
                Name (GSUE, Zero)
                Name (GSUT, Zero)
                Name (GSCR, Zero)
                Device (CHN0)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Method (_GTM, 0, NotSerialized)  // _GTM: Get Timing Mode
                    {
                        Local1 = (PSCR << One)
                        Local0 = (PMCR | Local1)
                        Local3 = (PMAE << 0x02)
                        Local4 = (PM6E << One)
                        Local3 |= Local4
                        Local1 = (PM3E | Local3)
                        Local3 = (PMPT << 0x04)
                        Local1 |= Local3
                        Local3 = (PSAE << 0x02)
                        Local4 = (PS6E << One)
                        Local3 |= Local4
                        Local2 = (PS3E | Local3)
                        Local3 = (PSPT << 0x04)
                        Local2 |= Local3
                        Return (GTM (PMRI, Local1, PMUT, PSRI, Local2, PSUT, Local0))
                    }
                    Method (_STM, 3, NotSerialized)  // _STM: Set Timing Mode
                    {
                        Debug = Arg0
                        TMD0 = Arg0
                        Local3 = (PMAE << 0x02)
                        Local4 = (PM6E << One)
                        Local3 |= Local4
                        Local0 = (PM3E | Local3)
                        Local3 = (PMPT << 0x04)
                        Local0 |= Local3
                        Local3 = (PSAE << 0x02)
                        Local4 = (PS6E << One)
                        Local3 |= Local4
                        Local1 = (PS3E | Local3)
                        Local3 = (PSPT << 0x04)
                        Local1 |= Local3
                        GMPT = PMRI /* \_SB_.PCI0.SAT1.PMRI */
                        GMUE = Local0
                        GMUT = PMUT /* \_SB_.PCI0.SAT1.PMUT */
                        GMCR = PMCR /* \_SB_.PCI0.SAT1.PMCR */
                        GSPT = PSRI /* \_SB_.PCI0.SAT1.PSRI */
                        GSUE = Local1
                        GSUT = PSUT /* \_SB_.PCI0.SAT1.PSUT */
                        GSCR = PSCR /* \_SB_.PCI0.SAT1.PSCR */
                        STM ()
                        PMRI = GMPT /* \_SB_.PCI0.SAT1.GMPT */
                        Local0 = GMUE /* \_SB_.PCI0.SAT1.GMUE */
                        PMUT = GMUT /* \_SB_.PCI0.SAT1.GMUT */
                        PMCR = GMCR /* \_SB_.PCI0.SAT1.GMCR */
                        Local1 = GSUE /* \_SB_.PCI0.SAT1.GSUE */
                        PSUT = GSUT /* \_SB_.PCI0.SAT1.GSUT */
                        PSCR = GSCR /* \_SB_.PCI0.SAT1.GSCR */
                        If ((Local0 & One))
                        {
                            PM3E = One
                        }
                        Else
                        {
                            PM3E = Zero
                        }
                        If ((Local0 & 0x02))
                        {
                            PM6E = One
                        }
                        Else
                        {
                            PM6E = Zero
                        }
                        If ((Local0 & 0x04))
                        {
                            PMAE = One
                        }
                        Else
                        {
                            PMAE = Zero
                        }
                        If ((Local1 & One))
                        {
                            PS3E = One
                        }
                        Else
                        {
                            PS3E = Zero
                        }
                        If ((Local1 & 0x02))
                        {
                            PS6E = One
                        }
                        Else
                        {
                            PS6E = Zero
                        }
                        If ((Local1 & 0x04))
                        {
                            PSAE = One
                        }
                        Else
                        {
                            PSAE = Zero
                        }
                        ATA0 = GTF (Zero, Arg1)
                        ATA1 = GTF (One, Arg2)
                    }
                    Device (DRV0)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
                        {
                            Return (RATA (ATA0))
                        }
                    }
                    Device (DRV1)
                    {
                        Name (_ADR, One)  // _ADR: Address
                        Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
                        {
                            Return (RATA (ATA1))
                        }
                    }
                }
                Device (CHN1)
                {
                    Name (_ADR, One)  // _ADR: Address
                    Method (_GTM, 0, NotSerialized)  // _GTM: Get Timing Mode
                    {
                        Local1 = (SSCR << One)
                        Local0 = (SMCR | Local1)
                        Local3 = (SMAE << 0x02)
                        Local4 = (SM6E << One)
                        Local3 |= Local4
                        Local1 = (SM3E | Local3)
                        Local3 = (SMPT << 0x04)
                        Local1 |= Local3
                        Local3 = (SSAE << 0x02)
                        Local4 = (SS6E << One)
                        Local3 |= Local4
                        Local2 = (SS3E | Local3)
                        Local3 = (SSPT << 0x04)
                        Local2 |= Local3
                        Return (GTM (SMRI, Local1, SMUT, SSRI, Local2, SSUT, Local0))
                    }
                    Method (_STM, 3, NotSerialized)  // _STM: Set Timing Mode
                    {
                        Debug = Arg0
                        TMD0 = Arg0
                        Local3 = (SMAE << 0x02)
                        Local4 = (SM6E << One)
                        Local3 |= Local4
                        Local0 = (SM3E | Local3)
                        Local3 = (SMPT << 0x04)
                        Local0 |= Local3
                        Local3 = (SSAE << 0x02)
                        Local4 = (SS6E << One)
                        Local3 |= Local4
                        Local1 = (SS3E | Local3)
                        Local3 = (SSPT << 0x04)
                        Local1 |= Local3
                        GMPT = SMRI /* \_SB_.PCI0.SAT1.SMRI */
                        GMUE = Local0
                        GMUT = SMUT /* \_SB_.PCI0.SAT1.SMUT */
                        GMCR = SMCR /* \_SB_.PCI0.SAT1.SMCR */
                        GSPT = SSRI /* \_SB_.PCI0.SAT1.SSRI */
                        GSUE = Local1
                        GSUT = SSUT /* \_SB_.PCI0.SAT1.SSUT */
                        GSCR = SSCR /* \_SB_.PCI0.SAT1.SSCR */
                        STM ()
                        SMRI = GMPT /* \_SB_.PCI0.SAT1.GMPT */
                        Local0 = GMUE /* \_SB_.PCI0.SAT1.GMUE */
                        SMUT = GMUT /* \_SB_.PCI0.SAT1.GMUT */
                        SMCR = GMCR /* \_SB_.PCI0.SAT1.GMCR */
                        Local1 = GSUE /* \_SB_.PCI0.SAT1.GSUE */
                        SSUT = GSUT /* \_SB_.PCI0.SAT1.GSUT */
                        SSCR = GSCR /* \_SB_.PCI0.SAT1.GSCR */
                        If ((Local0 & One))
                        {
                            SM3E = One
                        }
                        Else
                        {
                            SM3E = Zero
                        }
                        If ((Local0 & 0x02))
                        {
                            SM6E = One
                        }
                        Else
                        {
                            SM6E = Zero
                        }
                        If ((Local0 & 0x04))
                        {
                            SMAE = One
                        }
                        Else
                        {
                            SMAE = Zero
                        }
                        If ((Local1 & One))
                        {
                            SS3E = One
                        }
                        Else
                        {
                            SS3E = Zero
                        }
                        If ((Local1 & 0x02))
                        {
                            SS6E = One
                        }
                        Else
                        {
                            SS6E = Zero
                        }
                        If ((Local1 & 0x04))
                        {
                            SSAE = One
                        }
                        Else
                        {
                            SSAE = Zero
                        }
                        ATA2 = GTF (Zero, Arg1)
                        ATA3 = GTF (One, Arg2)
                    }
                    Device (DRV0)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
                        {
                            Return (RATA (ATA2))
                        }
                    }
                    Device (DRV1)
                    {
                        Name (_ADR, One)  // _ADR: Address
                        Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
                        {
                            Return (RATA (ATA3))
                        }
                    }
                }
                Method (GTM, 7, Serialized)
                {
                    PIO0 = Ones
                    PIO1 = Ones
                    DMA0 = Ones
                    DMA1 = Ones
                    CHNF = 0x10
                    If (REGF) {}
                    Else
                    {
                        Return (TMD0) /* \_SB_.PCI0.SAT1.TMD0 */
                    }
                    If ((Arg1 & 0x20))
                    {
                        CHNF |= 0x02
                    }
                    Local6 = Match (DerefOf (Index (TIM0, One)), MEQ, Arg0, MTR, Zero, 
                        Zero)
                    Local7 = DerefOf (Index (DerefOf (Index (TIM0, Zero)), Local6))
                    DMA0 = Local7
                    PIO0 = Local7
                    If ((Arg4 & 0x20))
                    {
                        CHNF |= 0x08
                    }
                    Local6 = Match (DerefOf (Index (TIM0, 0x02)), MEQ, Arg3, MTR, Zero, 
                        Zero)
                    Local7 = DerefOf (Index (DerefOf (Index (TIM0, Zero)), Local6))
                    DMA1 = Local7
                    PIO1 = Local7
                    If ((Arg1 & 0x07))
                    {
                        Local5 = Arg2
                        If ((Arg1 & 0x02))
                        {
                            Local5 += 0x02
                        }
                        If ((Arg1 & 0x04))
                        {
                            Local5 += 0x04
                        }
                        DMA0 = DerefOf (Index (DerefOf (Index (TIM0, 0x03)), Local5))
                        CHNF |= One
                    }
                    If ((Arg4 & 0x07))
                    {
                        Local5 = Arg5
                        If ((Arg4 & 0x02))
                        {
                            Local5 += 0x02
                        }
                        If ((Arg4 & 0x04))
                        {
                            Local5 += 0x04
                        }
                        DMA1 = DerefOf (Index (DerefOf (Index (TIM0, 0x03)), Local5))
                        CHNF |= 0x04
                    }
                    Debug = TMD0 /* \_SB_.PCI0.SAT1.TMD0 */
                    Return (TMD0) /* \_SB_.PCI0.SAT1.TMD0 */
                }
                Method (STM, 0, Serialized)
                {
                    If (REGF)
                    {
                        GMUE = Zero
                        GMUT = Zero
                        GSUE = Zero
                        GSUT = Zero
                        If ((CHNF & One))
                        {
                            Local0 = Match (DerefOf (Index (TIM0, 0x03)), MLE, DMA0, MTR, Zero, 
                                Zero)
                            If ((Local0 > 0x05))
                            {
                                Local0 = 0x05
                            }
                            GMUT = DerefOf (Index (DerefOf (Index (TIM0, 0x04)), Local0))
                            GMUE |= One
                            If ((Local0 > 0x02))
                            {
                                GMUE |= 0x02
                            }
                            If ((Local0 > 0x04))
                            {
                                GMUE &= 0xFD
                                GMUE |= 0x04
                            }
                        }
                        Else
                        {
                            If (((PIO0 == Ones) | (PIO0 == Zero)))
                            {
                                If (((DMA0 < Ones) & (DMA0 > Zero)))
                                {
                                    PIO0 = DMA0 /* \_SB_.PCI0.SAT1.DMA0 */
                                    GMUE |= 0x80
                                }
                            }
                        }
                        If ((CHNF & 0x04))
                        {
                            Local0 = Match (DerefOf (Index (TIM0, 0x03)), MLE, DMA1, MTR, Zero, 
                                Zero)
                            If ((Local0 > 0x05))
                            {
                                Local0 = 0x05
                            }
                            GSUT = DerefOf (Index (DerefOf (Index (TIM0, 0x04)), Local0))
                            GSUE |= One
                            If ((Local0 > 0x02))
                            {
                                GSUE |= 0x02
                            }
                            If ((Local0 > 0x04))
                            {
                                GSUE &= 0xFD
                                GSUE |= 0x04
                            }
                        }
                        Else
                        {
                            If (((PIO1 == Ones) | (PIO1 == Zero)))
                            {
                                If (((DMA1 < Ones) & (DMA1 > Zero)))
                                {
                                    PIO1 = DMA1 /* \_SB_.PCI0.SAT1.DMA1 */
                                    GSUE |= 0x80
                                }
                            }
                        }
                        If ((CHNF & 0x02))
                        {
                            GMUE |= 0x20
                        }
                        If ((CHNF & 0x08))
                        {
                            GSUE |= 0x20
                        }
                        Local0 = (Match (DerefOf (Index (TIM0, Zero)), MGE, PIO0, MTR, Zero, 
                            Zero) & 0x03)
                        Local1 = DerefOf (Index (DerefOf (Index (TIM0, One)), Local0))
                        GMPT = Local1
                        If ((Local0 < 0x03))
                        {
                            GMUE |= 0x50
                        }
                        Local0 = (Match (DerefOf (Index (TIM0, Zero)), MGE, PIO1, MTR, Zero, 
                            Zero) & 0x03)
                        Local1 = DerefOf (Index (DerefOf (Index (TIM0, 0x02)), Local0))
                        GSPT = Local1
                        If ((Local0 < 0x03))
                        {
                            GSUE |= 0x50
                        }
                    }
                }
                Name (AT01, Buffer (0x07)
                {
                     0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0xEF         /* ....... */
                })
                Name (AT02, Buffer (0x07)
                {
                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x90         /* ....... */
                })
                Name (AT03, Buffer (0x07)
                {
                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC6         /* ....... */
                })
                Name (AT04, Buffer (0x07)
                {
                     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x91         /* ....... */
                })
                Name (ATA0, Buffer (0x1D) {})
                Name (ATA1, Buffer (0x1D) {})
                Name (ATA2, Buffer (0x1D) {})
                Name (ATA3, Buffer (0x1D) {})
                Name (ATAB, Buffer (0x1D) {})
                CreateByteField (ATAB, Zero, CMDC)
                Method (GTFB, 3, Serialized)
                {
                    Local0 = (CMDC * 0x38)
                    Local1 = (Local0 + 0x08)
                    CreateField (ATAB, Local1, 0x38, CMDX)
                    Local0 = (CMDC * 0x07)
                    CreateByteField (ATAB, (Local0 + 0x02), A001)
                    CreateByteField (ATAB, (Local0 + 0x06), A005)
                    CMDX = Arg0
                    A001 = Arg1
                    A005 = Arg2
                    CMDC++
                }
                Method (GTF, 2, Serialized)
                {
                    Debug = Arg1
                    CMDC = Zero
                    Name (ID49, 0x0C00)
                    Name (ID59, Zero)
                    Name (ID53, 0x04)
                    Name (ID63, 0x0F00)
                    Name (ID88, 0x0F00)
                    Name (IRDY, One)
                    Name (PIOT, Zero)
                    Name (DMAT, Zero)
                    If ((SizeOf (Arg1) == 0x0200))
                    {
                        CreateWordField (Arg1, 0x62, IW49)
                        ID49 = IW49 /* \_SB_.PCI0.SAT1.GTF_.IW49 */
                        CreateWordField (Arg1, 0x6A, IW53)
                        ID53 = IW53 /* \_SB_.PCI0.SAT1.GTF_.IW53 */
                        CreateWordField (Arg1, 0x7E, IW63)
                        ID63 = IW63 /* \_SB_.PCI0.SAT1.GTF_.IW63 */
                        CreateWordField (Arg1, 0x76, IW59)
                        ID59 = IW59 /* \_SB_.PCI0.SAT1.GTF_.IW59 */
                        CreateWordField (Arg1, 0xB0, IW88)
                        ID88 = IW88 /* \_SB_.PCI0.SAT1.GTF_.IW88 */
                    }
                    Local7 = 0xA0
                    If (Arg0)
                    {
                        Local7 = 0xB0
                        IRDY = (CHNF & 0x08)
                        If ((CHNF & 0x10))
                        {
                            PIOT = PIO1 /* \_SB_.PCI0.SAT1.PIO1 */
                        }
                        Else
                        {
                            PIOT = PIO0 /* \_SB_.PCI0.SAT1.PIO0 */
                        }
                        If ((CHNF & 0x04))
                        {
                            If ((CHNF & 0x10))
                            {
                                DMAT = DMA1 /* \_SB_.PCI0.SAT1.DMA1 */
                            }
                            Else
                            {
                                DMAT = DMA0 /* \_SB_.PCI0.SAT1.DMA0 */
                            }
                        }
                    }
                    Else
                    {
                        IRDY = (CHNF & 0x02)
                        PIOT = PIO0 /* \_SB_.PCI0.SAT1.PIO0 */
                        If ((CHNF & One))
                        {
                            DMAT = DMA0 /* \_SB_.PCI0.SAT1.DMA0 */
                        }
                    }
                    If ((((ID53 & 0x04) && (ID88 & 0xFF00)) && DMAT))
                    {
                        Local1 = Match (DerefOf (Index (TIM0, 0x03)), MLE, DMAT, MTR, Zero, 
                            Zero)
                        If ((Local1 > 0x05))
                        {
                            Local1 = 0x05
                        }
                        GTFB (AT01, (0x40 | Local1), Local7)
                    }
                    Else
                    {
                        If (((ID63 & 0xFF00) && PIOT))
                        {
                            Local0 = (Match (DerefOf (Index (TIM0, Zero)), MGE, PIOT, MTR, Zero, 
                                Zero) & 0x03)
                            Local1 = (0x20 | DerefOf (Index (DerefOf (Index (TIM0, 0x07)), Local0)))
                            GTFB (AT01, Local1, Local7)
                        }
                    }
                    If (IRDY)
                    {
                        Local0 = (Match (DerefOf (Index (TIM0, Zero)), MGE, PIOT, MTR, Zero, 
                            Zero) & 0x03)
                        Local1 = (0x08 | DerefOf (Index (DerefOf (Index (TIM0, 0x06)), Local0)))
                        GTFB (AT01, Local1, Local7)
                    }
                    Else
                    {
                        If ((ID49 & 0x0400))
                        {
                            GTFB (AT01, One, Local7)
                        }
                    }
                    If (((ID59 & 0x0100) && (ID59 & 0xFF)))
                    {
                        GTFB (AT03, (ID59 & 0xFF), Local7)
                    }
                    Debug = ATAB /* \_SB_.PCI0.SAT1.ATAB */
                    Return (ATAB) /* \_SB_.PCI0.SAT1.ATAB */
                }
                Method (RATA, 1, NotSerialized)
                {
                    CreateByteField (Arg0, Zero, CMDN)
                    Local0 = (CMDN * 0x38)
                    CreateField (Arg0, 0x08, Local0, RETB)
                    Debug = RETB /* \_SB_.PCI0.SAT1.RATA.RETB */
                    Return (Concatenate (RETB, FZTF))
                }
            }
            Device (PEX0)
            {
                Name (_ADR, 0x001C0000)  // _ADR: Address
                OperationRegion (PXRC, PCI_Config, Zero, 0x0100)
                Field (PXRC, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x60), 
                    Offset (0x62), 
                    PMS,    1, 
                    PMP,    1, 
                    Offset (0xD8), 
                        ,   30, 
                    HPE,    1, 
                    PCE,    1, 
                        ,   30, 
                    HPS,    1, 
                    PCS,    1
                }
                Method (CSS, 0, NotSerialized)
                {
                    PMS = One
                    PCS = One
                    PMS = One
                }
                Method (SPRT, 1, NotSerialized)
                {
                    CSS ()
                    PCE = One
                    CSS ()
                }
                Method (WPRT, 1, NotSerialized)
                {
                    PCE = Zero
                    CSS ()
                }
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR11) /* \_SB_.AR11 */
                    }
                    Return (PR11) /* \_SB_.PR11 */
                }
            }
            Device (PEX1)
            {
                Name (_ADR, 0x001C0001)  // _ADR: Address
                OperationRegion (PXRC, PCI_Config, Zero, 0x0100)
                Field (PXRC, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x60), 
                    Offset (0x62), 
                    PMS,    1, 
                    PMP,    1, 
                    Offset (0xD8), 
                        ,   30, 
                    HPE,    1, 
                    PCE,    1, 
                        ,   30, 
                    HPS,    1, 
                    PCS,    1
                }
                Method (CSS, 0, NotSerialized)
                {
                    PMS = One
                    PCS = One
                    PMS = One
                }
                Method (SPRT, 1, NotSerialized)
                {
                    CSS ()
                    PCE = One
                    CSS ()
                }
                Method (WPRT, 1, NotSerialized)
                {
                    PCE = Zero
                    CSS ()
                }
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR12) /* \_SB_.AR12 */
                    }
                    Return (PR12) /* \_SB_.PR12 */
                }
            }
            Device (PEX2)
            {
                Name (_ADR, 0x001C0002)  // _ADR: Address
                OperationRegion (PXRC, PCI_Config, Zero, 0x0100)
                Field (PXRC, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x60), 
                    Offset (0x62), 
                    PMS,    1, 
                    PMP,    1, 
                    Offset (0xD8), 
                        ,   30, 
                    HPE,    1, 
                    PCE,    1, 
                        ,   30, 
                    HPS,    1, 
                    PCS,    1
                }
                Method (CSS, 0, NotSerialized)
                {
                    PMS = One
                    PCS = One
                    PMS = One
                }
                Method (SPRT, 1, NotSerialized)
                {
                    CSS ()
                    PCE = One
                    CSS ()
                }
                Method (WPRT, 1, NotSerialized)
                {
                    PCE = Zero
                    CSS ()
                }
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR13) /* \_SB_.AR13 */
                    }
                    Return (PR13) /* \_SB_.PR13 */
                }
            }
            Device (PEX3)
            {
                Name (_ADR, 0x001C0003)  // _ADR: Address
                OperationRegion (PXRC, PCI_Config, Zero, 0x0100)
                Field (PXRC, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x60), 
                    Offset (0x62), 
                    PMS,    1, 
                    PMP,    1, 
                    Offset (0xD8), 
                        ,   30, 
                    HPE,    1, 
                    PCE,    1, 
                        ,   30, 
                    HPS,    1, 
                    PCS,    1
                }
                Method (CSS, 0, NotSerialized)
                {
                    PMS = One
                    PCS = One
                    PMS = One
                }
                Method (SPRT, 1, NotSerialized)
                {
                    CSS ()
                    PCE = One
                    CSS ()
                }
                Method (WPRT, 1, NotSerialized)
                {
                    PCE = Zero
                    CSS ()
                }
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR14) /* \_SB_.AR14 */
                    }
                    Return (PR14) /* \_SB_.PR14 */
                }
                Device (ASMX)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Device (RHUB)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            Zero, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                        {
                            0x81, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            0x30, 
                            0x1C, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero
                        })
                        Device (GHUB)
                        {
                            Name (_ADR, One)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0x30, 
                                0x1C, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                    }
                }
            }
            Device (PEX4)
            {
                Name (_ADR, 0x001C0004)  // _ADR: Address
                OperationRegion (PXRC, PCI_Config, Zero, 0x0100)
                Field (PXRC, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x60), 
                    Offset (0x62), 
                    PMS,    1, 
                    PMP,    1, 
                    Offset (0xD8), 
                        ,   30, 
                    HPE,    1, 
                    PCE,    1, 
                        ,   30, 
                    HPS,    1, 
                    PCS,    1
                }
                Method (CSS, 0, NotSerialized)
                {
                    PMS = One
                    PCS = One
                    PMS = One
                }
                Method (SPRT, 1, NotSerialized)
                {
                    CSS ()
                    PCE = One
                    CSS ()
                }
                Method (WPRT, 1, NotSerialized)
                {
                    PCE = Zero
                    CSS ()
                }
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR15) /* \_SB_.AR15 */
                    }
                    Return (PR15) /* \_SB_.PR15 */
                }
            }
            Device (PEX5)
            {
                Name (_ADR, 0x001C0005)  // _ADR: Address
                OperationRegion (PXRC, PCI_Config, Zero, 0x0100)
                Field (PXRC, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x60), 
                    Offset (0x62), 
                    PMS,    1, 
                    PMP,    1, 
                    Offset (0xD8), 
                        ,   30, 
                    HPE,    1, 
                    PCE,    1, 
                        ,   30, 
                    HPS,    1, 
                    PCS,    1
                }
                Method (CSS, 0, NotSerialized)
                {
                    PMS = One
                    PCS = One
                    PMS = One
                }
                Method (SPRT, 1, NotSerialized)
                {
                    CSS ()
                    PCE = One
                    CSS ()
                }
                Method (WPRT, 1, NotSerialized)
                {
                    PCE = Zero
                    CSS ()
                }
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
            }
            Device (PEX6)
            {
                Name (_ADR, 0x001C0006)  // _ADR: Address
                OperationRegion (PXRC, PCI_Config, Zero, 0x0100)
                Field (PXRC, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x60), 
                    Offset (0x62), 
                    PMS,    1, 
                    PMP,    1, 
                    Offset (0xD8), 
                        ,   30, 
                    HPE,    1, 
                    PCE,    1, 
                        ,   30, 
                    HPS,    1, 
                    PCS,    1
                }
                Method (CSS, 0, NotSerialized)
                {
                    PMS = One
                    PCS = One
                    PMS = One
                }
                Method (SPRT, 1, NotSerialized)
                {
                    CSS ()
                    PCE = One
                    CSS ()
                }
                Method (WPRT, 1, NotSerialized)
                {
                    PCE = Zero
                    CSS ()
                }
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR17) /* \_SB_.AR17 */
                    }
                    Return (PR17) /* \_SB_.PR17 */
                }
            }
            Device (PEX7)
            {
                Name (_ADR, 0x001C0007)  // _ADR: Address
                OperationRegion (PXRC, PCI_Config, Zero, 0x0100)
                Field (PXRC, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x60), 
                    Offset (0x62), 
                    PMS,    1, 
                    PMP,    1, 
                    Offset (0xD8), 
                        ,   30, 
                    HPE,    1, 
                    PCE,    1, 
                        ,   30, 
                    HPS,    1, 
                    PCS,    1
                }
                Method (CSS, 0, NotSerialized)
                {
                    PMS = One
                    PCS = One
                    PMS = One
                }
                Method (SPRT, 1, NotSerialized)
                {
                    CSS ()
                    PCE = One
                    CSS ()
                }
                Method (WPRT, 1, NotSerialized)
                {
                    PCE = Zero
                    CSS ()
                }
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x09, 0x04))
                }
                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    If (PICM)
                    {
                        Return (AR18) /* \_SB_.AR18 */
                    }
                    Return (PR18) /* \_SB_.PR18 */
                }
            }
            Device (GBE)
            {
                Name (_ADR, 0x00190000)  // _ADR: Address
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x0D, 0x04))
                }
            }
            Device (EUSB)
            {
                Name (_ADR, 0x001D0000)  // _ADR: Address
                Name (_S4D, 0x02)  // _S4D: S4 Device State
                Name (_S3D, 0x02)  // _S3D: S3 Device State
                Name (_S2D, 0x02)  // _S2D: S2 Device State
                Name (_S1D, 0x02)  // _S1D: S1 Device State
                Device (HUBN)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Device (PR10)
                    {
                        Name (_ADR, One)  // _ADR: Address
                        Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                        {
                            0xFF, 
                            Zero, 
                            Zero, 
                            Zero
                        })
                        Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                        {
                            0x81, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            0x30, 
                            0x1C, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero, 
                            Zero
                        })
                        Device (PR30)
                        {
                            Name (_ADR, One)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xE1, 
                                0x1C, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                        Device (PR31)
                        {
                            Name (_ADR, 0x02)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xE1, 
                                0x1D, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                        Device (PR32)
                        {
                            Name (_ADR, 0x03)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xE1, 
                                0x1D, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                        Device (PR33)
                        {
                            Name (_ADR, 0x04)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xE1, 
                                0x1E, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                        Device (PR34)
                        {
                            Name (_ADR, 0x05)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xB1, 
                                0x1E, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                        Device (PR35)
                        {
                            Name (_ADR, 0x06)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xB1, 
                                0x1E, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                        Device (PR36)
                        {
                            Name (_ADR, 0x07)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xB1, 
                                0x1E, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                        Device (PR37)
                        {
                            Name (_ADR, 0x08)  // _ADR: Address
                            Name (_UPC, Package (0x04)  // _UPC: USB Port Capabilities
                            {
                                0xFF, 
                                0xFF, 
                                Zero, 
                                Zero
                            })
                            Name (_PLD, Package (0x10)  // _PLD: Physical Location of Device
                            {
                                0x81, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                0xB0, 
                                0x1E, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            })
                        }
                    }
                }
                Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
                {
                    Return (GPRW (0x0D, 0x04))
                }
            }
        }
        Scope (\_GPE)
        {
            Method (_L1D, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
            {
                \_SB.PCI0.SBRG.SIOH ()
                Notify (\_SB.PWRB, 0x02) // Device Wake
            }
            Method (_L0B, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
            {
                Notify (\_SB.PCI0.BR20, 0x02) // Device Wake
                Notify (\_SB.PWRB, 0x02) // Device Wake
            }
            Method (_L0D, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
            {
                Notify (\_SB.PCI0.USBE, 0x02) // Device Wake
                Notify (\_SB.PCI0.GBE, 0x02) // Device Wake
                Notify (\_SB.PCI0.EUSB, 0x02) // Device Wake
                Notify (\_SB.PWRB, 0x02) // Device Wake
            }
            Method (_L09, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
            {
                Notify (\_SB.PCI0.NPE1, 0x02) // Device Wake
                Notify (\_SB.PCI0.NPE3, 0x02) // Device Wake
                Notify (\_SB.PCI0.NPE5, 0x02) // Device Wake
                Notify (\_SB.PCI0.NPE7, 0x02) // Device Wake
                Notify (\_SB.PCI0.NPE9, 0x02) // Device Wake
                Notify (\_SB.PCI0.PEX0, 0x02) // Device Wake
                Notify (\_SB.PCI0.PEX1, 0x02) // Device Wake
                Notify (\_SB.PCI0.PEX2, 0x02) // Device Wake
                Notify (\_SB.PCI0.PEX3, 0x02) // Device Wake
                Notify (\_SB.PCI0.PEX4, 0x02) // Device Wake
                Notify (\_SB.PCI0.PEX5, 0x02) // Device Wake
                Notify (\_SB.PCI0.PEX6, 0x02) // Device Wake
                Notify (\_SB.PCI0.PEX7, 0x02) // Device Wake
                Notify (\_SB.PWRB, 0x02) // Device Wake
            }
        }
        Device (PWRB)
        {
            Name (_HID, EisaId ("PNP0C0C") /* Power Button Device */)  // _HID: Hardware ID
            Name (_UID, 0xAA)  // _UID: Unique ID
            Name (_STA, 0x0B)  // _STA: Status
            Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
            {
                Return (GPRW (0x1D, 0x04))
            }
        }
    }
    OperationRegion (_SB.PCI0.SBRG.PIX0, PCI_Config, 0x60, 0x0C)
    Field (\_SB.PCI0.SBRG.PIX0, ByteAcc, NoLock, Preserve)
    {
        PIRA,   8, 
        PIRB,   8, 
        PIRC,   8, 
        PIRD,   8, 
        Offset (0x08), 
        PIRE,   8, 
        PIRF,   8, 
        PIRG,   8, 
        PIRH,   8
    }
    Scope (_SB)
    {
        Name (BUFA, ResourceTemplate ()
        {
            IRQ (Level, ActiveLow, Shared, )
                {15}
        })
        CreateWordField (BUFA, One, IRA0)
        Device (LNKA)
        {
            Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
            Name (_UID, One)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = (PIRA & 0x80)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }
            Method (_PRS, 0, NotSerialized)  // _PRS: Possible Resource Settings
            {
                Return (PRSA) /* \_SB_.PRSA */
            }
            Method (_DIS, 0, NotSerialized)  // _DIS: Disable Device
            {
                PIRA |= 0x80
            }
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Local0 = (PIRA & 0x0F)
                IRA0 = (One << Local0)
                Return (BUFA) /* \_SB_.BUFA */
            }
            Method (_SRS, 1, NotSerialized)  // _SRS: Set Resource Settings
            {
                CreateWordField (Arg0, One, IRA)
                FindSetRightBit (IRA, Local0)
                Local0--
                PIRA = Local0
            }
        }
        Device (LNKB)
        {
            Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
            Name (_UID, 0x02)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = (PIRB & 0x80)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }
            Method (_PRS, 0, NotSerialized)  // _PRS: Possible Resource Settings
            {
                Return (PRSB) /* \_SB_.PRSB */
            }
            Method (_DIS, 0, NotSerialized)  // _DIS: Disable Device
            {
                PIRB |= 0x80
            }
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Local0 = (PIRB & 0x0F)
                IRA0 = (One << Local0)
                Return (BUFA) /* \_SB_.BUFA */
            }
            Method (_SRS, 1, NotSerialized)  // _SRS: Set Resource Settings
            {
                CreateWordField (Arg0, One, IRA)
                FindSetRightBit (IRA, Local0)
                Local0--
                PIRB = Local0
            }
        }
        Device (LNKC)
        {
            Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
            Name (_UID, 0x03)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = (PIRC & 0x80)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }
            Method (_PRS, 0, NotSerialized)  // _PRS: Possible Resource Settings
            {
                Return (PRSC) /* \_SB_.PRSC */
            }
            Method (_DIS, 0, NotSerialized)  // _DIS: Disable Device
            {
                PIRC |= 0x80
            }
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Local0 = (PIRC & 0x0F)
                IRA0 = (One << Local0)
                Return (BUFA) /* \_SB_.BUFA */
            }
            Method (_SRS, 1, NotSerialized)  // _SRS: Set Resource Settings
            {
                CreateWordField (Arg0, One, IRA)
                FindSetRightBit (IRA, Local0)
                Local0--
                PIRC = Local0
            }
        }
        Device (LNKD)
        {
            Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
            Name (_UID, 0x04)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = (PIRD & 0x80)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }
            Method (_PRS, 0, NotSerialized)  // _PRS: Possible Resource Settings
            {
                Return (PRSD) /* \_SB_.PRSD */
            }
            Method (_DIS, 0, NotSerialized)  // _DIS: Disable Device
            {
                PIRD |= 0x80
            }
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Local0 = (PIRD & 0x0F)
                IRA0 = (One << Local0)
                Return (BUFA) /* \_SB_.BUFA */
            }
            Method (_SRS, 1, NotSerialized)  // _SRS: Set Resource Settings
            {
                CreateWordField (Arg0, One, IRA)
                FindSetRightBit (IRA, Local0)
                Local0--
                PIRD = Local0
            }
        }
        Device (LNKE)
        {
            Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
            Name (_UID, 0x05)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = (PIRE & 0x80)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }
            Method (_PRS, 0, NotSerialized)  // _PRS: Possible Resource Settings
            {
                Return (PRSE) /* \_SB_.PRSE */
            }
            Method (_DIS, 0, NotSerialized)  // _DIS: Disable Device
            {
                PIRE |= 0x80
            }
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Local0 = (PIRE & 0x0F)
                IRA0 = (One << Local0)
                Return (BUFA) /* \_SB_.BUFA */
            }
            Method (_SRS, 1, NotSerialized)  // _SRS: Set Resource Settings
            {
                CreateWordField (Arg0, One, IRA)
                FindSetRightBit (IRA, Local0)
                Local0--
                PIRE = Local0
            }
        }
        Device (LNKF)
        {
            Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
            Name (_UID, 0x06)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = (PIRF & 0x80)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }
            Method (_PRS, 0, NotSerialized)  // _PRS: Possible Resource Settings
            {
                Return (PRSF) /* \_SB_.PRSF */
            }
            Method (_DIS, 0, NotSerialized)  // _DIS: Disable Device
            {
                PIRF |= 0x80
            }
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Local0 = (PIRF & 0x0F)
                IRA0 = (One << Local0)
                Return (BUFA) /* \_SB_.BUFA */
            }
            Method (_SRS, 1, NotSerialized)  // _SRS: Set Resource Settings
            {
                CreateWordField (Arg0, One, IRA)
                FindSetRightBit (IRA, Local0)
                Local0--
                PIRF = Local0
            }
        }
        Device (LNKG)
        {
            Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
            Name (_UID, 0x07)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = (PIRG & 0x80)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }
            Method (_PRS, 0, NotSerialized)  // _PRS: Possible Resource Settings
            {
                Return (PRSG) /* \_SB_.PRSG */
            }
            Method (_DIS, 0, NotSerialized)  // _DIS: Disable Device
            {
                PIRG |= 0x80
            }
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Local0 = (PIRG & 0x0F)
                IRA0 = (One << Local0)
                Return (BUFA) /* \_SB_.BUFA */
            }
            Method (_SRS, 1, NotSerialized)  // _SRS: Set Resource Settings
            {
                CreateWordField (Arg0, One, IRA)
                FindSetRightBit (IRA, Local0)
                Local0--
                PIRG = Local0
            }
        }
        Device (LNKH)
        {
            Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
            Name (_UID, 0x08)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Local0 = (PIRH & 0x80)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }
            Method (_PRS, 0, NotSerialized)  // _PRS: Possible Resource Settings
            {
                Return (PRSH) /* \_SB_.PRSH */
            }
            Method (_DIS, 0, NotSerialized)  // _DIS: Disable Device
            {
                PIRH |= 0x80
            }
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Local0 = (PIRH & 0x0F)
                IRA0 = (One << Local0)
                Return (BUFA) /* \_SB_.BUFA */
            }
            Method (_SRS, 1, NotSerialized)  // _SRS: Set Resource Settings
            {
                CreateWordField (Arg0, One, IRA)
                FindSetRightBit (IRA, Local0)
                Local0--
                PIRH = Local0
            }
        }
    }
    Scope (_SB.PCI0.SBRG)
    {
        Method (SIOH, 0, NotSerialized)
        {
            If ((PMFG & 0x10))
            {
                Notify (PS2K, 0x02) // Device Wake
            }
            If ((PMFG & 0x20))
            {
                Notify (PS2M, 0x02) // Device Wake
            }
        }
    }
    Scope (_SB)
    {
        OperationRegion (SSDT, SystemMemory, 0xCEFD3818, 0x079C)
        OperationRegion (CSDT, SystemMemory, 0xCEFD2C18, 0x0294)
        Name (NCST, 0x02)
        Name (NPSS, 0x0E)
        Name (HNDL, 0x80000000)
        Name (CHDL, 0x80000000)
        Name (TNLP, 0x0008)
        Name (CINT, Zero)
        Name (PDCV, 0xFFFFFFFF)
        Name (APSS, Package (0x0E)
        {
            Package (0x06)
            {
                0x0E11, 
                0x0001FBD0, 
                0x000A, 
                0x000A, 
                0x2600, 
                0x2600
            }, 
            Package (0x06)
            {
                0x0E10, 
                0x0001FBD0, 
                0x000A, 
                0x000A, 
                0x2400, 
                0x2400
            }, 
            Package (0x06)
            {
                0x0D48, 
                0x0001D4C0, 
                0x000A, 
                0x000A, 
                0x2200, 
                0x2200
            }, 
            Package (0x06)
            {
                0x0C80, 
                0x0001ADB0, 
                0x000A, 
                0x000A, 
                0x2000, 
                0x2000
            }, 
            Package (0x06)
            {
                0x0BB8, 
                0x00018A88, 
                0x000A, 
                0x000A, 
                0x1E00, 
                0x1E00
            }, 
            Package (0x06)
            {
                0x0AF0, 
                0x00016760, 
                0x000A, 
                0x000A, 
                0x1C00, 
                0x1C00
            }, 
            Package (0x06)
            {
                0x0A28, 
                0x00014820, 
                0x000A, 
                0x000A, 
                0x1A00, 
                0x1A00
            }, 
            Package (0x06)
            {
                0x0960, 
                0x000128E0, 
                0x000A, 
                0x000A, 
                0x1800, 
                0x1800
            }, 
            Package (0x06)
            {
                0x0898, 
                0x000109A0, 
                0x000A, 
                0x000A, 
                0x1600, 
                0x1600
            }, 
            Package (0x06)
            {
                0x07D0, 
                0x0000EA60, 
                0x000A, 
                0x000A, 
                0x1400, 
                0x1400
            }, 
            Package (0x06)
            {
                0x0708, 
                0x0000CF08, 
                0x000A, 
                0x000A, 
                0x1200, 
                0x1200
            }, 
            Package (0x06)
            {
                0x0640, 
                0x0000B3B0, 
                0x000A, 
                0x000A, 
                0x1000, 
                0x1000
            }, 
            Package (0x06)
            {
                0x0578, 
                0x00009858, 
                0x000A, 
                0x000A, 
                0x0E00, 
                0x0E00
            }, 
            Package (0x06)
            {
                0x04B0, 
                0x000080E8, 
                0x000A, 
                0x000A, 
                0x0C00, 
                0x0C00
            }
        })
        Name (PTCI, Package (0x02)
        {
            ResourceTemplate ()
            {
                Register (SystemIO, 
                    0x04,               // Bit Width
                    0x01,               // Bit Offset
                    0x0000000000000410, // Address
                    ,)
            }, 
            ResourceTemplate ()
            {
                Register (SystemIO, 
                    0x04,               // Bit Width
                    0x01,               // Bit Offset
                    0x0000000000000410, // Address
                    ,)
            }
        })
        Name (TSSI, Package (0x01)
        {
            Package (0x05)
            {
                0x64, 
                0x03E8, 
                Zero, 
                Zero, 
                Zero
            }
        })
        Name (TSSM, Package (0x08)
        {
            Package (0x05)
            {
                0x64, 
                0x03E8, 
                Zero, 
                Zero, 
                Zero
            }, 
            Package (0x05)
            {
                0x58, 
                0x036B, 
                Zero, 
                0x1E, 
                Zero
            }, 
            Package (0x05)
            {
                0x4B, 
                0x02EE, 
                Zero, 
                0x1C, 
                Zero
            }, 
            Package (0x05)
            {
                0x3F, 
                0x0271, 
                Zero, 
                0x1A, 
                Zero
            }, 
            Package (0x05)
            {
                0x32, 
                0x01F4, 
                Zero, 
                0x18, 
                Zero
            }, 
            Package (0x05)
            {
                0x26, 
                0x0177, 
                Zero, 
                0x16, 
                Zero
            }, 
            Package (0x05)
            {
                0x19, 
                0xFA, 
                Zero, 
                0x14, 
                Zero
            }, 
            Package (0x05)
            {
                0x0D, 
                0x7D, 
                Zero, 
                0x12, 
                Zero
            }
        })
        Name (C1ST, Package (0x02)
        {
            One, 
            Package (0x04)
            {
                ResourceTemplate ()
                {
                    Register (FFixedHW, 
                        0x00,               // Bit Width
                        0x00,               // Bit Offset
                        0x0000000000000000, // Address
                        ,)
                }, 
                0x01, 
                0x01, 
                0x03E8
            }
        })
        Name (CMST, Package (0x05)
        {
            0x04, 
            Package (0x04)
            {
                ResourceTemplate ()
                {
                    Register (FFixedHW, 
                        0x01,               // Bit Width
                        0x02,               // Bit Offset
                        0x0000000000000000, // Address
                        0x01,               // Access Size
                        )
                }, 
                0x01, 
                0x01, 
                0x03E8
            }, 
            Package (0x04)
            {
                ResourceTemplate ()
                {
                    Register (FFixedHW, 
                        0x01,               // Bit Width
                        0x02,               // Bit Offset
                        0x0000000000000010, // Address
                        0x03,               // Access Size
                        )
                }, 
                0x02, 
                0x50, 
                0x01F4
            }, 
            Package (0x04)
            {
                ResourceTemplate ()
                {
                    Register (FFixedHW, 
                        0x01,               // Bit Width
                        0x02,               // Bit Offset
                        0x0000000000000020, // Address
                        0x03,               // Access Size
                        )
                }, 
                0x03, 
                0x68, 
                0x015E
            }, 
            Package (0x04)
            {
                ResourceTemplate ()
                {
                    Register (FFixedHW, 
                        0x01,               // Bit Width
                        0x02,               // Bit Offset
                        0x0000000000000030, // Address
                        0x03,               // Access Size
                        )
                }, 
                0x03, 
                0x6D, 
                0x00C8
            }
        })
        Name (CIST, Package (0x05)
        {
            0x04, 
            Package (0x04)
            {
                ResourceTemplate ()
                {
                    Register (FFixedHW, 
                        0x00,               // Bit Width
                        0x00,               // Bit Offset
                        0x0000000000000000, // Address
                        ,)
                }, 
                0x01, 
                0x01, 
                0x03E8
            }, 
            Package (0x04)
            {
                ResourceTemplate ()
                {
                    Register (SystemIO, 
                        0x08,               // Bit Width
                        0x00,               // Bit Offset
                        0x0000000000000414, // Address
                        ,)
                }, 
                0x02, 
                0x50, 
                0x01F4
            }, 
            Package (0x04)
            {
                ResourceTemplate ()
                {
                    Register (SystemIO, 
                        0x08,               // Bit Width
                        0x00,               // Bit Offset
                        0x0000000000000415, // Address
                        ,)
                }, 
                0x03, 
                0x68, 
                0x015E
            }, 
            Package (0x04)
            {
                ResourceTemplate ()
                {
                    Register (SystemIO, 
                        0x08,               // Bit Width
                        0x00,               // Bit Offset
                        0x0000000000000416, // Address
                        ,)
                }, 
                0x03, 
                0x6D, 
                0x00C8
            }
        })
        Method (CST, 0, NotSerialized)
        {
            If (((PDCV & 0x0200) != 0x0200))
            {
                If ((NCST == 0x02))
                {
                    NCST = One
                }
            }
            If ((NCST == Zero))
            {
                Return (C1ST) /* \_SB_.C1ST */
            }
            If ((NCST == One))
            {
                Return (CIST) /* \_SB_.CIST */
            }
            If ((NCST == 0x02))
            {
                Return (CMST) /* \_SB_.CMST */
            }
            Return (C1ST) /* \_SB_.C1ST */
        }
        Method (PDC, 1, NotSerialized)
        {
            CreateDWordField (Arg0, Zero, REVS)
            CreateDWordField (Arg0, 0x04, SIZE)
            Local0 = SizeOf (Arg0)
            Local1 = (Local0 - 0x08)
            CreateField (Arg0, 0x40, (Local1 * 0x08), TEMP)
            Name (STS0, Buffer (0x04)
            {
                 0x00, 0x00, 0x00, 0x00                           /* .... */
            })
            Concatenate (STS0, TEMP, Local2)
            OSC (ToUUID ("4077a616-290c-47be-9ebd-d87058713953"), REVS, SIZE, Local2)
        }
        Method (OSC, 4, NotSerialized)
        {
            CreateDWordField (Arg3, Zero, STS)
            CreateDWordField (Arg3, 0x04, CAP)
            CreateDWordField (Arg0, Zero, IID0)
            CreateDWordField (Arg0, 0x04, IID1)
            CreateDWordField (Arg0, 0x08, IID2)
            CreateDWordField (Arg0, 0x0C, IID3)
            Name (UID0, ToUUID ("4077a616-290c-47be-9ebd-d87058713953"))
            CreateDWordField (UID0, Zero, EID0)
            CreateDWordField (UID0, 0x04, EID1)
            CreateDWordField (UID0, 0x08, EID2)
            CreateDWordField (UID0, 0x0C, EID3)
            If (!(((IID0 == EID0) && (IID1 == EID1)) && ((
                IID2 == EID2) && (IID3 == EID3))))
            {
                Index (STS, Zero) = 0x06
                Return (Arg3)
            }
            PDCV &= CAP /* \_SB_.OSC_.CAP_ */
            If ((CINT == Zero))
            {
                CINT = One
                If (((PDCV & 0x09) == 0x09))
                {
                    If ((NPSS != Zero))
                    {
                        Load (SSDT, HNDL) /* \_SB_.HNDL */
                        PETE = 0xC0
                    }
                }
                If (((PDCV & 0x10) == 0x10))
                {
                    If ((NCST != 0xFF))
                    {
                        Load (CSDT, CHDL) /* \_SB_.CHDL */
                    }
                }
            }
            Return (Arg3)
        }
    }
    OperationRegion (_SB.PCI0.SBRG.LPCR, PCI_Config, 0x80, 0x04)
    Field (\_SB.PCI0.SBRG.LPCR, ByteAcc, NoLock, Preserve)
    {
        CADR,   3, 
            ,   1, 
        CBDR,   3, 
        Offset (0x01), 
        LTDR,   2, 
            ,   2, 
        FDDR,   1, 
        Offset (0x02), 
        CALE,   1, 
        CBLE,   1, 
        LTLE,   1, 
        FDLE,   1, 
        Offset (0x03), 
        GLLE,   1, 
        GHLE,   1, 
        KCLE,   1, 
        MCLE,   1, 
        C1LE,   1, 
        C2LE,   1, 
        Offset (0x04)
    }
    Method (UXDV, 1, NotSerialized)
    {
        Local0 = 0xFF
        Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
        _T_0 = (Arg0 + Zero)
        If ((_T_0 == 0x03F8))
        {
            Local0 = Zero
        }
        Else
        {
            If ((_T_0 == 0x02F8))
            {
                Local0 = One
            }
            Else
            {
                If ((_T_0 == 0x0220))
                {
                    Local0 = 0x02
                }
                Else
                {
                    If ((_T_0 == 0x0228))
                    {
                        Local0 = 0x03
                    }
                    Else
                    {
                        If ((_T_0 == 0x0238))
                        {
                            Local0 = 0x04
                        }
                        Else
                        {
                            If ((_T_0 == 0x02E8))
                            {
                                Local0 = 0x05
                            }
                            Else
                            {
                                If ((_T_0 == 0x0338))
                                {
                                    Local0 = 0x06
                                }
                                Else
                                {
                                    If ((_T_0 == 0x03E8))
                                    {
                                        Local0 = 0x07
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        Return (Local0)
    }
    Method (RRIO, 4, NotSerialized)
    {
        Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
        _T_0 = (Arg0 + Zero)
        If ((_T_0 == Zero))
        {
            CALE = Zero
            Local0 = UXDV (Arg2)
            If ((Local0 != 0xFF))
            {
                CADR = Local0
            }
            If (Arg1)
            {
                CALE = One
            }
        }
        Else
        {
            If ((_T_0 == One))
            {
                CBLE = Zero
                Local0 = UXDV (Arg2)
                If ((Local0 != 0xFF))
                {
                    CBDR = Local0
                }
                If (Arg1)
                {
                    CBLE = One
                }
            }
            Else
            {
                If ((_T_0 == 0x02))
                {
                    LTLE = Zero
                    If ((Arg2 == 0x0378))
                    {
                        LTDR = Zero
                    }
                    If ((Arg2 == 0x0278))
                    {
                        LTDR = One
                    }
                    If ((Arg2 == 0x03BC))
                    {
                        LTDR = 0x02
                    }
                    If (Arg1)
                    {
                        LTLE = One
                    }
                }
                Else
                {
                    If ((_T_0 == 0x03))
                    {
                        FDLE = Zero
                        If ((Arg2 == 0x03F0))
                        {
                            FDDR = Zero
                        }
                        If ((Arg2 == 0x0370))
                        {
                            FDDR = One
                        }
                        If (Arg1)
                        {
                            FDLE = One
                        }
                    }
                    Else
                    {
                        If ((_T_0 == 0x08))
                        {
                            If ((Arg2 == 0x0200))
                            {
                                If (Arg1)
                                {
                                    GLLE = One
                                }
                                Else
                                {
                                    GLLE = Zero
                                }
                            }
                            If ((Arg2 == 0x0208))
                            {
                                If (Arg1)
                                {
                                    GHLE = One
                                }
                                Else
                                {
                                    GHLE = Zero
                                }
                            }
                        }
                        Else
                        {
                            If ((_T_0 == 0x09))
                            {
                                If ((Arg2 == 0x0200))
                                {
                                    If (Arg1)
                                    {
                                        GLLE = One
                                    }
                                    Else
                                    {
                                        GLLE = Zero
                                    }
                                }
                                If ((Arg2 == 0x0208))
                                {
                                    If (Arg1)
                                    {
                                        GHLE = One
                                    }
                                    Else
                                    {
                                        GHLE = Zero
                                    }
                                }
                            }
                            Else
                            {
                                If ((_T_0 == 0x0A))
                                {
                                    If (((Arg2 == 0x60) || (Arg2 == 0x64)))
                                    {
                                        If (Arg1)
                                        {
                                            KCLE = One
                                        }
                                        Else
                                        {
                                            KCLE = Zero
                                        }
                                    }
                                }
                                Else
                                {
                                    If ((_T_0 == 0x0B))
                                    {
                                        If (((Arg2 == 0x62) || (Arg2 == 0x66)))
                                        {
                                            If (Arg1)
                                            {
                                                MCLE = One
                                            }
                                            Else
                                            {
                                                MCLE = Zero
                                            }
                                        }
                                    }
                                    Else
                                    {
                                        If ((_T_0 == 0x0C))
                                        {
                                            If ((Arg2 == 0x2E))
                                            {
                                                If (Arg1)
                                                {
                                                    C1LE = One
                                                }
                                                Else
                                                {
                                                    C1LE = Zero
                                                }
                                            }
                                            If ((Arg2 == 0x4E))
                                            {
                                                If (Arg1)
                                                {
                                                    C2LE = One
                                                }
                                                Else
                                                {
                                                    C2LE = Zero
                                                }
                                            }
                                        }
                                        Else
                                        {
                                            If ((_T_0 == 0x0D))
                                            {
                                                If ((Arg2 == 0x2E))
                                                {
                                                    If (Arg1)
                                                    {
                                                        C1LE = One
                                                    }
                                                    Else
                                                    {
                                                        C1LE = Zero
                                                    }
                                                }
                                                If ((Arg2 == 0x4E))
                                                {
                                                    If (Arg1)
                                                    {
                                                        C2LE = One
                                                    }
                                                    Else
                                                    {
                                                        C2LE = Zero
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Method (RDMA, 3, NotSerialized)
    {
    }
    Scope (_SB)
    {
        Scope (PCI0)
        {
            Device (HPET)
            {
                Name (_HID, EisaId ("PNP0103") /* HPET System Timer */)  // _HID: Hardware ID
                Name (CRS, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0xFED00000,         // Address Base
                        0x00000400,         // Address Length
                        _Y22)
                })
                OperationRegion (HCNT, SystemMemory, HPTC, 0x04)
                Field (HCNT, DWordAcc, NoLock, Preserve)
                {
                    HPTS,   2, 
                        ,   5, 
                    HPTE,   1
                }
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If (HPTE)
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }
                Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                {
                    CreateDWordField (CRS, \_SB.PCI0.HPET._Y22._BAS, HTBS)  // _BAS: Base Address
                    Local0 = (HPTS * 0x1000)
                    HTBS = (Local0 + 0xFED00000)
                    Return (CRS) /* \_SB_.PCI0.HPET.CRS_ */
                }
            }
        }
    }
    Scope (_SB)
    {
        Scope (PCI0)
        {
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
            }
        }
    }
    Name (WOTB, Zero)
    Name (WSSB, Zero)
    Name (WAXB, Zero)
    Method (_PTS, 1, NotSerialized)  // _PTS: Prepare To Sleep
    {
        DBG8 = Arg0
        If (((Arg0 == 0x04) && (OSFL () == 0x02)))
        {
            Sleep (0x0BB8)
        }
        PTS (Arg0)
        Index (WAKP, Zero) = Zero
        Index (WAKP, One) = Zero
        WSSB = ASSB /* \ASSB */
        WOTB = AOTB /* \AOTB */
        WAXB = AAXB /* \AAXB */
        ASSB = Arg0
        AOTB = OSFL ()
        AAXB = Zero
        \_SB.SLPS = One
    }
    Method (DTGP, 5, NotSerialized)
    {
        If ((Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b")))
        {
            If ((Arg1 == One))
            {
                If ((Arg2 == Zero))
                {
                    Arg4 = Buffer (One)
                        {
                             0x03                                             /* . */
                        }
                    Return (One)
                }
                If ((Arg2 == One))
                {
                    Return (One)
                }
            }
        }
        Arg4 = Buffer (One)
            {
                 0x00                                             /* . */
            }
        Return (Zero)
    }
    Method (_WAK, 1, NotSerialized)  // _WAK: Wake
    {
        DBG8 = (Arg0 << 0x04)
        WAK (Arg0)
        If (ASSB)
        {
            ASSB = WSSB /* \WSSB */
            AOTB = WOTB /* \WOTB */
            AAXB = WAXB /* \WAXB */
        }
        If (DerefOf (Index (WAKP, Zero)))
        {
            Index (WAKP, One) = Zero
        }
        Else
        {
            Index (WAKP, One) = Arg0
        }
        Return (WAKP) /* \WAKP */
    }
    Device (OMSC)
    {
        Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
        Name (_UID, 0x0E11)  // _UID: Unique ID
    }
    Device (_SB.RMEM)
    {
        Name (_HID, EisaId ("PNP0C01") /* System Board */)  // _HID: Hardware ID
        Name (_UID, One)  // _UID: Unique ID
    }
    Scope (\)
    {
        Device (AMW0)
        {
            Name (_HID, EisaId ("PNP0C14") /* Windows Management Instrumentation Device */)  // _HID: Hardware ID
            Name (_UID, "ASUSWMI")  // _UID: Unique ID
            Name (_WDG, Buffer (0x50)
            {
                /* 0000 */  0xD0, 0x5E, 0x84, 0x97, 0x6D, 0x4E, 0xDE, 0x11,  /* .^..mN.. */
                /* 0008 */  0x8A, 0x39, 0x08, 0x00, 0x20, 0x0C, 0x9A, 0x66,  /* .9.. ..f */
                /* 0010 */  0x42, 0x43, 0x01, 0x02, 0xA0, 0x47, 0x67, 0x46,  /* BC...GgF */
                /* 0018 */  0xEC, 0x70, 0xDE, 0x11, 0x8A, 0x39, 0x08, 0x00,  /* .p...9.. */
                /* 0020 */  0x20, 0x0C, 0x9A, 0x66, 0x42, 0x44, 0x01, 0x02,  /*  ..fBD.. */
                /* 0028 */  0x72, 0x0F, 0xBC, 0xAB, 0xA1, 0x8E, 0xD1, 0x11,  /* r....... */
                /* 0030 */  0x00, 0xA0, 0xC9, 0x06, 0x29, 0x10, 0x00, 0x00,  /* ....)... */
                /* 0038 */  0xD2, 0x00, 0x01, 0x08, 0x21, 0x12, 0x90, 0x05,  /* ....!... */
                /* 0040 */  0x66, 0xD5, 0xD1, 0x11, 0xB2, 0xF0, 0x00, 0xA0,  /* f....... */
                /* 0048 */  0xC9, 0x06, 0x29, 0x10, 0x4D, 0x4F, 0x01, 0x00   /* ..).MO.. */
            })
            Name (CCAC, Zero)
            Name (ECD2, Zero)
            Name (EID2, Zero)
            Method (WED2, 1, NotSerialized)
            {
                ECD2 = Arg0
            }
            Method (WMBC, 3, NotSerialized)
            {
                Local0 = One
                Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
                _T_0 = Arg1
                If ((_T_0 == 0x43455053))
                {
                    Return (SPEC (Arg2))
                }
                Else
                {
                    If ((_T_0 == 0x50564544))
                    {
                        Return (DEVP (Arg2))
                    }
                    Else
                    {
                        If ((_T_0 == 0x50534453))
                        {
                            Return (SDSP (Arg2))
                        }
                        Else
                        {
                            If ((_T_0 == 0x50534447))
                            {
                                Return (GDSP (Arg2))
                            }
                            Else
                            {
                                If ((_T_0 == 0x53564544))
                                {
                                    Return (DEVS (Arg2))
                                }
                                Else
                                {
                                    If ((_T_0 == 0x53544344))
                                    {
                                        Return (DSTS (Arg2))
                                    }
                                    Else
                                    {
                                        If ((_T_0 == 0x44495047))
                                        {
                                            Return (GPID ())
                                        }
                                        Else
                                        {
                                            If ((_T_0 == 0x5446424B))
                                            {
                                                Return (KBFT (Arg2))
                                            }
                                            Else
                                            {
                                                If ((_T_0 == 0x59454B48))
                                                {
                                                    Return (HKEY ())
                                                }
                                                Else
                                                {
                                                    Return (Zero)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Return (Local0)
            }
            Method (RSMB, 1, Serialized)
            {
                Return (Zero)
            }
            Method (WSMB, 1, Serialized)
            {
                Return (Zero)
            }
            Method (RSMW, 1, Serialized)
            {
                Return (Zero)
            }
            Method (WSMW, 1, Serialized)
            {
                Return (Zero)
            }
            Method (RSMK, 1, Serialized)
            {
                Return (Zero)
            }
            Method (WSMK, 1, Serialized)
            {
                Return (Zero)
            }
            Method (WMBD, 3, NotSerialized)
            {
                Local0 = One
                Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
                _T_0 = Arg1
                If ((_T_0 == 0x424D5352))
                {
                    Return (RSMB (Arg2))
                }
                Else
                {
                    If ((_T_0 == 0x424D5357))
                    {
                        Return (WSMB (Arg2))
                    }
                    Else
                    {
                        If ((_T_0 == 0x574D5352))
                        {
                            Return (RSMW (Arg2))
                        }
                        Else
                        {
                            If ((_T_0 == 0x574D5357))
                            {
                                Return (WSMW (Arg2))
                            }
                            Else
                            {
                                If ((_T_0 == 0x4B4D5352))
                                {
                                    Return (RSMK (Arg2))
                                }
                                Else
                                {
                                    If ((_T_0 == 0x4B4D5357))
                                    {
                                        Return (WSMK (Arg2))
                                    }
                                    Else
                                    {
                                        Return (Zero)
                                    }
                                }
                            }
                        }
                    }
                }
                Return (Local0)
            }
            Method (_WED, 1, NotSerialized)  // _Wxx: Wake Event
            {
                If ((Arg0 == 0xD2))
                {
                    Return (EID2) /* \AMW0.EID2 */
                }
                Return (Zero)
            }
            Method (AMWR, 1, Serialized)
            {
                Local1 = Zero
                If (ECD2)
                {
                    EID2 = Arg0
                    Notify (AMW0, 0xD2) // Hardware-Specific
                    Local1 = One
                }
                Else
                {
                }
                Return (Local1)
            }
            Method (AMWN, 1, Serialized)
            {
                Local0 = AMWR (Arg0)
                Return (Local0)
            }
            Name (WQMO, Buffer (0x09A6)
            {
                /* 0000 */  0x46, 0x4F, 0x4D, 0x42, 0x01, 0x00, 0x00, 0x00,  /* FOMB.... */
                /* 0008 */  0x96, 0x09, 0x00, 0x00, 0x42, 0x38, 0x00, 0x00,  /* ....B8.. */
                /* 0010 */  0x44, 0x53, 0x00, 0x01, 0x1A, 0x7D, 0xDA, 0x54,  /* DS...}.T */
                /* 0018 */  0xA8, 0xD1, 0x9A, 0x00, 0x01, 0x06, 0x18, 0x42,  /* .......B */
                /* 0020 */  0x10, 0x07, 0x10, 0x4A, 0x29, 0x86, 0x42, 0x04,  /* ...J).B. */
                /* 0028 */  0x0A, 0x0D, 0xA1, 0x38, 0x0A, 0x60, 0x30, 0x12,  /* ...8.`0. */
                /* 0030 */  0x20, 0x24, 0x07, 0x42, 0x2E, 0x98, 0x98, 0x00,  /*  $.B.... */
                /* 0038 */  0x11, 0x10, 0xF2, 0x2A, 0xC0, 0xA6, 0x00, 0x93,  /* ...*.... */
                /* 0040 */  0x20, 0xEA, 0xDF, 0x1F, 0xA2, 0x24, 0x38, 0x94,  /*  ....$8. */
                /* 0048 */  0x10, 0x08, 0x49, 0x14, 0x60, 0x5E, 0x80, 0x6E,  /* ..I.`^.n */
                /* 0050 */  0x01, 0x86, 0x05, 0xD8, 0x16, 0x60, 0x5A, 0x80,  /* .....`Z. */
                /* 0058 */  0x63, 0x48, 0x2A, 0x0D, 0x9C, 0x12, 0x58, 0x0A,  /* cH*...X. */
                /* 0060 */  0x84, 0x84, 0x0A, 0x50, 0x2E, 0xC0, 0xB7, 0x00,  /* ...P.... */
                /* 0068 */  0xED, 0x88, 0x92, 0x2C, 0xC0, 0x32, 0x8C, 0x08,  /* ...,.2.. */
                /* 0070 */  0x3C, 0x8A, 0xC8, 0x46, 0xE3, 0x04, 0x65, 0x43,  /* <..F..eC */
                /* 0078 */  0xA3, 0x64, 0x40, 0xC8, 0xB3, 0x00, 0xEB, 0xC0,  /* .d@..... */
                /* 0080 */  0x84, 0xC0, 0xEE, 0x05, 0x98, 0x13, 0xE0, 0x4D,  /* .......M */
                /* 0088 */  0x80, 0xB8, 0x61, 0x68, 0x85, 0x07, 0x10, 0xAA,  /* ..ah.... */
                /* 0090 */  0x30, 0x01, 0xB6, 0x60, 0x84, 0x52, 0x1B, 0x8C,  /* 0..`.R.. */
                /* 0098 */  0x50, 0x1A, 0x43, 0xD0, 0x30, 0x8C, 0x12, 0xF1,  /* P.C.0... */
                /* 00A0 */  0x90, 0x3A, 0x83, 0x15, 0x4A, 0xC4, 0x30, 0x21,  /* .:..J.0! */
                /* 00A8 */  0x22, 0x54, 0x86, 0x41, 0x86, 0x15, 0x2A, 0x5A,  /* "T.A..*Z */
                /* 00B0 */  0xDC, 0x08, 0xED, 0x0F, 0x82, 0x44, 0x5B, 0xB1,  /* .....D[. */
                /* 00B8 */  0x86, 0xEA, 0x48, 0xA3, 0x41, 0x0D, 0x2F, 0xC1,  /* ..H.A./. */
                /* 00C0 */  0xE1, 0x7A, 0xA8, 0xE7, 0xD8, 0xB9, 0x00, 0xE9,  /* .z...... */
                /* 00C8 */  0xC0, 0x02, 0x09, 0x7E, 0x16, 0x75, 0x8E, 0x93,  /* ...~.u.. */
                /* 00D0 */  0x80, 0x24, 0x30, 0xD6, 0xF1, 0xB3, 0x81, 0xE3,  /* .$0..... */
                /* 00D8 */  0x5D, 0x03, 0x6A, 0xC6, 0xC7, 0xCB, 0x04, 0xC1,  /* ].j..... */
                /* 00E0 */  0xA1, 0x86, 0xE8, 0x81, 0x86, 0x3B, 0x81, 0x43,  /* .....;.C */
                /* 00E8 */  0x64, 0x80, 0x9E, 0xD3, 0xD1, 0x60, 0x0E, 0x00,  /* d....`.. */
                /* 00F0 */  0x76, 0x38, 0x19, 0xDD, 0x03, 0x4A, 0x15, 0x60,  /* v8...J.` */
                /* 00F8 */  0x76, 0xCC, 0xB2, 0x08, 0xA4, 0xF1, 0x18, 0xFA,  /* v....... */
                /* 0100 */  0x74, 0xCF, 0xE7, 0x84, 0x13, 0x58, 0xFE, 0x20,  /* t....X.  */
                /* 0108 */  0x50, 0x23, 0x33, 0xB4, 0x0D, 0x4E, 0x4B, 0x98,  /* P#3..NK. */
                /* 0110 */  0x21, 0x0F, 0xFF, 0xB0, 0x98, 0x58, 0x08, 0x7D,  /* !....X.} */
                /* 0118 */  0x10, 0x3C, 0x1E, 0x78, 0xFF, 0xFF, 0xF1, 0x80,  /* .<.x.... */
                /* 0120 */  0x47, 0xF1, 0x99, 0x40, 0x08, 0xAF, 0x04, 0xB1,  /* G..@.... */
                /* 0128 */  0x3D, 0xA0, 0xE7, 0x04, 0x03, 0x63, 0x07, 0x64,  /* =....c.d */
                /* 0130 */  0xBF, 0x02, 0x10, 0x82, 0x97, 0x39, 0x22, 0x39,  /* .....9"9 */
                /* 0138 */  0x45, 0xD0, 0x98, 0x8C, 0xD1, 0x2A, 0x84, 0x86,  /* E....*.. */
                /* 0140 */  0x10, 0xDA, 0x10, 0x67, 0x17, 0xFF, 0xE0, 0x0D,  /* ...g.... */
                /* 0148 */  0x73, 0xEE, 0x26, 0x28, 0x72, 0x04, 0xA8, 0xCF,  /* s.&(r... */
                /* 0150 */  0x84, 0x47, 0xC0, 0x8F, 0x01, 0xD1, 0x43, 0x9F,  /* .G....C. */
                /* 0158 */  0x4D, 0xF4, 0xE3, 0x89, 0x72, 0x12, 0x07, 0xE4,  /* M...r... */
                /* 0160 */  0x33, 0x83, 0x11, 0x82, 0x97, 0x7B, 0x48, 0x20,  /* 3....{H  */
                /* 0168 */  0x9A, 0xE7, 0xA0, 0x13, 0xC3, 0x39, 0x1D, 0x02,  /* .....9.. */
                /* 0170 */  0x53, 0xA3, 0x05, 0xA2, 0x09, 0x10, 0x45, 0x59,  /* S.....EY */
                /* 0178 */  0xAA, 0x6C, 0x2C, 0xD5, 0x83, 0xA0, 0x82, 0x80,  /* .l,..... */
                /* 0180 */  0x34, 0x77, 0x43, 0x9C, 0xB4, 0x91, 0x03, 0xC7,  /* 4wC..... */
                /* 0188 */  0xA8, 0x7E, 0xD8, 0x54, 0x04, 0x9C, 0x0E, 0x1B,  /* .~.T.... */
                /* 0190 */  0x1E, 0xB7, 0xE3, 0x93, 0x28, 0xFA, 0x80, 0x28,  /* ....(..( */
                /* 0198 */  0x9C, 0xC3, 0x9E, 0x39, 0x28, 0x88, 0x01, 0x9D,  /* ...9(... */
                /* 01A0 */  0x04, 0x42, 0x4E, 0x8E, 0x02, 0xA8, 0xBD, 0x68,  /* .BN....h */
                /* 01A8 */  0x58, 0x1A, 0xD7, 0xA9, 0xBD, 0x09, 0x78, 0x5A,  /* X.....xZ */
                /* 01B0 */  0x8F, 0x05, 0x87, 0x71, 0x5C, 0x67, 0x6D, 0xD1,  /* ...q\gm. */
                /* 01B8 */  0x37, 0x06, 0x3A, 0x1F, 0xDF, 0x05, 0xB8, 0x06,  /* 7.:..... */
                /* 01C0 */  0x08, 0xCD, 0xC8, 0xF0, 0x56, 0x03, 0x48, 0xC1,  /* ....V.H. */
                /* 01C8 */  0xF8, 0x49, 0xE0, 0x11, 0xC0, 0x04, 0xD6, 0x75,  /* .I.....u */
                /* 01D0 */  0x20, 0x80, 0x7E, 0xD9, 0xF0, 0xF0, 0x7D, 0xC2,  /*  .~...}. */
                /* 01D8 */  0x78, 0xBC, 0x48, 0x50, 0xDF, 0x7D, 0x00, 0x14,  /* x.HP.}.. */
                /* 01E0 */  0x40, 0x3E, 0x00, 0x58, 0xE9, 0x1D, 0x80, 0x8E,  /* @>.X.... */
                /* 01E8 */  0x21, 0x44, 0x98, 0x68, 0x46, 0xE7, 0x12, 0x56,  /* !D.hF..V */
                /* 01F0 */  0xAA, 0xFF, 0xFF, 0x68, 0xF9, 0x41, 0xC5, 0xA3,  /* ...h.A.. */
                /* 01F8 */  0x35, 0x88, 0x47, 0xEB, 0x40, 0xA3, 0x45, 0x1F,  /* 5.G.@.E. */
                /* 0200 */  0x33, 0xAC, 0x70, 0x54, 0xF2, 0x39, 0x01, 0x0D,  /* 3.pT.9.. */
                /* 0208 */  0x17, 0x06, 0x41, 0xE1, 0x07, 0x0E, 0x68, 0x80,  /* ..A...h. */
                /* 0210 */  0xA7, 0xF7, 0x66, 0xE0, 0x99, 0x18, 0xCE, 0xF3,  /* ..f..... */
                /* 0218 */  0xE5, 0x70, 0x9E, 0x2F, 0x1F, 0x8E, 0x0F, 0x14,  /* .p./.... */
                /* 0220 */  0xF0, 0x07, 0x8C, 0x25, 0x28, 0x70, 0xC2, 0x20,  /* ...%(p.  */
                /* 0228 */  0x87, 0xC7, 0x08, 0x1E, 0x2C, 0x95, 0x35, 0x2E,  /* ....,.5. */
                /* 0230 */  0xD4, 0xFD, 0xC0, 0x27, 0x1A, 0x86, 0x7D, 0xA8,  /* ...'..}. */
                /* 0238 */  0x47, 0xF3, 0x96, 0x70, 0x86, 0x6F, 0x13, 0x07,  /* G..p.o.. */
                /* 0240 */  0xF5, 0xEE, 0x61, 0xA7, 0x42, 0x2D, 0x3A, 0x84,  /* ..a.B-:. */
                /* 0248 */  0xF5, 0x48, 0x39, 0xAC, 0xD1, 0xC2, 0x1E, 0xF0,  /* .H9..... */
                /* 0250 */  0x73, 0x87, 0xEF, 0x19, 0xFC, 0x4A, 0xE3, 0x63,  /* s....J.c */
                /* 0258 */  0x08, 0x5D, 0x85, 0x4E, 0x15, 0x5C, 0x14, 0x84,  /* .].N.\.. */
                /* 0260 */  0xE2, 0xAD, 0x45, 0xC3, 0x3F, 0x0B, 0x8F, 0xEB,  /* ..E.?... */
                /* 0268 */  0x15, 0xC3, 0x57, 0x80, 0x87, 0x13, 0x9F, 0x01,  /* ..W..... */
                /* 0270 */  0xE2, 0x07, 0x3A, 0x82, 0x17, 0x11, 0x9F, 0x7D,  /* ..:....} */
                /* 0278 */  0x7C, 0x79, 0xF1, 0x21, 0x83, 0x9D, 0x2C, 0x78,  /* |y.!..,x */
                /* 0280 */  0x08, 0x0A, 0xC5, 0x38, 0x1C, 0xA0, 0x84, 0xC3,  /* ...8.... */
                /* 0288 */  0x08, 0xCE, 0x20, 0x1E, 0x9E, 0x83, 0x1C, 0x0E,  /* .. ..... */
                /* 0290 */  0xD0, 0xE7, 0x20, 0x0F, 0x84, 0x0D, 0xC2, 0x20,  /* .. ....  */
                /* 0298 */  0xE7, 0xF1, 0xF2, 0xC3, 0x2E, 0x16, 0xF8, 0xFF,  /* ........ */
                /* 02A0 */  0xFF, 0xC5, 0x02, 0x78, 0xA5, 0x19, 0x14, 0x5A,  /* ...x...Z */
                /* 02A8 */  0xCF, 0xA0, 0x20, 0x60, 0x3C, 0x3F, 0x78, 0xBC,  /* .. `<?x. */
                /* 02B0 */  0x9E, 0xAD, 0xA7, 0x05, 0xDE, 0x11, 0xFB, 0xFC,  /* ........ */
                /* 02B8 */  0x01, 0x9C, 0xC3, 0x1F, 0x5E, 0x50, 0x71, 0x87,  /* ....^Pq. */
                /* 02C0 */  0x44, 0x41, 0x7C, 0x36, 0x70, 0x94, 0xF1, 0xA2,  /* DA|6p... */
                /* 02C8 */  0x67, 0xE2, 0xC3, 0x90, 0x8F, 0x0B, 0x4F, 0x37,  /* g.....O7 */
                /* 02D0 */  0x98, 0xC3, 0x07, 0xB8, 0x47, 0xE2, 0xC3, 0x07,  /* ....G... */
                /* 02D8 */  0xF0, 0xF8, 0xFF, 0x1F, 0x3E, 0x80, 0x9F, 0x44,  /* ....>..D */
                /* 02E0 */  0x8B, 0x5A, 0x85, 0x1E, 0x3E, 0xC0, 0x15, 0xE4,  /* .Z..>... */
                /* 02E8 */  0x84, 0x84, 0x96, 0x73, 0xF8, 0x40, 0x4E, 0x24,  /* ...s.@N$ */
                /* 02F0 */  0x4C, 0x74, 0x9F, 0x91, 0x5E, 0x3C, 0x2C, 0xE1,  /* Lt..^<,. */
                /* 02F8 */  0xE0, 0x81, 0x0A, 0x4F, 0xA2, 0xF8, 0xA7, 0x02,  /* ...O.... */
                /* 0300 */  0x54, 0xE0, 0x53, 0x01, 0x05, 0x31, 0xA0, 0x0F,  /* T.S..1.. */
                /* 0308 */  0x15, 0x70, 0x66, 0xF0, 0xEC, 0x85, 0x99, 0x07,  /* .pf..... */
                /* 0310 */  0x8C, 0x33, 0x12, 0x60, 0xEB, 0x50, 0x01, 0xDE,  /* .3.`.P.. */
                /* 0318 */  0xFF, 0xFF, 0xA1, 0x02, 0x38, 0x1C, 0x90, 0x00,  /* ....8... */
                /* 0320 */  0x59, 0x12, 0x2F, 0x48, 0x0F, 0x15, 0xE0, 0x3A,  /* Y./H...: */
                /* 0328 */  0x70, 0xFA, 0x50, 0xC1, 0x0F, 0x9A, 0x16, 0x05,  /* p.P..... */
                /* 0330 */  0xA4, 0x23, 0x9E, 0x0F, 0x15, 0x30, 0x2E, 0x42,  /* .#...0.B */
                /* 0338 */  0x86, 0x7F, 0xAD, 0x3B, 0x96, 0xE7, 0x30, 0x72,  /* ...;..0r */
                /* 0340 */  0xAE, 0x40, 0xC7, 0x3E, 0x18, 0xA0, 0x82, 0x8E,  /* .@.>.... */
                /* 0348 */  0x9E, 0x82, 0x18, 0xD0, 0x29, 0x0E, 0x06, 0x68,  /* ....)..h */
                /* 0350 */  0x1D, 0xE7, 0x0A, 0xD4, 0x31, 0x0E, 0xF8, 0xFD,  /* ....1... */
                /* 0358 */  0xFF, 0xCF, 0x14, 0xC0, 0x49, 0xC4, 0xD1, 0x0A,  /* ....I... */
                /* 0360 */  0x35, 0x5C, 0x8F, 0xD5, 0x20, 0x1E, 0xAB, 0x8F,  /* 5\.. ... */
                /* 0368 */  0xA1, 0x1E, 0x2B, 0xEE, 0x1B, 0xE0, 0x23, 0x00,  /* ..+...#. */
                /* 0370 */  0xFE, 0xE8, 0x84, 0x03, 0x7B, 0xAE, 0x00, 0x4C,  /* ....{..L */
                /* 0378 */  0x7B, 0x3C, 0x57, 0x80, 0x4E, 0xDA, 0xD9, 0x07,  /* {<W.N... */
                /* 0380 */  0x1D, 0x70, 0xAD, 0x3A, 0x89, 0xE1, 0xCF, 0x71,  /* .p.:...q */
                /* 0388 */  0x8C, 0x60, 0xA8, 0xC3, 0x1B, 0x85, 0x70, 0x1C,  /* .`....p. */
                /* 0390 */  0x0A, 0x85, 0x39, 0x19, 0xD0, 0xFF, 0xFF, 0x11,  /* ..9..... */
                /* 0398 */  0x96, 0xC0, 0x51, 0x10, 0x0F, 0xCD, 0x61, 0xCE,  /* ..Q...a. */
                /* 03A0 */  0x70, 0xA0, 0x39, 0x16, 0xC0, 0xBB, 0x55, 0xB0,  /* p.9...U. */
                /* 03A8 */  0x63, 0x01, 0x6C, 0x02, 0x1F, 0x0B, 0xC0, 0x17,  /* c.l..... */
                /* 03B0 */  0x67, 0x58, 0xE8, 0xD1, 0xFA, 0xFE, 0x87, 0xBB,  /* gX...... */
                /* 03B8 */  0x3F, 0x44, 0x79, 0x29, 0xF6, 0x21, 0x07, 0xEE,  /* ?Dy).!.. */
                /* 03C0 */  0xB8, 0xC0, 0x71, 0x7A, 0x00, 0x5C, 0x1D, 0xC4,  /* ..qz.\.. */
                /* 03C8 */  0xE4, 0xF4, 0xF4, 0x00, 0xAE, 0x24, 0xA7, 0x07,  /* .....$.. */
                /* 03D0 */  0xD4, 0x80, 0xFD, 0xFF, 0xD7, 0x03, 0xA4, 0x73,  /* .......s */
                /* 03D8 */  0x02, 0xF6, 0xA2, 0xCD, 0x20, 0x4E, 0xF4, 0x79,  /* .... N.y */
                /* 03E0 */  0xC4, 0x0A, 0x8E, 0x38, 0xA8, 0xEC, 0x24, 0x4A,  /* ...8..$J */
                /* 03E8 */  0x7E, 0xC4, 0x41, 0x65, 0x1D, 0x3B, 0x05, 0x31,  /* ~.Ae.;.1 */
                /* 03F0 */  0xA0, 0x4F, 0x94, 0x80, 0x8F, 0x3B, 0x0E, 0xB0,  /* .O...;.. */
                /* 03F8 */  0xD8, 0xA8, 0x27, 0xCB, 0x23, 0x4F, 0x96, 0x82,  /* ..'.#O.. */
                /* 0400 */  0x78, 0xB2, 0xBE, 0x54, 0x00, 0x87, 0x1B, 0x0E,  /* x..T.... */
                /* 0408 */  0xB0, 0xFF, 0xFF, 0x5F, 0x2A, 0x80, 0x92, 0x43,  /* ..._*..C */
                /* 0410 */  0xA9, 0x97, 0x0A, 0x90, 0xC9, 0xBB, 0xE1, 0xA0,  /* ........ */
                /* 0418 */  0x43, 0xAE, 0x55, 0xF7, 0x3A, 0x76, 0x6C, 0xF5,  /* C.U.:vl. */
                /* 0420 */  0xB8, 0x7D, 0x93, 0xC6, 0x04, 0xBB, 0xE1, 0xA0,  /* .}...... */
                /* 0428 */  0x22, 0x51, 0x28, 0xD0, 0xB9, 0x00, 0x15, 0x01,  /* "Q(..... */
                /* 0430 */  0x8E, 0x82, 0x78, 0x68, 0x3E, 0x17, 0x58, 0xC9,  /* ..xh>.X. */
                /* 0438 */  0xB9, 0x00, 0xED, 0xFD, 0x42, 0x41, 0x06, 0xE7,  /* ....BA.. */
                /* 0440 */  0x7B, 0x81, 0x61, 0x8A, 0x1F, 0x8A, 0xEE, 0x3D,  /* {.a....= */
                /* 0448 */  0x3E, 0x17, 0x80, 0xFB, 0x8A, 0x03, 0x2E, 0x63,  /* >......c */
                /* 0450 */  0x02, 0xB4, 0x41, 0x92, 0x7B, 0xB8, 0xC7, 0x85,  /* ..A.{... */
                /* 0458 */  0x1B, 0x87, 0x47, 0x75, 0x4C, 0x31, 0x9F, 0xE3,  /* ..GuL1.. */
                /* 0460 */  0x82, 0x3C, 0xC7, 0x79, 0x5E, 0xB8, 0xF3, 0x03,  /* .<.y^... */
                /* 0468 */  0x70, 0xFB, 0xFF, 0x0F, 0x0C, 0xD6, 0x85, 0x0B,  /* p....... */
                /* 0470 */  0x88, 0x0B, 0x35, 0x29, 0xF1, 0xFC, 0x00, 0xAE,  /* ..5).... */
                /* 0478 */  0x5B, 0xB7, 0xEF, 0x85, 0x38, 0x29, 0x77, 0x57,  /* [...8)wW */
                /* 0480 */  0x14, 0xC6, 0x2B, 0x49, 0x0C, 0xDF, 0x53, 0x8D,  /* ..+I..S. */
                /* 0488 */  0x6D, 0x98, 0x03, 0x38, 0x15, 0xE3, 0x24, 0x18,  /* m..8..$. */
                /* 0490 */  0xFC, 0xEC, 0x40, 0xC7, 0xE5, 0xC8, 0x24, 0xBA,  /* ..@...$. */
                /* 0498 */  0xED, 0xFB, 0x08, 0xC1, 0x63, 0x8E, 0x9E, 0x82,  /* ....c... */
                /* 04A0 */  0x18, 0xD0, 0x19, 0x4E, 0x2A, 0x68, 0x15, 0x20,  /* ...N*h.  */
                /* 04A8 */  0x9A, 0x02, 0xE6, 0xE6, 0x0A, 0xF8, 0xFB, 0xFF,  /* ........ */
                /* 04B0 */  0xDF, 0x5C, 0x01, 0x56, 0xB8, 0x54, 0xA8, 0x51,  /* .\.V.T.Q */
                /* 04B8 */  0xEA, 0x91, 0x02, 0x5C, 0x77, 0x40, 0xDF, 0xC2,  /* ...\w@.. */
                /* 04C0 */  0x70, 0x92, 0x80, 0x74, 0x65, 0x3D, 0x8D, 0x07,  /* p..te=.. */
                /* 04C8 */  0x00, 0x5F, 0x29, 0x60, 0x5C, 0x3C, 0xD9, 0x11,  /* ._)`\<.. */
                /* 04D0 */  0x87, 0xDF, 0xAE, 0x7D, 0x2C, 0x00, 0xE6, 0xFF,  /* ...},... */
                /* 04D8 */  0xFF, 0x2B, 0x21, 0x58, 0x8F, 0x05, 0xC0, 0x5B,  /* .+!X...[ */
                /* 04E0 */  0xA4, 0x4B, 0x8B, 0x66, 0x8F, 0x05, 0xE0, 0x12,  /* .K.f.... */
                /* 04E8 */  0xBF, 0x0A, 0x7A, 0x50, 0xB1, 0x5C, 0x18, 0x94,  /* ..zP.\.. */
                /* 04F0 */  0x84, 0xB1, 0x43, 0x19, 0xCD, 0xC1, 0x1C, 0x43,  /* ..C....C */
                /* 04F8 */  0x70, 0x76, 0x86, 0x31, 0x1C, 0x1F, 0xA8, 0xA7,  /* pv.1.... */
                /* 0500 */  0xFE, 0x58, 0x7B, 0x1A, 0xAF, 0x68, 0xBE, 0xE2,  /* .X{..h.. */
                /* 0508 */  0xF9, 0x3E, 0x4A, 0x87, 0x88, 0xBA, 0xEA, 0x79,  /* .>J....y */
                /* 0510 */  0xAC, 0x6F, 0x05, 0xA7, 0xF6, 0xAC, 0xE7, 0x6B,  /* .o.....k */
                /* 0518 */  0x8B, 0x61, 0x12, 0x78, 0x88, 0x0C, 0x8D, 0x13,  /* .a.x.... */
                /* 0520 */  0xBC, 0x23, 0x19, 0x9A, 0xCB, 0x80, 0xD0, 0x5D,  /* .#.....] */
                /* 0528 */  0xE9, 0x35, 0xC0, 0x73, 0x33, 0x41, 0xF7, 0x43,  /* .5.s3A.C */
                /* 0530 */  0x97, 0x42, 0x04, 0x9D, 0x00, 0xDE, 0x09, 0x6A,  /* .B.....j */
                /* 0538 */  0x14, 0xE0, 0xED, 0x2A, 0x20, 0x5B, 0x02, 0xC4,  /* ...* [.. */
                /* 0540 */  0x8D, 0x5E, 0x58, 0x6F, 0x45, 0x51, 0x42, 0x44,  /* .^XoEQBD */
                /* 0548 */  0x08, 0x1A, 0xC5, 0x78, 0x11, 0x42, 0x85, 0x88,  /* ...x.B.. */
                /* 0550 */  0x12, 0xB5, 0x39, 0x10, 0x5D, 0x8E, 0xA2, 0x06,  /* ..9.]... */
                /* 0558 */  0x89, 0x16, 0xCC, 0x08, 0xCC, 0xFE, 0x20, 0x88,  /* ...... . */
                /* 0560 */  0xF4, 0x67, 0x80, 0x2E, 0x33, 0xBE, 0x0C, 0x7B,  /* .g..3..{ */
                /* 0568 */  0x34, 0xFC, 0x2C, 0xC5, 0x87, 0x7A, 0x8E, 0x8F,  /* 4.,..z.. */
                /* 0570 */  0x8A, 0xEC, 0xFF, 0x0F, 0xF2, 0x5A, 0x68, 0x9D,  /* .....Zh. */
                /* 0578 */  0xE3, 0x24, 0x87, 0x1C, 0x83, 0xEB, 0x0C, 0x01,  /* .$...... */
                /* 0580 */  0xCD, 0x35, 0xA0, 0x8E, 0xFD, 0x1E, 0xAF, 0xBF,  /* .5...... */
                /* 0588 */  0x1A, 0x86, 0xE3, 0x43, 0xF4, 0xA1, 0xC2, 0x13,  /* ...C.... */
                /* 0590 */  0x38, 0x44, 0x06, 0xE8, 0x43, 0x04, 0xFC, 0xF1,  /* 8D..C... */
                /* 0598 */  0x18, 0xFA, 0x29, 0xC2, 0x13, 0x7E, 0xA1, 0x25,  /* ..)..~.% */
                /* 05A0 */  0x83, 0x40, 0x9D, 0x34, 0xF8, 0x48, 0x5F, 0xB8,  /* .@.4.H_. */
                /* 05A8 */  0xD9, 0xED, 0xC3, 0x04, 0x16, 0x7B, 0x76, 0xA0,  /* .....{v. */
                /* 05B0 */  0xE3, 0x01, 0xBF, 0xE2, 0x33, 0x81, 0xAE, 0x71,  /* ....3..q */
                /* 05B8 */  0xC6, 0xF6, 0xC9, 0xC8, 0x11, 0x0E, 0x22, 0x50,  /* ......"P */
                /* 05C0 */  0x40, 0x9F, 0x4D, 0xF8, 0xCD, 0x83, 0x1D, 0x2D,  /* @.M....- */
                /* 05C8 */  0xB8, 0xA8, 0xA3, 0x05, 0xEA, 0xB4, 0xE0, 0x83,  /* ........ */
                /* 05D0 */  0x02, 0x43, 0x7C, 0xF8, 0x34, 0xC4, 0x93, 0x05,  /* .C|.4... */
                /* 05D8 */  0x3B, 0xEA, 0x80, 0x53, 0xDE, 0x21, 0x04, 0x14,  /* ;..S.!.. */
                /* 05E0 */  0x20, 0x3E, 0x59, 0xB0, 0x79, 0x61, 0x08, 0x2C,  /*  >Y.ya., */
                /* 05E8 */  0x12, 0x1E, 0x75, 0xE8, 0x30, 0x3C, 0x3F, 0x25,  /* ..u.0<?% */
                /* 05F0 */  0x3C, 0x8E, 0x30, 0xEC, 0x37, 0x12, 0x4F, 0xE1,  /* <.0.7.O. */
                /* 05F8 */  0x70, 0x7C, 0xA4, 0x30, 0x42, 0xF0, 0x72, 0x4F,  /* p|.0B.rO */
                /* 0600 */  0x16, 0xE4, 0x62, 0x73, 0x74, 0xFF, 0xFF, 0x27,  /* ..bst..' */
                /* 0608 */  0x18, 0xCC, 0x50, 0x3D, 0x04, 0x7E, 0x5E, 0xF0,  /* ..P=.~^. */
                /* 0610 */  0x10, 0xF8, 0x00, 0x5A, 0x9D, 0x1D, 0x39, 0x9F,  /* ...Z..9. */
                /* 0618 */  0x9C, 0x13, 0x6E, 0xBC, 0x7C, 0x4C, 0xD8, 0x01,  /* ..n.|L.. */
                /* 0620 */  0xF0, 0xE0, 0x4B, 0xF2, 0x59, 0x84, 0xC6, 0x58,  /* ..K.Y..X */
                /* 0628 */  0xBE, 0x8F, 0x23, 0x80, 0x9C, 0x49, 0x3C, 0x81,  /* ..#..I<. */
                /* 0630 */  0x44, 0x78, 0x19, 0x09, 0x12, 0xE2, 0x58, 0x5E,  /* Dx....X^ */
                /* 0638 */  0x43, 0x0C, 0x12, 0xE3, 0xED, 0xC8, 0xC7, 0x11,  /* C....... */
                /* 0640 */  0x0E, 0xF3, 0x4C, 0x62, 0xB8, 0x87, 0x83, 0x57,  /* ..Lb...W */
                /* 0648 */  0x91, 0x17, 0x12, 0xC3, 0x3C, 0x8A, 0xF8, 0x7C,  /* ....<..| */
                /* 0650 */  0x10, 0xC3, 0x98, 0xA1, 0xA2, 0x9D, 0x80, 0x8F,  /* ........ */
                /* 0658 */  0x23, 0xEC, 0x58, 0xE9, 0xA1, 0xFA, 0x38, 0x02,  /* #.X...8. */
                /* 0660 */  0x58, 0xFA, 0xFF, 0x1F, 0x47, 0x80, 0xF9, 0x11,  /* X...G... */
                /* 0668 */  0x01, 0x77, 0xDA, 0x80, 0x7B, 0x9F, 0x08, 0xF1,  /* .w..{... */
                /* 0670 */  0xA4, 0xF1, 0x92, 0xF0, 0xAC, 0x01, 0x5C, 0x84,  /* ......\. */
                /* 0678 */  0x6A, 0x39, 0xF7, 0xB0, 0x34, 0x8F, 0x01, 0x1D,  /* j9..4... */
                /* 0680 */  0xCF, 0x38, 0x87, 0x35, 0x01, 0x69, 0x98, 0xFC,  /* .8.5.i.. */
                /* 0688 */  0xCA, 0xED, 0x73, 0xC1, 0xD9, 0x3D, 0x72, 0x1B,  /* ..s..=r. */
                /* 0690 */  0x26, 0xC8, 0x13, 0xC1, 0x6B, 0x94, 0xC1, 0x05,  /* &...k... */
                /* 0698 */  0xA9, 0xF3, 0x23, 0x4F, 0x4F, 0x21, 0xDD, 0x27,  /* ..#OO!.' */
                /* 06A0 */  0x5A, 0x94, 0xD2, 0x63, 0x1A, 0x05, 0xF1, 0x19,  /* Z..c.... */
                /* 06A8 */  0xC1, 0x21, 0xCE, 0x31, 0xE8, 0xE1, 0x7B, 0x0E,  /* .!.1..{. */
                /* 06B0 */  0x67, 0x74, 0x20, 0xEF, 0x01, 0xEC, 0xFE, 0x08,  /* gt ..... */
                /* 06B8 */  0x3C, 0x4F, 0x3A, 0x78, 0x74, 0xDF, 0x14, 0xCE,  /* <O:xt... */
                /* 06C0 */  0xF3, 0x4C, 0xFF, 0xFF, 0x47, 0x04, 0xDE, 0x99,  /* .L..G... */
                /* 06C8 */  0xFA, 0x82, 0x09, 0x9C, 0x43, 0xDC, 0x05, 0x50,  /* ....C..P */
                /* 06D0 */  0xB2, 0xEF, 0x02, 0x14, 0xC4, 0x13, 0xF3, 0xD5,  /* ........ */
                /* 06D8 */  0x0F, 0x0E, 0xFE, 0xAB, 0x1F, 0x30, 0xB9, 0x2C,  /* .....0., */
                /* 06E0 */  0xF8, 0x9A, 0x04, 0xBE, 0x53, 0x3F, 0xFE, 0xC2,  /* ....S?.. */
                /* 06E8 */  0xE0, 0xDB, 0xC0, 0xC3, 0x13, 0x1B, 0x14, 0xF8,  /* ........ */
                /* 06F0 */  0xA1, 0x7C, 0x3D, 0x04, 0xFF, 0xFF, 0xFF, 0x7A,  /* .|=....z */
                /* 06F8 */  0x08, 0x3C, 0x95, 0x3A, 0xB5, 0xA9, 0xF0, 0x7A,  /* .<.:...z */
                /* 0700 */  0x08, 0xAE, 0x28, 0xD7, 0x12, 0xD4, 0xAD, 0xC9,  /* ..(..... */
                /* 0708 */  0x82, 0x80, 0x74, 0x3F, 0x7F, 0xBE, 0x31, 0xA6,  /* ..t?..1. */
                /* 0710 */  0xCF, 0x25, 0xF0, 0xEE, 0xA0, 0x5A, 0x95, 0xEE,  /* .%...Z.. */
                /* 0718 */  0x25, 0x3C, 0x38, 0x85, 0xA2, 0x1F, 0x1E, 0x50,  /* %<8....P */
                /* 0720 */  0x61, 0x0F, 0x0F, 0x14, 0xC4, 0x17, 0x23, 0xDF,  /* a.....#. */
                /* 0728 */  0x4B, 0x00, 0x0E, 0xFC, 0xFF, 0x47, 0xC4, 0x6F,  /* K....G.o */
                /* 0730 */  0xDA, 0x70, 0x8E, 0x16, 0x98, 0x19, 0x81, 0xF5,  /* .p...... */
                /* 0738 */  0x44, 0xE0, 0x9B, 0x36, 0xE0, 0xE8, 0xE4, 0x02,  /* D..6.... */
                /* 0740 */  0x5C, 0x4E, 0x25, 0x80, 0x2B, 0xAF, 0xA7, 0x12,  /* \N%.+... */
                /* 0748 */  0xFD, 0xFF, 0x4F, 0x25, 0xE0, 0xBA, 0x7B, 0x81,  /* ..O%..{. */
                /* 0750 */  0xE9, 0x6A, 0x72, 0x26, 0xD1, 0x82, 0xFB, 0xEE,  /* .jr&.... */
                /* 0758 */  0x05, 0xF0, 0xF3, 0xFF, 0x7F, 0xF7, 0x02, 0x88,  /* ........ */
                /* 0760 */  0xE9, 0xF5, 0xEE, 0x05, 0xBC, 0xCE, 0x25, 0x98,  /* ......%. */
                /* 0768 */  0xBB, 0x97, 0xFF, 0xFF, 0x77, 0x2F, 0x80, 0xFF,  /* ....w/.. */
                /* 0770 */  0xFF, 0xFF, 0xBB, 0x17, 0x40, 0x96, 0x53, 0x09,  /* ....@.S. */
                /* 0778 */  0xC8, 0xB2, 0x9D, 0x4A, 0xD0, 0x0A, 0xCF, 0xD1,  /* ...J.... */
                /* 0780 */  0x50, 0x27, 0x70, 0x28, 0x4F, 0x18, 0xAF, 0xEA,  /* P'p(O... */
                /* 0788 */  0x09, 0xAC, 0xE7, 0xF2, 0x85, 0x52, 0x02, 0xA3,  /* .....R.. */
                /* 0790 */  0xCB, 0x17, 0xB0, 0xFB, 0xFF, 0x5F, 0xBE, 0x00,  /* ....._.. */
                /* 0798 */  0x3E, 0x04, 0xBA, 0x0B, 0xA0, 0x22, 0xDC, 0x05,  /* >....".. */
                /* 07A0 */  0x28, 0x88, 0x2F, 0x5F, 0x80, 0x97, 0x50, 0x10,  /* (./_..P. */
                /* 07A8 */  0x32, 0x72, 0x93, 0xA0, 0x97, 0x2F, 0x38, 0x17,  /* 2r.../8. */
                /* 07B0 */  0x07, 0xDF, 0x8F, 0x3C, 0x28, 0x78, 0xFF, 0xFF,  /* ...<(x.. */
                /* 07B8 */  0x41, 0xC1, 0x19, 0xCC, 0x79, 0x17, 0x7B, 0x52,  /* A...y.{R */
                /* 07C0 */  0xA4, 0xD7, 0x13, 0xB8, 0x77, 0x0E, 0x8F, 0x0D,  /* ....w... */
                /* 07C8 */  0x1C, 0xE2, 0xAE, 0x60, 0xC0, 0xDE, 0xE5, 0xED,  /* ...`.... */
                /* 07D0 */  0x04, 0x5C, 0xDA, 0xD6, 0xAE, 0xDB, 0x09, 0x2E,  /* .\...... */
                /* 07D8 */  0xE1, 0x71, 0x1A, 0xF2, 0xF1, 0x04, 0x93, 0xE7,  /* .q...... */
                /* 07E0 */  0x76, 0x82, 0x4A, 0x02, 0xA3, 0x2C, 0x24, 0x3A,  /* v.J..,$: */
                /* 07E8 */  0x42, 0x70, 0xF5, 0x37, 0x31, 0x0A, 0x62, 0x0B,  /* Bp.71.b. */
                /* 07F0 */  0xB7, 0x13, 0x40, 0xC7, 0xFF, 0xFF, 0x76, 0x02,  /* ..@...v. */
                /* 07F8 */  0xFC, 0xC7, 0x0C, 0x67, 0x44, 0xEF, 0x15, 0x86,  /* ...gD... */
                /* 0800 */  0xF4, 0x19, 0x0C, 0x98, 0x06, 0x3A, 0x82, 0xA0,  /* .....:.. */
                /* 0808 */  0x2F, 0x69, 0xD8, 0x04, 0x37, 0x10, 0x3A, 0x23,  /* /i..7.:# */
                /* 0810 */  0x78, 0x17, 0x10, 0xB8, 0x13, 0x83, 0x75, 0x00,  /* x.....u. */
                /* 0818 */  0x01, 0xDF, 0x59, 0x0D, 0x78, 0xFD, 0xFF, 0xCF,  /* ..Y.x... */
                /* 0820 */  0x6A, 0xC0, 0xF4, 0x00, 0xE0, 0xB3, 0x1A, 0xA0,  /* j....... */
                /* 0828 */  0xEA, 0xF6, 0x02, 0x32, 0x85, 0x36, 0x7D, 0x6A,  /* ...2.6}j */
                /* 0830 */  0x34, 0x6A, 0xD5, 0xA0, 0x4C, 0x8D, 0x32, 0x0D,  /* 4j..L.2. */
                /* 0838 */  0x6A, 0xF5, 0xA9, 0xD4, 0x98, 0x31, 0xBB, 0x60,  /* j....1.` */
                /* 0840 */  0x8A, 0x71, 0x7B, 0xA2, 0x22, 0x96, 0x23, 0x10,  /* .q{.".#. */
                /* 0848 */  0xEB, 0xA6, 0x90, 0x91, 0xCB, 0x86, 0x41, 0x04,  /* ......A. */
                /* 0850 */  0x64, 0xD9, 0x8B, 0x16, 0x10, 0x01, 0x11, 0x90,  /* d....... */
                /* 0858 */  0x85, 0xBC, 0x1B, 0x04, 0x64, 0x55, 0x20, 0x02,  /* ....dU . */
                /* 0860 */  0x72, 0x2A, 0x20, 0x1A, 0x11, 0x88, 0xC6, 0xF1,  /* r* ..... */
                /* 0868 */  0x00, 0xC4, 0xC2, 0x81, 0x08, 0xC8, 0xEA, 0x4C,  /* .......L */
                /* 0870 */  0x00, 0x31, 0xA9, 0x20, 0xBA, 0x43, 0x90, 0xCF,  /* .1. .C.. */
                /* 0878 */  0x85, 0x80, 0x2C, 0x12, 0x44, 0x40, 0xCE, 0xB8,  /* ..,.D@.. */
                /* 0880 */  0x3E, 0x01, 0x39, 0x30, 0x88, 0x80, 0x1C, 0xF2,  /* >.90.... */
                /* 0888 */  0x1B, 0x22, 0x20, 0x47, 0x06, 0x11, 0x90, 0x05,  /* ." G.... */
                /* 0890 */  0xEB, 0x00, 0xF2, 0xFF, 0x9F, 0xA0, 0x7C, 0x10,  /* ......|. */
                /* 0898 */  0x01, 0x39, 0x3E, 0x10, 0x15, 0xE3, 0xE3, 0xAE,  /* .9>..... */
                /* 08A0 */  0x45, 0x1F, 0x03, 0x02, 0x72, 0x2E, 0x10, 0x01,  /* E...r... */
                /* 08A8 */  0x39, 0x07, 0x8D, 0x80, 0x9C, 0x8A, 0x42, 0x40,  /* 9.....B@ */
                /* 08B0 */  0x56, 0xF5, 0x76, 0x10, 0x90, 0x35, 0x82, 0x08,  /* V.v..5.. */
                /* 08B8 */  0xC8, 0x29, 0x81, 0x68, 0x66, 0x20, 0x2A, 0xD8,  /* .).hf *. */
                /* 08C0 */  0x0A, 0x10, 0x53, 0x0F, 0x22, 0x20, 0x2B, 0xD5,  /* ..S." +. */
                /* 08C8 */  0x02, 0xC4, 0x74, 0x83, 0x08, 0xC8, 0xA9, 0xBD,  /* ..t..... */
                /* 08D0 */  0x00, 0x31, 0x0D, 0xEF, 0x00, 0x01, 0x59, 0xEB,  /* .1....Y. */
                /* 08D8 */  0xD3, 0x43, 0x20, 0x4E, 0x0A, 0x42, 0xB5, 0xBA,  /* .C N.B.. */
                /* 08E0 */  0x01, 0x61, 0x39, 0xED, 0x80, 0x30, 0x95, 0x7A,  /* .a9..0.z */
                /* 08E8 */  0x40, 0x58, 0x1E, 0x3F, 0x43, 0xA6, 0x20, 0x02,  /* @X.?C. . */
                /* 08F0 */  0xB2, 0xA2, 0x97, 0x88, 0x80, 0x2C, 0x0F, 0x44,  /* .....,.D */
                /* 08F8 */  0x40, 0x96, 0x62, 0x08, 0x88, 0x09, 0x03, 0x11,  /* @.b..... */
                /* 0900 */  0x90, 0x23, 0x01, 0xD1, 0x80, 0x40, 0x54, 0x9E,  /* .#...@T. */
                /* 0908 */  0x23, 0x20, 0xA6, 0x15, 0x44, 0x40, 0x0E, 0x08,  /* # ..D@.. */
                /* 0910 */  0x44, 0xD3, 0x02, 0x51, 0x8D, 0xBF, 0x25, 0x01,  /* D..Q..%. */
                /* 0918 */  0x59, 0x30, 0x88, 0x80, 0x2C, 0xCE, 0xD2, 0x51,  /* Y0..,..Q */
                /* 0920 */  0x80, 0x82, 0x08, 0xC8, 0x31, 0x35, 0x0D, 0x95,  /* ....15.. */
                /* 0928 */  0x82, 0x08, 0xC8, 0x42, 0x3D, 0x01, 0x31, 0xD5,  /* ...B=.1. */
                /* 0930 */  0x20, 0x02, 0xB2, 0x42, 0x51, 0x40, 0x4C, 0x2F,  /*  ..BQ@L/ */
                /* 0938 */  0x88, 0x06, 0x49, 0x80, 0x68, 0x6E, 0x20, 0xAA,  /* ..I.hn . */
                /* 0940 */  0x5A, 0x15, 0x10, 0x8B, 0x00, 0x22, 0x20, 0xE7,  /* Z...." . */
                /* 0948 */  0x06, 0xA2, 0x22, 0x5C, 0x01, 0x31, 0xE9, 0x20,  /* .."\.1.  */
                /* 0950 */  0x02, 0x72, 0x0E, 0x20, 0xAA, 0xF9, 0x49, 0x21,  /* .r. ..I! */
                /* 0958 */  0x20, 0x27, 0x00, 0x11, 0x90, 0xF3, 0xDB, 0x3A,  /*  '.....: */
                /* 0960 */  0x1A, 0xD0, 0x87, 0x8E, 0x80, 0x9C, 0x00, 0x44,  /* .......D */
                /* 0968 */  0x40, 0x8E, 0x03, 0x44, 0xA5, 0xFB, 0x02, 0x62,  /* @..D...b */
                /* 0970 */  0x41, 0x40, 0x04, 0x64, 0x41, 0xAF, 0x11, 0x0D,  /* A@.dA... */
                /* 0978 */  0x9C, 0x80, 0x08, 0xC8, 0xD1, 0x8C, 0x01, 0xB1,  /* ........ */
                /* 0980 */  0x9C, 0x20, 0x02, 0xFA, 0xFF, 0x1F, 0xA8, 0xBE,  /* . ...... */
                /* 0988 */  0x22, 0x02, 0xB2, 0x52, 0x10, 0x0D, 0x9A, 0x00,  /* "..R.... */
                /* 0990 */  0xD1, 0xB4, 0x40, 0x54, 0xF1, 0x9B, 0xE4, 0xD1,  /* ..@T.... */
                /* 0998 */  0x81, 0x81, 0xE8, 0x88, 0x40, 0xA4, 0x1D, 0x11,  /* ....@... */
                /* 09A0 */  0x28, 0x88, 0x80, 0xFC, 0xFF, 0x07               /* (..... */
            })
            Method (SPEC, 1, Serialized)
            {
                Return (AMWV) /* \AMWV */
            }
            Method (DEVP, 1, Serialized)
            {
                CreateDWordField (Arg0, Zero, DVID)
                CreateDWordField (Arg0, 0x04, PARA)
                If ((PARA == One))
                {
                    Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
                    _T_0 = DVID /* \AMW0.DEVP.DVID */
                    If ((_T_0 == 0x00010011))
                    {
                        \_SB.DSAF |= One
                    }
                    Else
                    {
                        If ((_T_0 == 0x00010013))
                        {
                            \_SB.DSAF |= 0x02
                        }
                        Else
                        {
                            If ((_T_0 == 0x00010023))
                            {
                                \_SB.DSAF |= 0x04
                            }
                            Else
                            {
                                If ((_T_0 == 0x00060013))
                                {
                                    \_SB.DSAF |= 0x08
                                }
                                Else
                                {
                                    If ((_T_0 == 0x00060015))
                                    {
                                        \_SB.DSAF |= 0x10
                                    }
                                    Else
                                    {
                                        If ((_T_0 == 0x00010015))
                                        {
                                            \_SB.DSAF |= 0x20
                                        }
                                        Else
                                        {
                                            If ((_T_0 == 0x00090011))
                                            {
                                                \_SB.DSAF |= 0x40
                                            }
                                            Else
                                            {
                                                If ((_T_0 == 0x00070011))
                                                {
                                                    \_SB.DSAF |= 0x80
                                                }
                                                Else
                                                {
                                                    If ((_T_0 == 0x00080013))
                                                    {
                                                        \_SB.DSAF |= 0x0100
                                                    }
                                                    Else
                                                    {
                                                        If ((_T_0 == 0x00010019))
                                                        {
                                                            \_SB.DSAF |= 0x0200
                                                        }
                                                        Else
                                                        {
                                                            If ((_T_0 == 0x00010017))
                                                            {
                                                                \_SB.DSAF |= 0x0400
                                                            }
                                                            Else
                                                            {
                                                                If ((_T_0 == 0x00050011))
                                                                {
                                                                    \_SB.DSAF |= 0x0800
                                                                }
                                                                Else
                                                                {
                                                                    If ((_T_0 == 0x00050012))
                                                                    {
                                                                        \_SB.DSAF |= 0x1000
                                                                    }
                                                                    Else
                                                                    {
                                                                        If ((_T_0 == 0x00060017))
                                                                        {
                                                                            \_SB.DSAF |= 0x2000
                                                                        }
                                                                        Else
                                                                        {
                                                                            If ((_T_0 == 0x00080021))
                                                                            {
                                                                                \_SB.DSAF |= 0x4000
                                                                            }
                                                                            Else
                                                                            {
                                                                                If ((_T_0 == 0x00100011))
                                                                                {
                                                                                    \_SB.DSAF |= 0x8000
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If ((_T_0 == 0x00050001))
                                                                                    {
                                                                                        \_SB.DSAF |= 0x00010000
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If ((_T_0 == 0x00120000))
                                                                                        {
                                                                                            \_SB.DSAF |= 0x00020000
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If ((_T_0 == 0x00120021))
                                                                                            {
                                                                                                \_SB.DSAF |= 0x00040000
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If ((_T_0 == 0x00120011))
                                                                                                {
                                                                                                    \_SB.DSAF |= 0x00080000
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    Return (Zero)
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Else
                {
                    If ((PARA == Zero))
                    {
                        Name (_T_1, Zero)  // _T_x: Emitted by ASL Compiler
                        _T_1 = DVID /* \AMW0.DEVP.DVID */
                        If ((_T_1 == 0x00010011))
                        {
                            \_SB.DSAF &= 0xFFFFFFFFFFFFFFFE
                        }
                        Else
                        {
                            If ((_T_1 == 0x00010013))
                            {
                                \_SB.DSAF &= 0xFFFFFFFFFFFFFFFD
                            }
                            Else
                            {
                                If ((_T_1 == 0x00010023))
                                {
                                    \_SB.DSAF &= 0xFFFFFFFFFFFFFFFB
                                }
                                Else
                                {
                                    If ((_T_1 == 0x00060013))
                                    {
                                        \_SB.DSAF &= 0xFFFFFFFFFFFFFFF7
                                    }
                                    Else
                                    {
                                        If ((_T_1 == 0x00060015))
                                        {
                                            \_SB.DSAF &= 0xFFFFFFFFFFFFFFEF
                                        }
                                        Else
                                        {
                                            If ((_T_1 == 0x00010015))
                                            {
                                                \_SB.DSAF &= 0xFFFFFFFFFFFFFFDF
                                            }
                                            Else
                                            {
                                                If ((_T_1 == 0x00090011))
                                                {
                                                    \_SB.DSAF &= 0xFFFFFFFFFFFFFFBF
                                                }
                                                Else
                                                {
                                                    If ((_T_1 == 0x00070011))
                                                    {
                                                        \_SB.DSAF &= 0xFFFFFFFFFFFFFF7F
                                                    }
                                                    Else
                                                    {
                                                        If ((_T_1 == 0x00080013))
                                                        {
                                                            \_SB.DSAF &= 0xFFFFFFFFFFFFFEFF
                                                        }
                                                        Else
                                                        {
                                                            If ((_T_1 == 0x00010019))
                                                            {
                                                                \_SB.DSAF &= 0xFFFFFFFFFFFFFDFF
                                                            }
                                                            Else
                                                            {
                                                                If ((_T_1 == 0x00010017))
                                                                {
                                                                    \_SB.DSAF &= 0xFFFFFFFFFFFFFBFF
                                                                }
                                                                Else
                                                                {
                                                                    If ((_T_1 == 0x00050011))
                                                                    {
                                                                        \_SB.DSAF &= 0xFFFFFFFFFFFFF7FF
                                                                    }
                                                                    Else
                                                                    {
                                                                        If ((_T_1 == 0x00050012))
                                                                        {
                                                                            \_SB.DSAF &= 0xFFFFFFFFFFFFEFFF
                                                                        }
                                                                        Else
                                                                        {
                                                                            If ((_T_1 == 0x00060017))
                                                                            {
                                                                                \_SB.DSAF &= 0xFFFFFFFFFFFFDFFF
                                                                            }
                                                                            Else
                                                                            {
                                                                                If ((_T_1 == 0x00080021))
                                                                                {
                                                                                    \_SB.DSAF &= 0xFFFFFFFFFFFFBFFF
                                                                                }
                                                                                Else
                                                                                {
                                                                                    If ((_T_1 == 0x00100011))
                                                                                    {
                                                                                        \_SB.DSAF &= 0xFFFFFFFFFFFF7FFF
                                                                                    }
                                                                                    Else
                                                                                    {
                                                                                        If ((_T_1 == 0x00050001))
                                                                                        {
                                                                                            \_SB.DSAF &= 0xFFFFFFFFFFFEFFFF
                                                                                        }
                                                                                        Else
                                                                                        {
                                                                                            If ((_T_1 == 0x00120000))
                                                                                            {
                                                                                                \_SB.DSAF &= 0xFFFFFFFFFFFDFFFF
                                                                                            }
                                                                                            Else
                                                                                            {
                                                                                                If ((_T_1 == 0x00120021))
                                                                                                {
                                                                                                    \_SB.DSAF &= 0xFFFFFFFFFFFBFFFF
                                                                                                }
                                                                                                Else
                                                                                                {
                                                                                                    If ((_T_1 == 0x00120011))
                                                                                                    {
                                                                                                        \_SB.DSAF &= 0xFFFFFFFFFFF7FFFF
                                                                                                    }
                                                                                                    Else
                                                                                                    {
                                                                                                        Return (Zero)
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Return (One)
            }
            Method (SDSP, 1, Serialized)
            {
                CreateDWordField (Arg0, Zero, ACTN)
                Return (Zero)
            }
            Method (GDSP, 1, Serialized)
            {
                CreateDWordField (Arg0, Zero, ACTN)
                Return (Zero)
            }
            Method (DEVS, 1, Serialized)
            {
                CreateDWordField (Arg0, Zero, DVID)
                CreateDWordField (Arg0, 0x04, CPAR)
                Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
                _T_0 = DVID /* \AMW0.DEVS.DVID */
                If ((_T_0 == Zero))
                {
                    Return (Zero)
                }
                Else
                {
                    Return (Zero)
                }
            }
            Method (DSTS, 1, Serialized)
            {
                CreateDWordField (Arg0, Zero, DVID)
                Name (_T_0, Zero)  // _T_x: Emitted by ASL Compiler
                _T_0 = DVID /* \AMW0.DSTS.DVID */
                If ((_T_0 == 0xA0000000))
                {
                    Local0 = One
                }
                Else
                {
                    If ((_T_0 == 0x00120030))
                    {
                        Local0 = OVG1 ()
                    }
                    Else
                    {
                        If ((_T_0 == 0x00120031))
                        {
                            Local0 = OVG2 ()
                        }
                        Else
                        {
                            If ((_T_0 == Zero))
                            {
                                Return (Zero)
                            }
                            Else
                            {
                                Local0 = Zero
                            }
                        }
                    }
                }
                Local0 &= 0x0007FFFF
                Return (Local0)
            }
            Method (GPID, 0, Serialized)
            {
                Return (Zero)
            }
            Method (KBFT, 1, Serialized)
            {
                Return (Zero)
            }
            Method (HKEY, 0, Serialized)
            {
                Return (Zero)
            }
            Method (CFVS, 1, Serialized)
            {
            }
            Method (CFVG, 0, Serialized)
            {
            }
        }
    }
    Scope (_SB)
    {
        Name (RAMB, 0xCEF50018)
        OperationRegion (\RAMW, SystemMemory, RAMB, 0x00010000)
        Field (RAMW, ByteAcc, NoLock, Preserve)
        {
            DSAF,   256, 
            PAR0,   32, 
            PAR1,   32, 
            PAR2,   32, 
            PINX,   32, 
            PADD,   2048, 
            VGA1,   32, 
            VGA2,   32
        }
        Mutex (MPAR, 0x00)
        Name (ARBF, Buffer (0x10) {})
        CreateDWordField (ARBF, Zero, REAX)
        CreateDWordField (ARBF, 0x04, REBX)
        CreateDWordField (ARBF, 0x08, RECX)
        CreateDWordField (ARBF, 0x0C, REDX)
        OperationRegion (IOB2, SystemIO, SMIP, 0x02)
        Field (IOB2, ByteAcc, NoLock, Preserve)
        {
            SMIC,   8, 
            SMIS,   8
        }
        Method (ISMI, 1, Serialized)
        {
            SMIC = Arg0
        }
        Method (GMSR, 1, Serialized)
        {
            If ((Acquire (MPAR, 0xFFFF) == Zero))
            {
                PINX = 0x80000000
                PAR0 = Arg0
                ISMI (0x90)
                RECX = Arg0
                REAX = PAR1 /* \_SB_.PAR1 */
                REDX = PAR2 /* \_SB_.PAR2 */
                Release (MPAR)
                Return (ARBF) /* \_SB_.ARBF */
            }
            Return (Ones)
        }
        Method (SMSR, 1, Serialized)
        {
            If ((Acquire (MPAR, 0xFFFF) == Zero))
            {
                CreateDWordField (Arg0, Zero, AEAX)
                CreateDWordField (Arg0, 0x04, AEBX)
                CreateDWordField (Arg0, 0x08, AECX)
                CreateDWordField (Arg0, 0x0C, AEDX)
                PINX = 0x80000001
                PAR0 = AECX /* \_SB_.SMSR.AECX */
                PAR1 = AEAX /* \_SB_.SMSR.AEAX */
                PAR2 = AEDX /* \_SB_.SMSR.AEDX */
                ISMI (0x90)
                Release (MPAR)
            }
            Return (Ones)
        }
        Method (PRID, 1, Serialized)
        {
            If ((Acquire (MPAR, 0xFFFF) == Zero))
            {
                PINX = 0x80000002
                PAR0 = Arg0
                ISMI (0x90)
                REAX = PAR1 /* \_SB_.PAR1 */
                REDX = PAR2 /* \_SB_.PAR2 */
                Release (MPAR)
                Return (ARBF) /* \_SB_.ARBF */
            }
            Return (Ones)
        }
        Method (GPRE, 1, Serialized)
        {
            PAR0 = Arg0
            PINX = 0x80000005
            ISMI (0x90)
            Return (PAR0) /* \_SB_.PAR0 */
        }
        Method (GNVS, 1, Serialized)
        {
            PAR0 = Arg0
            PINX = 0x80000003
            ISMI (0x90)
            Return (PAR1) /* \_SB_.PAR1 */
        }
        Method (SNVS, 2, Serialized)
        {
            PAR0 = Arg0
            PAR1 = Arg1
            PINX = 0x80000004
            ISMI (0x90)
        }
        Method (SARM, 1, Serialized)
        {
            If (((Arg0 > 0x03) && (Arg0 < 0x06)))
            {
                ISMI (0x92)
            }
        }
        Method (GAMM, 0, Serialized)
        {
            ISMI (0x91)
        }
        Method (SAMM, 0, Serialized)
        {
            ISMI (0x92)
        }
    }
    Scope (\)
    {
        Method (OVG1, 0, NotSerialized)
        {
            Return (\_SB.VGA1)
        }
        Method (OVG2, 0, NotSerialized)
        {
            Return (\_SB.VGA2)
        }
    }
    Scope (_SB.PCI0.SBRG)
    {
        Method (S1RS, 1, NotSerialized)
        {
            PLED = Zero
        }
        OperationRegion (GPBX, SystemIO, GPBS, GPLN)
        Field (GPBX, ByteAcc, NoLock, Preserve)
        {
            Offset (0x18), 
                ,   27, 
            PLED,   1
        }
    }
    Name (_S0, Package (0x04)  // _S0_: S0 System State
    {
        Zero, 
        Zero, 
        Zero, 
        Zero
    })
    If (SS1)
    {
        Name (_S1, Package (0x04)  // _S1_: S1 System State
        {
            One, 
            Zero, 
            Zero, 
            Zero
        })
    }
    If (SS3)
    {
        Name (_S3, Package (0x04)  // _S3_: S3 System State
        {
            0x05, 
            Zero, 
            Zero, 
            Zero
        })
    }
    If (SS4)
    {
        Name (_S4, Package (0x04)  // _S4_: S4 System State
        {
            0x06, 
            Zero, 
            Zero, 
            Zero
        })
    }
    Name (_S5, Package (0x04)  // _S5_: S5 System State
    {
        0x07, 
        Zero, 
        Zero, 
        Zero
    })
    Method (PTS, 1, NotSerialized)
    {
        If (Arg0)
        {
            \_SB.PCI0.SBRG.SPTS (Arg0)
            \_SB.PCI0.PEX0.SPRT (Arg0)
            \_SB.PCI0.PEX1.SPRT (Arg0)
            \_SB.PCI0.PEX2.SPRT (Arg0)
            \_SB.PCI0.PEX3.SPRT (Arg0)
            \_SB.PCI0.PEX4.SPRT (Arg0)
            \_SB.PCI0.PEX5.SPRT (Arg0)
            \_SB.PCI0.PEX6.SPRT (Arg0)
            \_SB.PCI0.PEX7.SPRT (Arg0)
            \_SB.SARM (Arg0)
            \_SB.PCI0.SBRG.SIOS (Arg0)
        }
    }
    Method (WAK, 1, NotSerialized)
    {
        \_SB.PCI0.SBRG.SWAK (Arg0)
        If (\_SB.PCI0.PEX0.PMS)
        {
            \_SB.PCI0.PEX0.WPRT (Arg0)
            Notify (\_SB.PCI0.PEX0, 0x02) // Device Wake
        }
        Else
        {
            \_SB.PCI0.PEX0.WPRT (Arg0)
        }
        If (\_SB.PCI0.PEX1.PMS)
        {
            \_SB.PCI0.PEX1.WPRT (Arg0)
            Notify (\_SB.PCI0.PEX1, 0x02) // Device Wake
        }
        Else
        {
            \_SB.PCI0.PEX1.WPRT (Arg0)
        }
        If (\_SB.PCI0.PEX2.PMS)
        {
            \_SB.PCI0.PEX2.WPRT (Arg0)
            Notify (\_SB.PCI0.PEX2, 0x02) // Device Wake
        }
        Else
        {
            \_SB.PCI0.PEX2.WPRT (Arg0)
        }
        If (\_SB.PCI0.PEX3.PMS)
        {
            \_SB.PCI0.PEX3.WPRT (Arg0)
            Notify (\_SB.PCI0.PEX3, 0x02) // Device Wake
        }
        Else
        {
            \_SB.PCI0.PEX3.WPRT (Arg0)
        }
        If (\_SB.PCI0.PEX4.PMS)
        {
            \_SB.PCI0.PEX4.WPRT (Arg0)
            Notify (\_SB.PCI0.PEX4, 0x02) // Device Wake
        }
        Else
        {
            \_SB.PCI0.PEX4.WPRT (Arg0)
        }
        If (\_SB.PCI0.PEX5.PMS)
        {
            \_SB.PCI0.PEX5.WPRT (Arg0)
            Notify (\_SB.PCI0.PEX5, 0x02) // Device Wake
        }
        Else
        {
            \_SB.PCI0.PEX5.WPRT (Arg0)
        }
        If (\_SB.PCI0.PEX6.PMS)
        {
            \_SB.PCI0.PEX6.WPRT (Arg0)
            Notify (\_SB.PCI0.PEX6, 0x02) // Device Wake
        }
        Else
        {
            \_SB.PCI0.PEX6.WPRT (Arg0)
        }
        If (\_SB.PCI0.PEX7.PMS)
        {
            \_SB.PCI0.PEX7.WPRT (Arg0)
            Notify (\_SB.PCI0.PEX7, 0x02) // Device Wake
        }
        Else
        {
            \_SB.PCI0.PEX7.WPRT (Arg0)
        }
        \_SB.PCI0.SBRG.S1RS (Arg0)
        \_SB.PCI0.SBRG.SIOW (Arg0)
    }
}
