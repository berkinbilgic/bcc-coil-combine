# Block Coil Compression (BCC) for Reference-Free Coil Combination

MATLAB code and example 7T in vivo data for reference-free coil combination at ultra high field, using a Block Coil Compression (BCC) virtual body coil and ESPIRiT.

At ultra high field, the simpler SVD virtual body coil may still contain phase singularities. BCC mitigates this with more local coil compression.

## Usage

Run `script_bcc.m` from the repository folder in MATLAB.

ESPIRiT is part of [BART](http://mrirecon.github.io/bart/) (Berkeley Advanced Reconstruction Toolbox). The script was tested with BART version 0.2.06, which is included in `bart-0.2.06/` for consistency (BSD license, see `bart-0.2.06/LICENSE`). The script builds it with `make` and calls its command-line tools.

## Reference

B Bilgic, JP Marques, LL Wald, K Setsompop. Block Coil Compression for Virtual Body Coil without Phase Singularities. [[PDF]](https://www.martinos.org/~berkin/2016_07_30_BCC_abstract.pdf)

Contact: berkin AT nmr.mgh.harvard.edu
