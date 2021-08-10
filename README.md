# PenPlot Processing
An HPGL and Processing mash-up. Allows for a direct connection between Processing and HP compatible Pen Plotters. The goal of this project is to match processing drawing commands to HPGL commands, giving you direct control of the printer from Processing.

## Resources 
- Hewlett Packard Graphics Language [https://www.isoplotec.co.jp/HPGL/eHPGL.htm#Table%20of%20contents](HPGL Reference)

## Tested Printers
HP7475A
[https://pearl-hifi.com/06_Lit_Archive/15_Mfrs_Publications/20_HP_Agilent/HP_7475A_Plotter/HP_7475A_Op_Interconnect.pdf](Manual)
* Doesn't support polygon fills

## Notes
- The Processing coordinate system and the HPGL coordinates don't match. In processing, (0,0) is the upper left corner while in HPGL it is the lower left corner.  
- Library makes the assumption that all angles are expressed in radians

## Coming Soon 
- create a demonstration program that tests out all functions
- full documentation 
- labels 
 
  
