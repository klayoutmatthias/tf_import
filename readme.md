
# Cadence techfile import for KLayout

This macro adds a new entry to the "File" menu below "Load Layer Properties".
This function will ask for the path to a Cadence techfile. It will read the 
techfile and create layer properties from it.

The script needs a ".drf" (display resources) file too. It will look for 
any file with extension "drf" next to the techfile. If there are multiple ones,
a dialog will be shown to select one.

If no stream layers are specified in the techfile, it will also look for a
layer mapping file (one with extension ".layermap") next to the techfile.

The script will import the techfile and set the layer properties accordingly. 
These properties can then be saved using "Save Layer Properties" from the "File" menu.

Note: the script is able to parse simple forms of techfiles but will not execute 
embedded Skill code correctly. The best way is to dump a Cadence ASCII techfile 
and import that file.

## Batch mode

The macro will provide a batch mode which allows converting a techfile into
a ".lyp" file on the command line. 

Once the package is installed, batch mode can be used this way:

```
klayout -z -rd tf_file=<path_to_your_techfile> -rd lyp_file=<path_to_the_output_lyp>
```

Note for Unix users: this mode requires a DISPLAY. If you need to run it on 
a headless server, use "xvfb" to provide a dummy display.

