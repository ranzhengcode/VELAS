
<div align=center><img src="https://github.com/ranzhengcode/VELAS/blob/main/doc/VELAS_Logo.png" width="561" height="191"></img></div>

![GitHub issues](https://img.shields.io/github/issues/ranzhengcode/VELAS?logo=github)
![GitHub repo size](https://img.shields.io/github/repo-size/ranzhengcode/VELAS?logo=github)
![GitHub all releases](https://img.shields.io/github/downloads/ranzhengcode/VELAS/total?logo=github)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/ranzhengcode/VELAS?logo=Github)](https://github.com/ranzhengcode/VELAS/releases/tag/velas-1.0.0)
[![GitHub](https://img.shields.io/github/license/ranzhengcode/VELAS?logo=GitHub)](https://github.com/ranzhengcode/VELAS/blob/main/LICENSE.md)  

**VELAS** is a user-friendly open-source toolbox for **the visualization and analysis of elastic anisotropy** written in **GNU Octave** that can be used for **any crystal symmetry**. 

### Meaning of VELAS
**VELAS** is derived from the combination of the letters **V**, **ELA** and **S** in "**V**isualization and analysis of **ELA**stic ani**S**otropy" and has no connection or relationship to any known trademarks, places or people that might be called "**VELAS**". 

[VELAS Manual, PDF](https://github.com/ranzhengcode/VELAS/blob/main/doc/VELAS%20Manual.pdf)

## Highlights
- **Easy** to install and use, **no** compilation required and **no** dependence on any third-party libraries.
- A fully interactive graphical interactive interface (**GUI**).
- Support for a wide range of visualisation schemes such as **map projection** and **unit sphere projection**.
- Supports the determination of the mechanical stability of crystals at **atmospheric** and **high pressures** using the **Born mechanical stability criterion**.
- Support for analysis of properties such as **hardness**, **fracture toughness**, **average Cauchy pressure**, **areal Poisson’s ratio**, etc.
- Provides a **native interface** for calling data from the new (default) and legacy APIs of the [Materials Project's database](https://next-gen.materialsproject.org/).

## Graphical User Interface (GUI)
<div align=center><img src="https://github.com/ranzhengcode/VELAS/blob/main/doc/VELAS_GUI.png" width="481" height="785"></img></div>

## INSTALL  
### Installation Scheme A
- Run **install_VELAS** or **velasGUI**, VELAS will be automatically installed.
### Installation Scheme B
- (1) Unzip the downloaded **VELAS** archive into any available path;  
- (2) Start **GNU Octave** and click on the **Edit** option in the menu bar;  
- (3) Click on **Set Path** in the **Edit** drop-down box;  
- (4) Click **Add Folder** in the **Set Path** dialog box;  
- (5) Click on **Folder with Subfolders** in the **Add Folder** drop-down list box;  
- (6) In the pop-up dialog box, find the path of the unpacked VELAS folder in **(1)**, and select the VELAS folder, then click **Choose**;  
- (7) Click **Save** in the **Set Path** dialog box to complete the installation;
- (8) **Enjoy**!

## GET STARTED
VELAS supports both **script** and **GUI** to run.  
- **1**: Run **VELAS** using **velasScript**.  Type `velasScript` in the **command window** of **GNU Octave** and press **Enter** to run.
- **2**: Run **VELAS** using **velasGUI**.  Type `velasGUI` in the **command window** of **GNU Octave** and press **Enter** to run.

## Tested systems
**Windows 10** and **Ubuntu 18.04**.

## Languages
**GUN Octave** (Ver. 5.2.0 - latest, Recommended), in full support of **MATLAB**.

## ColorMap
**Support 75 kinds of colormap:**  
'viridis' (default), 'inferno', 'plasma', 'magma', 'rocket', 'mako', 'flare', 'crest', 'vlag', 'icefire','seismic'
'cool', 'summer', 'copper', 'hot', 'ocean', 'gray', 'bone', 'Spectral', 'coolwarm', 'pink', 'spring', 'autumn',
'winter', 'thermal', 'haline', 'solar', 'ice', 'deep', 'dense', 'algae', 'matter', 'turbid', 'speed', 'amp', 
'tempo', 'rain', 'phase', 'balance', 'delta', 'curl', 'diff', 'tarn', 'cubehelix', 'turbo','Blues', 'BuGn', 
'BuPu', 'GnBu', 'Greens', 'Greys', 'Oranges', 'OrRd', 'PuBu', 'PuBuGn', 'PuRd', 'Purples', 'RdPu', 'Reds', 
'YlGn', 'YlGnBu', 'YlOrBr', 'YlOrRd', 'afmhot', 'gistheat', 'BrBG', 'bwr', 'coolwarmC', 'PiYG', 'PRGn', 
'PuOr', 'RdBu', 'RdGy', 'RdYlBu', 'RdYlGn'  
**Note: If the colormap above is not in the drop-down list box, check the custom colormap checkbox and enter the name of one of the above colormaps.** 

**Setting your own colormap:**  
You can define your own colormap and store it in the valesColormap.mat file, and then import your colormap via custom colormap.  
**Note: the name of the colormap you define cannot be the same as the existing colormap in valesColormap.mat, otherwise it will overwrite the existing colormap.** 

## Supported systems
GNU/Linux, BSD, macOS, Windows.

## Contact Information
**Email**: ranzheng@outlook.com  
Please **don't hesitate** to contact us if you have any questions about **using VELAS** or suggestions for **improving VELAS**.

## How to Cite
Z. Ran, C.M. Zou, et al., VELAS: An open-source toolbox for visualization and analysis of elastic anisotropy. Computer Physics Communications, 283 (2023) 108540.  
[(**DOI:https://doi.org/10.1016/j.cpc.2022.108540**)](https://doi.org/10.1016/j.cpc.2022.108540).  
**with** the access link: https://github.com/ranzhengcode/VELAS. 
